require "../spec_helper"

module Snowpacker
  describe Runner do
    it "can run dev" do
      engine = Engine.configure do |config|
        config.config_path = "public"
        config.port = 4444
        config.hostname = "1.1.1.1"
        config.enabled = true
        config.node_env = "production"
        config.asset_regex = /.js/
      end

      Engine.run
    end
  end
end
