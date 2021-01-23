require "socket"

module Snowpacker
  module Utils
    extend self

    def detect_port!
      hostname = Engine.config.hostname
      port = Engine.config.port
      server = TCPServer.new(hostname, port.to_i32)
      server.close
    rescue e : Exception
      Engine::Log.fatal { e }
      port_in_use(port)
      exit 1
    end

    def https?
      ENV["SNOWPACKER_HTTPS"] == "true"
    end

    def dev_server_running?
      host = Engine.config.hostname
      port = Engine.config.port
      connect_timeout = 0.01

      Socket.tcp(host, port, connect_timeout: connect_timeout).close
      true
    rescue Errno::ECONNREFUSED
      false
    end

    def host_with_port
      hostname = Engine.config.hostname
      port = Engine.config.port

      "#{hostname}:#{port}"
    end

    private def port_in_use(port)
      error_message = "\nUnable to start snowpacker dev server\n\n"
      info_message = <<-INFO
        Another program is currently running on port: #{port}
        Please use a different port.
      INFO

      Engine::Log.error { error_message }
      Engine::Log.info { info_message }
    end
  end
end
