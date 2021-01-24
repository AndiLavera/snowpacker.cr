require "log"
require "./configuration"
require "./exceptions"
require "./runner"

module Snowpacker
  class Engine
    # :nodoc:
    Log = ::Log.for(self)

    # :nodoc:
    property config : Configuration

    # :nodoc:
    getter runner : Runner

    # :nodoc:
    def self.instance
      @@instance || raise EngineNotConfigured.new
    end

    def self.run
      instance = Engine.instance
      instance.runner.run
    rescue EngineNotConfigured
      @@instance = new(Configuration.new)
      Engine.instance.runner.run
    end

    # Configuration method for snowpacker.cr.
    #
    # **Usage**:
    #
    # ```crystal
    # # Snowpacker::Engine.configure do |config|
    #   # If the dev server & extension middleware should be enabled. Ensure this is `true` when you
    #   # want the dev server to run. Set `false` in production.
    #   config.enabled = ENV["MY_SERVER_ENV"]? == "development"
    #
    #   # The path `snowpack.config.js` will be loaded from.
    #   # config.config_path = Dir.current
    #
    #   # The port requests will be redirected too. This does NOT change the port snowpack actually runs on.
    #   # Make sure this matches the port in your `snowpack.config.js` file. Snowpack defaults to `8080`.
    #   # config.port = 8080
    #
    #   # The hostname requests will be redirected too. This does NOT change the hostname snowpack actually
    #   # runs on. Make sure this matches the hostname in your `snowpack.config.js` file.
    #   # Snowpack defaults to `localhost`.
    #   # config.hostname = "localhost"
    #
    #   # The `NODE_ENV` that will be prepended to the command starting the snowpack dev server. This can
    #   # be overwritten via Crystal's environment variables with `ENV["NODE_ENV"] = "my_env"` if you
    #   # would prefer.
    #   #
    #   # Crystal nor Node can access environment variables outside of their process for safety reasons.
    #   # Because of this, snowpacker.cr prepends the env to the command.
    #   #
    #   # Example: `"NODE_ENV=#{Snowpacker.config.node_env} npx snowpack #{cmd}"
    #   # config.node_env = "development"
    #
    #   # The regex snowpacker.cr uses to match assets. If a request matches this, the request will be
    #   # redirected to snowpacks dev server. The default regex should be fine for most use cases but
    #   # this configuration is exposed for advanced use cases.
    #   # config.asset_regex = /.(css|scss|sass|less|js|ts|jsx|tsx|ico|jpg|jpeg|png|webp|svg)/
    # end
    # ```
    def self.configure(&block)
      raise DuplicateInstanceError.new if @@instance

      config = Configuration.new
      yield config

      @@instance = new(config)
    end

    # :nodoc:
    def initialize(@config : Configuration)
      @runner = Runner.new
    end

    # :nodoc:
    #
    # Reset the current configuration.
    def flush
      @@instance = nil
    end
  end
end
