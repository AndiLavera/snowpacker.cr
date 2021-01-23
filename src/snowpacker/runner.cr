require "./utils"

module Snowpacker
  struct Runner
    def run
      Snowpacker.config.env == "development" ? dev : build
    end

    private def build
      write
      snowpacker_command(env = :production, cmd = :build)
    end

    # Serve for development
    private def dev
      Utils.detect_port!
      write
      snowpacker_command(env = :development, cmd: :dev)
    end

    # Write the `snowpack.config.js` file
    private def write
      # ECR.render("#{}")
    end

    private def snowpacker_command(env = "", cmd = "")
      env = ENV["NODE_ENV"]? || env
      config_path = Engine.config.config_path
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
