require "socket"

module Snowpacker
  # :nodoc:
  module Utils
    extend self

    # :nodoc:
    def detect_port! : Bool
      hostname = Snowpacker.config.hostname
      port = Snowpacker.config.port
      server = TCPServer.new(hostname, port)
      server.close

      true
    rescue e : Socket::BindError
      Engine::Log.error { e }

      false
    end
  end
end
