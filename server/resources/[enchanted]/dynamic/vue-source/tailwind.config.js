/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
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
        main: "rgb(var(--main) / <alpha-value>)",
        mainHover: "rgb(var(--mainHover) / <alpha-value>)",
        mainText: "rgb(var(--mainText) / <alpha-value>)",
        from: "rgb(var(--from) / <alpha-value>)",
        to: "rgb(var(--to) / <alpha-value>)",
        common: "rgb(var(--common) / <alpha-value>)",
        rare: "rgb(var(--rare) / <alpha-value>)",
        epic: "rgb(var(--epic) / <alpha-value>)",
        legendary: "rgb(var(--legendary) / <alpha-value>)",
      },
      spacing: {
        50: "12.5rem",
      },
    },
  },
  plugins: [],
};
