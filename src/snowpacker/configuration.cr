module Snowpacker
  class Configuration
    # The path `snowpack.config.js` will be loaded from.
    property config_path : String = Dir.current

    # The port requests will be redirected too. This does NOT change the port snowpack actually runs on.
    # Make sure this matches the port in your `snowpack.config.js` file. Snowpack defaults to `8080`.
    property port : Int32 = 8080

    # The hostname requests will be redirected too. This does NOT change the hostname snowpack actually runs on.
    # Make sure this matches the hostname in your `snowpack.config.js` file. Snowpack defaults to `localhost`.
    property hostname : String = "localhost"

    # If the dev server & extension middleware should be enabled. Ensure this is `true` when you
    # want the dev server to run. Set `false` in production.
    property enabled : Bool = false

    # The `NODE_ENV` that will be prepended to the command starting the snowpack dev server. This can
    # be overwritten via Crystal's environment variables with `ENV["NODE_ENV"] = "my_env"` if you
    # would prefer.
    #
    # Crystal nor Node can access environment variables outside of their process for safety reasons.
    # Because of this, snowpacker.cr prepends the env to the command.
    #
    # Example: `"NODE_ENV=#{Snowpacker.config.node_env} npx snowpack #{cmd}"
    property node_env : String = "development"

    # The regex snowpacker.cr uses to match assets. If a request matches this, the request will be
    # redirected to snowpacks dev server. The default regex should be fine for most use cases but
    # this configuration is exposed for advanced use cases.
    property asset_regex : Regex = /.(css|scss|sass|less|js|ts|jsx|tsx|ico|jpg|jpeg|png|webp|svg)/
  end
end
