/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  safelist: ["static"],
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "Manrope",
          "ui-sans-serif",
          "system-ui",
          "sans-serif",
          '"Apple Color Emoji"',
          '"Segoe UI Emoji"',
          '"Segoe UI Symbol"',
          '"Noto Color Emoji"',
        ],
      },
      colors: {
        // Cores dinâmicas do tema — escritas em runtime pelo tema do handover
        // (Theme em vrp/config/Global.lua) via CSS variables no <html>.
        main: "rgb(var(--main) / <alpha-value>)",
        mainHover: "rgb(var(--mainHover) / <alpha-value>)",
        mainText: "rgb(var(--mainText) / <alpha-value>)",
        from: "rgb(var(--from) / <alpha-value>)",
        to: "rgb(var(--to) / <alpha-value>)",
      },
    },
  },
  plugins: [],
};
