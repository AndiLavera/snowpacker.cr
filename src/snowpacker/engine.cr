require "log"
require "./configuration"

module Snowpacker
  class Engine
    Log = ::Log.for(self)

    property config : Configuration

    def self.instance
      @@instance
    end

    def self.config
      if inst = @@instance
        inst.config
      else
        raise EngineNotConfigured.new
      end
    end

    def self.configure(config : Configuration)
      @@instance ||= new(config)
    end

    def self.configure(&block)
      raise DuplicateInstanceError.new if @@instance

      config = Configuration.new
      yield config
      Engine.configure(config)
    end

    def initialize(@config : Configuration); end

    def flush
      @@instance = nil
    end
  end
end
