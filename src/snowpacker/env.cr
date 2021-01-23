module Snowpacker
  class Env
    ENV_PREFIX = "SNOWPACKER"

    # TODO: Not very programmatic...
    def self.set_env_variables(config = Engine.config)
      set_env("CONFIG_PATH", config.config_path)
      set_env("CONFIG_FILE", config.config_file)
      set_env("BABEL_CONFIG_FILE", config.babel_config_file)
      set_env("POSTCSS_CONFIG_FILE", config.postcss_config_file)
      set_env("BUILD_DIR", config.build_dir)
      set_env("MOUNT_PATH", config.mount_path)
      set_env("MANIFEST_FILE", config.manifest_file)
      set_env("OUTPUT_DIR", config.output_dir)
      set_env("PORT", config.port)
      set_env("HOST", config.hostname)
    end

    private def self.set_env(env_var, value)
      ENV["#{ENV_PREFIX}_#{env_var}"] ||= value.to_s
    end
  end
end
