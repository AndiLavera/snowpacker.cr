require "./utils"

module Snowpacker
  # :nodoc:
  struct Runner
    # Ensures the server should be turned on prior to invoking the command.
    def run : Process?
      Snowpacker.config.enabled ? dev : nil
    end

    # Ensure the port is not in use. If we can bind the port, run the dev server.
    private def dev : Process?
      Utils.detect_port! ? snowpacker_command(cmd: "dev") : nil
    end

    # Runs the actual console command.
    private def snowpacker_command(cmd = "") : Process?
      env = ENV["NODE_ENV"]? || Snowpacker.config.node_env
      config_path = Snowpacker.config.config_path
      command = "NODE_ENV=#{env} npx snowpack #{cmd} --config #{File.join(config_path, "snowpack.config.js")}"

      Process.new(
        command,
        shell: true,
        output: Process::Redirect::Inherit,
        error: Process::Redirect::Inherit
      )
    rescue e : Exception
      Engine::Log.fatal { "Could not start snowpack dev server" }
      Engine::Log.fatal { e }
      nil
    end
  end
end
