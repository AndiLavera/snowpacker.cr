module Snowpacker
  class DuplicateInstanceError < Exception
    def initialize
      super("A Snowpack::Engine instance already exists. You are attempting to create another.")
    end
  end

  class EngineNotConfigured < Exception
    def initialize
      super("A Snowpack::Engine instance does not exists.")
    end
  end
end
