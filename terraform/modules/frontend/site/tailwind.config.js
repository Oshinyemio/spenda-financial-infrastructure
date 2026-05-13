/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",

  content: [
    "./*.{html,js}",
    "./src/**/*.{html,js}",
    "./dist/**/*.{html,js}",
  ],

  safelist: [
    "font-550",
    "border-l-4",
    "border-red-400",
    "border-gray-300",
    "border-gray-400",
    "bg-red-500",
    "bg-gray-400",
  ],

  theme: {
    extend: {
      colors: {

        "primary-accent-dark": "#5A2EB2",
        "primary-accent-lighter": "#a678f1ff",

        "primary-accent-tint": "#EDE8FD",
        "primary-accent-light": "#C4ADFA",
        "primary-accent": "#7A42F4",
        "primary-accent-pressed": "#33137e",


        "secondary-accent": "#00D1B2",
        "secondary-accent-dark": "#00A896",
        "secondary-accent-light": "#00D1B2ff",
        "secondary-accent-lighter": "#00D1B2ff",

        "spenda-white": "#f9fafb",

        "base-background": "#F3F3F3",
        "text-main": "#1A202C",
        "text-muted": "#A0AEC0",

        "highlight-light-turquoise": "#B2F5EA",
        "error-soft-red": "#F56565",
        "success-soft-green": "#00D1B2",
        "warning-soft-yellow": "#ECC94B",
        "neutral-light-gray": "#F3F3F3",
        "neutral-card-gray": "#fafafa",

        "bg-page-buttons": "#3f3f3f",
        'hover-dark': '#3f3f3f',
        "premium-black": "#12100f",

        // -----------------------------
        // Finance semantic colors (ADD THESE)
        // -----------------------------
        "finance-savings": "#6bcfff",
        "finance-investments": "#3b82f6",

        "finance-credit": "#f59e0b",
        "finance-loc": "#e8ad0a",
        "finance-loan": "#E8650A",

        "wants": "#f59e0b",
        "flexible-needs": "#e8ad0a",
        "fixed-needs": "#E8650A",

        "loan-color": "#ADE8F4",
        "cc-color": "#00B4D8",

        // For semantic colors, we can use CSS variables to allow dynamic theming (light/dark mode)
        'bg-page': 'rgb(var(--color-bg-page) / <alpha-value>)',
        'surface': 'rgb(var(--color-surface) / <alpha-value>)',
        'border-subtle': 'rgb(var(--color-border-subtle) / <alpha-value>)',
        'border-main': 'rgb(var(--color-border-main) / <alpha-value>)',
        'text-main': 'rgb(var(--color-text-main) / <alpha-value>)',
        'text-muted': 'rgb(var(--color-text-muted) / <alpha-value>)',
        'text-soft': 'rgb(var(--color-text-soft) / <alpha-value>)',
      },
      fontFamily: {
        body: ["Quicksand", "sans-serif"],
        heading: ["Manrope", "sans-serif"],   // or whatever you're testing
        logo: ["Poppins", "sans-serif"],
        mono: ["IBM Plex Mono", "monospace"],
      },
      boxShadow: {
        subtle:
          "0 4px 6px rgba(0, 0, 0, 0.05), 0 1px 3px rgba(0, 0, 0, 0.03)",
      },
      borderRadius: {
        xl: "0.75rem",
        "2xl": "1rem",
      },
      maxWidth: {
        "mainWidth": "90rem",
        "indexWidth": "80rem",
        "modalWidth": "39rem",
        "7xl": "84rem",
        "8xl": "98rem",  // For Main content in app
        "9xl": "100rem", // For Headers in app
        "550": "550px",
        "searchHeading": "60rem",
        "searchSubtext": "40rem",
      },
      fontSize: {
        hero2: ["clamp(2.6rem, 5vw, 4rem)", { lineHeight: "0", fontWeight: "600" }],
        hero: "clamp(2.6rem, 5vw, 4rem)",
        "3.5xl": "2rem",
      },
      zIndex: {
        modal: '50',        // e.g., for modal overlay
        dropdown: '1000',     // for dropdown menus inside modal
        tooltip: '70',      // optional, for tooltips if needed
      },
      height: {
        promoCard: "210px",
      },
      transitionProperty: {
        // add custom transition for your money summary panel
        'money-summary': 'opacity',
      },
      transitionDuration: {
        'money-summary': '300ms', // smooth fade
      },
      transitionTimingFunction: {
        'money-summary': 'ease-in-out',
      },
    },
  },

  plugins: [
    require("@tailwindcss/aspect-ratio"),
    function ({ addBase, theme }) {
      addBase({
        body: {
          fontFamily: theme("fontFamily.body"),
        },
      });
    },
  ],
};