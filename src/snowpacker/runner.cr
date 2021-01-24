require "./utils"

module Snowpacker
  struct Runner
    def run : Process?
      Snowpacker.config.enabled ? dev : nil
    end

    # Serve for development
    private def dev : Process?
      Utils.detect_port! ? snowpacker_command(cmd: "dev") : nil
    end

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
