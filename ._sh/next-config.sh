#!/bin/bash

# Check if package.json exists
if [ ! -f "package.json" ]; then
  echo "Error: package.json not found in the current directory."
  exit 1
fi

# Check if "next", "react", and "react-dom" are listed as dependencies
if ! grep -q '"next"\|react\|react-dom' package.json; then
  echo "Error: 'next', 'react', or 'react-dom' are not listed as dependencies in package.json."
  exit 1
fi

# Function to prompt the user for yes/no answer
confirm_step() {
  while true; do
    read -p "$1 (y/n): " yn
    case $yn in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) echo "Please answer yes or no.";;
    esac
  done
}

# append .env to .gitignore
if confirm_step "Do you want to append .env to .gitignore?"; then
  echo '.env' >> .gitignore
fi


# Install dependencies
if confirm_step "Do you want to add prettier as a dependency with eslint & tailwind configs?"; then
  pnpm add -D prettier eslint-config-prettier prettier-plugin-tailwindcss
fi

# Create eslintrc.json
if confirm_step "Do you want to add prettier to eslintrc.json?"; then
  echo '
  {
    "extends": ["next/core-web-vitals", "prettier"]
  }
  ' > .eslintrc.json
fi

# Create .prettierrc
if confirm_step "Do you want to create .prettierrc?"; then
  echo '
  {
    "trailingComma": "es5",
    "semi": true,
    "tabWidth": 2,
    "singleQuote": true,
    "jsxSingleQuote": false,
    "plugins": ["prettier-plugin-tailwindcss"],
    "pluginSearchDirs": false
  }
  ' > .prettierrc.json
fi

if confirm_step "Do you want to create .prettierignore?"; then
 echo '
  /node_modules
  /.next/
  ' > .prettierignore
fi

if confirm_step "Do you want create a vscode settings file with prettier configs?"; then
 mkdir -p .vscode && echo '{ "editor.defaultFormatter": "esbenp.prettier-vscode", "editor.formatOnSave": true }' > .vscode/settings.json
fi

# Use pnpm exec for shadcn-ui init
if confirm_step "Do you want to initialize shadcn-ui?"; then
  pnpm dlx shadcn-ui@latest init
fi

# Append to app/globals.css
if confirm_step "Do you want to append styles to app/globals.css?"; then
  echo '
  /* Flexbox height fix */
  html,
  body,
  :root {
    height: 100%;
  }

  /* Prefer box-sizing */
  *,
  *::before,
  *::after {
    box-sizing: border-box;
  }

  .text-balance {
    text-align: balance;
  }
  ' >> app/globals.css
fi


if confirm_step "Do you want to add email dev to package.json?"; then
  jq '.scripts += {
    "email": "email dev",
  }' package.json > package.json.tmp && mv package.json.tmp package.json
fi

if confirm_step "Do you want to add additional db scripts to package.json?"; then
  jq '.scripts += {
    "db:sync": "drizzle-kit generate:sqlite drizzle-kit push:sqlite",
    "db:seed": "pnpm dlx tsx lib/db/seed.ts",
    "turso:dev": "turso dev",
    "turso:dev:persist": "turso dev --db-file ./.dev/teacup.db","seed": "prisma",
  }' package.json > package.json.tmp && mv package.json.tmp package.json
fi

if confirm_step "Do you want to add format and format:fix scripts to package.json?"; then
  jq '.scripts += {
    "format": "prettier --check --plugin=prettier-plugin-tailwindcss --ignore-path .gitignore .",
    "format:fix": "prettier --write --plugin=prettier-plugin-tailwindcss --ignore-path .gitignore ."
  }' package.json > package.json.tmp && mv package.json.tmp package.json
fi

echo "Project scaffolded successfully!"
