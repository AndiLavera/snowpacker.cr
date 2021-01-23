require "./configuration"

module Snowpacker
  class Engine
    Log = ::Log.for(self)

    property config : Configuration

    def self.instance(config : Configuration)
      @@instance ||= new(config)
    end

    def self.configure(&block)
      raise DuplicateInstanceError.new if @@instance

      config = Configuration.new
      yield config
      Engine.instance(config)
    end

    def initialize(@config : Configuration); end
  end
end
