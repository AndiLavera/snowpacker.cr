require "./env"
require "./utils"

module Snowpacker
  class Runner
    # getter config_file : String

    # def initialize
    #   Env.set_env_variables
    # end

    def self.build
      Env.set_env_variables
      snowpacker_command(env = :production, cmd = :build)
    end

    # Serve for development
    def self.dev
      Utils.detect_port!
      Env.set_env_variables
      self.snowpacker_command(env = :development, cmd: :dev)
    end

    private def self.snowpacker_command(env = "", cmd = "")
      env = ENV["NODE_ENV"]? || env
      config_file = Engine.config.config_file
      command = "NODE_ENV=#{env} npx run snowpack #{cmd} --config #{config_file}"

      system(command)
    end
  end
end
