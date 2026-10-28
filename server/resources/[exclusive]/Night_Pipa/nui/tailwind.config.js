export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Poppins', 'sans-serif'],
      },
      colors: {
        panel: 'var(--panel)',
        'panel-2': 'var(--panel-2)',
        line: 'var(--border)',
        'fill-1': 'var(--fill-1)',
        't-1': 'var(--text)',
        't-2': 'var(--text-2)',
        't-3': 'var(--text-3)',
        money: 'var(--money)',
        danger: 'var(--danger)',
        primary: 'hsl(var(--primary-color) / <alpha-value>)',
        secondary: 'rgb(5 7 13 / <alpha-value>)',
      },
    },
  },
  plugins: [],
}
