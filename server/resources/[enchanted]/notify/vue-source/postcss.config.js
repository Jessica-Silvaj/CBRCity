export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
    cssnano: { preset: ["default", { minifyGradients: false }] },
  },
};
