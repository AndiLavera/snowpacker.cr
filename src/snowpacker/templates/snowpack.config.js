const path = require("path");

const prefix = "SNOWPACKER";

// Build related items
const MOUNT_PATH =
  process.env[`${prefix}_MOUNT_PATH`] || path.join(__dirname, "/mount");
const OUTPUT_DIR =
  process.env[`${prefix}_OUTPUT_DIR`] || path.join(__dirname, "/output");
const BUILD_DIR =
  process.env[`${prefix}_BUILD_DIR`] || path.join(__dirname, "/dist");
// const ENTRYPOINTS_DIR = process.env[`${prefix}_ENTRYPOINTS_DIR`]

// Config files
const BABEL_CONFIG =
  process.env[`${prefix}_BABEL_CONFIG_FILE`] ||
  path.join(__dirname, "babel.config.js");
const POSTCSS_CONFIG =
  process.env[`${prefix}_POSTCSS_CONFIG_FILE`] ||
  path.join(__dirname, "postcss.config.js");

// Dev server stuff
const HOSTNAME = process.env[`${prefix}_HOSTNAME`] || "0.0.0.0";
const HTTPS = process.env[`${prefix}_HTTPS`] || false;
const PORT = process.env[`${prefix}_PORT`] || 3333;

const mount = {
  [MOUNT_PATH]: `/${OUTPUT_DIR}`,
};

const installOptions = {
  NODE_ENV: true,
};

const devOptions = {
  hostname: HOSTNAME,
  port: parseInt(PORT, 10),
  open: "none",
  out: BUILD_DIR,
  secure: HTTPS === "true",
};

const buildOptions = {
  clean: false,
  baseUrl: `/${OUTPUT_DIR}`,
  metaDir: path.join(OUTPUT_DIR, "__snowpack__"),
  webModulesUrl: path.join(OUTPUT_DIR, "web_modules"),
};

const plugins = [
  [
    "@snowpack/plugin-build-script",
    {
      cmd: `postcss --config ${POSTCSS_CONFIG}`,
      watch: "$1 --watch",
      input: [".css"],
      output: [".css"],
    },
  ],
  [
    "@snowpack/plugin-build-script",
    {
      cmd: `babel --config-file ${BABEL_CONFIG} --filename $FILE`,
      watch: "$1 --watch",
      input: [".js"],
      output: [".js"],
    },
  ],
];

module.exports = {
  mount,
  plugins: plugins,
  installOptions,
  devOptions,
  buildOptions,
};
