require "../spec_helper"

module Snowpacker
  describe Runner do
    it "can run dev" do
      engine = Engine.configure do |config|
        config.config_path = "public"
        config.config_file = "#{Dir.current}/src/snowpacker/templates/snowpack.config.js"
        config.babel_config_file = "#{Dir.current}/src/snowpacker/templates/bable.config.js"
        config.postcss_config_file = "#{Dir.current}/src/snowpacker/templates/postcss.config.js"
        config.build_dir = "build"
        config.mount_path = "/my/mount/path"
        config.manifest_file = "manifest.json"
        config.output_dir = "public"
        config.port = "3333"
        config.hostname = "0.0.0.0"
      end

      Runner.dev
    end
  end
end
