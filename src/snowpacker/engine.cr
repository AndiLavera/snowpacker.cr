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

    # :nodoc:
    def self.config
      Engine.instance.config
    end

    def self.configure(config : Configuration)
      @@instance ||= new(config)
    end

    def self.run
      instance = Engine.instance
      instance.runner.run
    rescue EngineNotConfigured
      instance = Engine.configure(Configuration.new)
      instance.runner.run
    end

    # Configuration method for snowpacker.cr.
    #
    # Usage:
    #
    # ```crystal
    # Snowpacker::Engine.configure do |config|
    #   config.build_dir = "public"
    #
    #   config.output_dir = "snowpacker"
    #
    #   config.config_path = File.join("config", "snowpacker")
    #
    #   config.mount_path = File.join("app", "snowpacker")
    #
    #   config.manifest_file = File.join(config.build_dir, config.output_dir, "manifest.json")
    #
    #   config.config_file = File.join(config.config_path, "snowpack.config.js")
    #
    #   config.babel_config_file = File.join(config.config_path, "babel.config.js")
    #
    #   config.postcss_config_file = File.join(config.config_path, "postcss.config.js")
    #
    #   config.entrypoints_dir = "entrypoints"
    #
    #   config.port = "4035"
    #
    #   config.hostname = "localhost"
    #
    #   config.https = false
    # end
    # ```
    def self.configure(&block)
      raise DuplicateInstanceError.new if @@instance

      config = Configuration.new
      yield config
      Engine.configure(config)
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
