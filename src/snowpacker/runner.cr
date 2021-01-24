require "./utils"

module Snowpacker
  struct Runner
    def run
      dev if Snowpacker.config.enabled
    end

    private def build
      snowpacker_command(cmd: "build")
    end

    # Serve for development
    private def dev
      Utils.detect_port!
      snowpacker_command(cmd: "dev")
    end

    private def snowpacker_command(cmd = "")
      env = ENV["NODE_ENV"]? || Snowpacker.config.node_env
      config_path = Snowpacker.config.config_path
      command = "NODE_ENV=#{env} npx snowpack #{cmd} --config #{File.join(config_path, "snowpack.config.js")}"

      Process.new(
        command,
        shell: true,
        output: Process::Redirect::Inherit,
        error: Process::Redirect::Inherit
      )
    end
  end
end
