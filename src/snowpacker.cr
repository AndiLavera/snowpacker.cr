module Snowpacker
  VERSION = "0.1.0"

  def self.config
    Engine.instance.config
  end

  def self.run
    Engine.run
  end
end

require "./snowpacker/engine"
