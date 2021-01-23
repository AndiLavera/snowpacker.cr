require "../engine"

Snowpacker::Engine.configure do |config|
  # Where to build snowpack to (out dir)
  config.build_dir = "public"

  # url to use for assets IE: /snowpacker/xyz.css, gets built to public/frontend
  config.output_dir = "snowpacker"

  # Where to find the config directory
  config.config_path = File.join("config", "snowpacker")
  config.mount_path = File.join("app", "snowpacker")
  config.manifest_file = File.join(config.build_dir, config.output_dir, "manifest.json")

  # Where to find the snowpack config file
  config.config_file = File.join(config.config_path, "snowpack.config.js")

  # Where to find the babel config file
  config.babel_config_file = File.join(config.config_path, "babel.config.js")

  # Where to find the postcss config file
  config.postcss_config_file = File.join(config.config_path, "postcss.config.js")

  # Where to find your snowpack files
  config.entrypoints_dir = "entrypoints"

  # What port to run snowpacker with
  config.port = "4035"

  # What hostname to use
  config.hostname = "localhost"

  # Whether or not to use https
  # https://www.snowpack.dev/#https%2Fhttp2
  config.https = false
end
