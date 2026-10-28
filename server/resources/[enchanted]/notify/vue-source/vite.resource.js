import baseConfig from "./vite.config.js";

export default {
  ...baseConfig,
  build: {
    ...baseConfig.build,
    outDir: "../web-side",
    emptyOutDir: true,
  },
};
