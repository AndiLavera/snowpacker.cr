module Snowpacker
  struct Configuration
    # The path `snowpack.config.js` will get written to and loaded from.
    property config_path : String = Dir.current
    property babel_config_path : String? = nil
    property postcss_config_path : String? = nil

    property build_dir : String = "public/dist"
    property mount_path : String = File.join(Dir.current, "public")
    property manifest_file : String? = nil
    property output_dir : String = "dist"

    # The port snowpack's dev server will use.
    property port : Int32 = 3333

    # The host snowpack's dev server will use.
    property hostname : String = "0.0.0.0"

    # The applications env.
    #
    # When set to `"development"` the snowpack server will turn on and static files
    # will be served from said server. When set to anything else such as `"production"`,
    # snowpack will not turn on and static files will be served from the `static_asset_path`.
    property env : String = "development"

    # This property is used when `env` is not `"development"`. This is the path snowpacker.cr
    # will look in for static files.
    property static_asset_path : String = "public/dist"

    # If the snowpack server should communicate with the client via https
    property https : Bool = false
  end
end
