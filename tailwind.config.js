/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["**/*.{dart,html}"],
  theme: {
    extend: {
      colors: {
        primary: {
          light: "var(--color-primary-light)",
          dark: "var(--color-primary-dark)",
        },
        secondary: {
          light: "var(--color-secondary-light)",
          dark: "var(--color-secondary-dark)",
        },
        background: {
          light: "#CFCFCF",
          dark: "#333233",
        },
        text: {
          light: "#333233",
          dark: "#CFCFCF",
        },
        hover: "#1e3a8a",
        dialog: "#1f2937",
        muted: "#9ca3af",
        focus: "#6366f1",
        link: {
          light: "#2563eb",
          dark: "#93c5fd",
        },
        success: {
          light: "#16a34a",
          dark: "#86efac",
        },
        error: {
          light: "#dc2626",
          dark: "#fca5a5",
        },
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
