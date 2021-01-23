require "../spec_helper"

module Snowpacker
  describe Engine do
    engine = Engine.configure do |config|
      config.config_path = "public"
      config.config_file = "snowpack.config.js"
      config.babel_config_file = "bable.config.js"
      config.postcss_config_file = "postcss.config.js"
      config.build_dir = "build"
      config.mount_path = "/my/mount/path"
      config.manifest_file = "manifest.json"
      config.output_dir = "public"
      config.port = "4444"
      config.hostname = "1.1.1.1"
    end

    it "can be configured" do
      engine.config.config_path.should eq "public"
      engine.config.config_file.should eq "snowpack.config.js"
      engine.config.babel_config_file.should eq "bable.config.js"
      engine.config.postcss_config_file.should eq "postcss.config.js"
      engine.config.build_dir.should eq "build"
      engine.config.mount_path.should eq "/my/mount/path"
      engine.config.manifest_file.should eq "manifest.json"
      engine.config.output_dir.should eq "public"
      engine.config.port.should eq "4444"
      engine.config.hostname.should eq "1.1.1.1"
    end

    it "cannot be configured twice" do
      expect_raises(Snowpacker::DuplicateInstanceError) do
        Engine.configure do |config|
          config.config_path = "public"
          config.config_file = "snowpack.config.js"
          config.babel_config_file = "bable.config.js"
          config.postcss_config_file = "postcss.config.js"
          config.build_dir = "build"
          config.mount_path = "/my/mount/path"
          config.manifest_file = "manifest.json"
          config.output_dir = "public"
          config.port = "4444"
          config.hostname = "1.1.1.1"
        end
      end
    end
  end
end
