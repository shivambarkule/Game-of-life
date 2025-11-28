import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        alive: '#10b981',
        dead: '#1f2937',
        enemy: '#ef4444',
        player: '#3b82f6',
      },
    },
  },
  plugins: [],
}
export default config
