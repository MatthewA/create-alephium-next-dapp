#!/bin/bash

echo "Setting up Alephium skeleton project..."
npx @alephium/cli@latest init $1

echo "Installing NextJS..."
cd $1
npm install next@latest react@latest react-dom@latest

mv package.json package-old.json
jq '.scripts += {"dev":"next dev",}+{"build":"next build",}+{"start":"next start",}+{"lint":"next lint"}' package-old.json > package.json
rm package-old.json

# Setup App routing
mkdir app
mkdir public
mkdir components

# Create layout.tsx
cat > app/layout.tsx << EOF
import "./globals.css";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
EOF

# Create page.tsx
cat > app/page.tsx << EOF
export default function Page() {
  return (
    <h1>Hello, Next.js!</h1>
  )
}
EOF

echo "Installing Tailwind CSS..."
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
rm tailwind.config.js

# Create tailwind config
cat > tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
 
    // Or if using "src" directory:
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Make globals.css
cat > app/globals.css << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

body {
  color: rgb(var(--foreground-rgb));
  background: linear-gradient(
      to bottom,
      transparent,
      rgb(var(--background-end-rgb))
    )
    rgb(var(--background-start-rgb));
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}

EOF

npm install
npm run dev