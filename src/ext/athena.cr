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
    end
  end
end
