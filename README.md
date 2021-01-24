# Snowpacker.cr

Snowpacker.cr wraps around [Snowpack](https://www.snowpack.dev) and turn's on the Snowpack dev server when enabled.

# Docs

[API Docs](https://andrewc910.github.io/snowpacker.cr/index.html)

# Guide

## Installation

```yml
dependencies:
  snowpacker:
    github: andrewc910/snowpacker.cr
    version: ~> 0.1.0
```

## Configuration

`snowpack.config.js`

This file typically goes in the root directory of your project, however snowpacker.cr passes in the file path via the snowpack cli. You can put this anywhere if you set the configuration `config_path`.

```js
// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  // Files that will be exluded from loading & watching.
  exclude: ["**/node_modules/**/*", "**/lib/**/*"],
  /**
   * Files that will be mounted to Snowpacks dev server. Change the key to the folder(s)
   * that contain your static assets.
   */
  mount: {
    "src/assets": { url: "/" },
  },
  plugins: [
    /* ... */
  ],
  packageOptions: {
    /* ... */
  },
  devOptions: {
    output: "stream", // dont clear terminal
    open: "none", // dont open a web page when the server turns on
    hmr: true, // Enables hot module reloading
  },
  buildOptions: {
    out: "public/dist", // The folder assets will be written to after building
  },
};
```

`snowpacker.cr`

This file can go anywhere. For most frameworks, it would be an **initializer**.

```crystal
require "snowpacker"

Snowpacker::Engine.configure do |config|
  # If the dev server & extension middleware should be enabled. Ensure this is `true` when you
  # want the dev server to run. Set `false` in production.
  config.enabled = ENV["MY_SERVER_ENV"]? == "development"

  # The path `snowpack.config.js` will be loaded from.
  # config.config_path = Dir.current

  # The port requests will be redirected too. This does NOT change the port snowpack actually runs on.
  # Make sure this matches the port in your `snowpack.config.js` file. Snowpack defaults to `8080`.
  # config.port = 8080

  # The hostname requests will be redirected too. This does NOT change the hostname snowpack actually
  # runs on. Make sure this matches the hostname in your `snowpack.config.js` file.
  # Snowpack defaults to `localhost`.
  # config.hostname = "localhost"

  # The `NODE_ENV` that will be prepended to the command starting the snowpack dev server. This can
  # be overwritten via Crystal's environment variables with `ENV["NODE_ENV"] = "my_env"` if you
  # would prefer.
  #
  # Crystal nor Node can access environment variables outside of their process for safety reasons.
  # Because of this, snowpacker.cr prepends the env to the command.
  #
  # Example: `"NODE_ENV=#{Snowpacker.config.node_env} npx snowpack #{cmd}"
  # config.node_env = "development"

  # The regex snowpacker.cr uses to match assets. If a request matches this, the request will be
  # redirected to snowpacks dev server. The default regex should be fine for most use cases but
  # this configuration is exposed for advanced use cases.
  # config.asset_regex = /.(css|scss|sass|less|js|ts|jsx|tsx|ico|jpg|jpeg|png|webp|svg)/
end

# Starts a new process in the background. This is safe to leave as is. If `Snowpacker.config.enabled`
# returns `false`, the dev server will not turn on regardless if this method is invoked or not.
Snowpacker::Engine.run
```

## Framework Support

Snowpacker is designed to be framework agnostic. You will have to write your own middleware to redirect requests to the dev server. However, Snowpacker comes with a few extensions to make your life easier.

> Note: These extensions do NOT serve static files when the snowpack server is turned off. The extensions only handle redirecting requests when the server is enabled. You will still need a piece of middleware to fetch static assets in production. Ensure the snowpacker's middleware is invoked prior to your static file handling middleware in development.

### Amber

TODO

### Athena

In your `snowpacker.cr` file, add `require "snowpacker/ext/athena"` below `require "snowpacker"`.

Snowpacker's Athena extension works off of Athena's event listener system. It listens on the request phase and will return an `ART::Response` object, short circuiting the rest of the listeners, when a file match is found. The default priorty is `200`. This extension exposes another configuration setting `athena_listener_priority`. You can set this to a custom value if you require.

### Lucky

TODO

# Contributing

Fork it (https://github.com/andrewc910/snowpacker.cr/fork)
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature'), also run bin/ameba
Push to the branch (git push origin my-new-feature)
Create a new Pull Request
Don't forget to add proper tests, if possible

# Contributors

- [Andrew Crotwell](https://github.com/andrewc910) - creator & maintainer
