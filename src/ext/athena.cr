require "athena"

module Snowpacker
  class Configuration
    # :nodoc:
    property athena_listener_priority : Int32 = 200
  end

  module Ext
    module Athena
      @[ADI::Register]
      struct StaticFileListener
        include AED::EventListenerInterface

        def self.subscribed_events : AED::SubscribedEvents
          AED::SubscribedEvents{
            ART::Events::Request => Snowpacker.config.athena_listener_priority,
          }
        end

        # Proxy listener for athena based projects. This does not handle
        # fetching local assets. It will return immediately if `Snowpacker.config.enabled`
        # returns `false`.
        def call(event : ART::Events::Request, _dispatcher : AED::EventDispatcherInterface) : Nil
          # Ensure the server is enabled.
          return unless Snowpacker.config.enabled
          # Ensure the http method is appropriate for fetching assets.
          return unless event.request.method.in? "GET", "HEAD"
          # Ensure the path is loaded - Don't want to redirect to files snowpack doesn't load.
          return unless event.request.path.matches? Snowpacker.config.asset_regex

          request_path = event.request.path

          # File path cannot contains '\0' (NUL) because all filesystem I know
          # don't accept '\0' character as file name.
          if request_path.includes? '\0'
            raise ART::Exceptions::BadRequest.new "File path cannot contain NUL bytes."
          end

          request_path = Path.posix request_path

          # Redirect to the snowpack dev server
          event.response = ART::RedirectResponse.new(
            File.join({"http://#{Snowpacker.config.hostname}:#{Snowpacker.config.port}", request_path})
          )
        end
      end

      @[ADI::Register]
      struct HMRInjector
        include AED::EventListenerInterface

        def self.subscribed_events : AED::SubscribedEvents
          AED::SubscribedEvents{
            ART::Events::Response => Snowpacker.config.athena_listener_priority,
          }
        end

        # Proxy listener for athena based projects. This does not handle
        # fetching local assets. It will return immediately if `Snowpacker.config.enabled`
        # returns `false`.
        def call(event : ART::Events::Response, _dispatcher : AED::EventDispatcherInterface) : Nil
          # Ensure the server is enabled.
          return unless Snowpacker.config.enabled
          # Only inject if HMR is enabled
          return unless Snowpacker.config.hmr
          # Ensure the http method is appropriate for fetching assets.
          return unless event.request.method.in? "GET", "HEAD"
          # Ensure we only inject the script tags into html.
          content_type = event.response.headers["content-type"]?
          return unless content_type
          return unless content_type.includes? "text/html"

          content = event.response.content
          unless content.matches? Snowpacker.config.hmr_matching_regex
            Engine::Log.warn do
              "Could not inject HMR scripts. Could not find </html> or </ html> tag."
            end

            return
          end

          event.response.content = content.gsub(
            Snowpacker.config.hmr_matching_regex,
            <<-STR
            <!--
              HMR Scripts for snowpack. Snowpacker.cr injects these during the response phase. To disable, set `hmr` in the config dsl to false.
            -->
            <script>
              window.HMR_WEBSOCKET_URL = 'ws://#{Snowpacker.config.hostname}:#{Snowpacker.config.port}'
            </script>
            <script src="_snowpack/hmr-client.js" type="module" defer></script>
            </html>
            STR
          )
        end
      end
    end
  end
end
