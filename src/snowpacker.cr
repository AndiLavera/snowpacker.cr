module Snowpacker
  VERSION     = "0.1.0"
  ASSET_REGEX = /.(css|scss|sass|less|js|ts|jsx|tsx|ico|jpg|jpeg|png|webp|svg)/

  def self.config
    Engine.instance.config
  end

  def self.run
    Engine.run
  end
end

require "./snowpacker/engine"
