require "../spec_helper"

module Snowpacker
  describe Engine do
    it "can be configured" do
      engine = Engine.configure do |config|
        config.config_path = "public"
        config.port = 4444
        config.hostname = "1.1.1.1"
        config.enabled = true
        config.node_env = "production"
        config.asset_regex = /.js/
      end

      engine.config.config_path.should eq "public"
      engine.config.port.should eq 4444
      engine.config.hostname.should eq "1.1.1.1"
      engine.config.enabled.should eq true
      engine.config.node_env.should eq "production"
      engine.config.asset_regex.should eq(/.js/)
    end

    it "cannot be configured twice" do
      Engine.configure do |config|
        config.config_path = "public"
        config.port = 4444
        config.hostname = "1.1.1.1"
        config.enabled = true
        config.node_env = "production"
        config.asset_regex = /.js/
      end

      expect_raises(Snowpacker::DuplicateInstanceError) do
        Engine.configure do |config|
          config.config_path = "public"
          config.port = 4444
          config.hostname = "1.1.1.1"
          config.enabled = true
          config.node_env = "production"
          config.asset_regex = /.js/
        end
      end
    end
  end
end
