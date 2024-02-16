#!/bin/bash

echo "Setting up Alephium skeleton project..."
npx @alephium/cli@latest init $1
cd $1
npm install @alephium/web3-react@latest

echo "Installing NextJS..."
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
import React from "react";
import { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "NextJS!",
  description: "NextJS Project!",
};

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
import React from 'react'

export default function Page() {
  return (
    <h1>Hello, Next.js!</h1>
  )
}
EOF

# Install NextJS Config
cat > next.config.js << EOF
/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    webpack: (config, { isServer }) => {
        if (!isServer) {
            config.resolve.fallback.fs = false
        }
    return config
    }
}

module.exports = nextConfig
EOF

echo "Installing Tailwind CSS..."
npm install -D tailwindcss@3.3.0 postcss autoprefixer
npx tailwindcss init -p
rm tailwind.config.js

# Create tailwind config
cat > tailwind.config.ts << EOF
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

EOF

npm run dev