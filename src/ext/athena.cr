module Snowpacker
  class Configuration
    property athena_listener_priority : Int32 = 200
  end

  @[ADI::Register]
  struct StaticFileListener
    include AED::EventListenerInterface

    def self.subscribed_events : AED::SubscribedEvents
      AED::SubscribedEvents{
        ART::Events::Request => Snowpacker.config.athena_listener_priority,
      }
    end

    # This does not handle fetching local assets. This is only a proxy listener. It will not run
    # if `Snowpacker.config.enabled` returns `false`.
    def call(event : ART::Events::Request, _dispatcher : AED::EventDispatcherInterface) : Nil
      # TODO: Fallback if the request method isn't intended for files.
      return unless Snowpacker.config.enabled
      return unless event.request.method.in? "GET", "HEAD"
      return unless event.request.path.matches? Snowpacker.config.asset_regex

      request_path = event.request.path

      # File path cannot contains '\0' (NUL) because all filesystem I know
      # don't accept '\0' character as file name.
      if request_path.includes? '\0'
        raise ART::Exceptions::BadRequest.new "File path cannot contain NUL bytes."
      end

      request_path = Path.posix request_path

      # Ensure the file exists within the projects asset path. If it does not,
      # snowpack didn't include it.
      return event.response = ART::RedirectResponse.new(
        File.join({"http://#{Snowpacker.config.hostname}:#{Snowpacker.config.port}", request_path})
      )
    end
  end
end
