#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
DOMAIN="hapariciop.uk"
PROJECT_NAME="aet-security"

echo -e "${BLUE}=== AET Security Platform - Setup Completo ===${NC}"

# Función para verificar requisitos
verify_requirements() {
    echo -e "\n${YELLOW}Verificando requisitos...${NC}"
    
    # Node.js y npm
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Node.js no encontrado. Instalando...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # pnpm
    if ! command -v pnpm &> /dev/null; then
        echo -e "${RED}pnpm no encontrado. Instalando...${NC}"
        npm install -g pnpm
    fi

    # EdgeDB
    if ! command -v edgedb &> /dev/null; then
        echo -e "${RED}EdgeDB no encontrado. Instalando...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com | sh
    fi

    # Cloudflare Wrangler
    if ! command -v wrangler &> /dev/null; then
        echo -e "${RED}Wrangler no encontrado. Instalando...${NC}"
        npm install -g wrangler
    fi
}

# Función para crear la estructura del proyecto
create_project_structure() {
    echo -e "\n${YELLOW}Creando estructura del proyecto...${NC}"
    
    # Directorios principales
    mkdir -p $PROJECT_NAME
    cd $PROJECT_NAME

    # Estructura de carpetas
    mkdir -p {src/{components,layouts,pages,styles,utils,hooks,services},public/{assets,icons},tests}
    mkdir -p src/components/{ui,forms,charts,modals}
}

# Función para configurar herramientas de desarrollo
setup_dev_tools() {
    echo -e "\n${YELLOW}Configurando herramientas de desarrollo...${NC}"

    # TypeScript
    pnpm add -D typescript @types/node @types/react @types/react-dom
    
    # ESLint y Prettier
    pnpm add -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin prettier eslint-config-prettier eslint-plugin-react eslint-plugin-react-hooks
    
    # Herramientas de test
    pnpm add -D vitest @testing-library/react @testing-library/jest-dom
}

# Función para instalar dependencias principales
install_dependencies() {
    echo -e "\n${YELLOW}Instalando dependencias...${NC}"

    # Dependencias core
    pnpm add react react-dom vite @vitejs/plugin-react lucide-react
    
    # UI y estilos
    pnpm add tailwindcss postcss autoprefixer @headlessui/react
    pnpm add @tailwindcss/forms @tailwindcss/typography @tailwindcss/aspect-ratio
    
    # Routing y estado
    pnpm add react-router-dom @tanstack/react-query zustand
    
    # Utilidades
    pnpm add date-fns zod clsx class-variance-authority
    
    # Gráficos y visualizaciones
    pnpm add recharts
}

# Función para crear archivos de configuración
create_config_files() {
    echo -e "\n${YELLOW}Creando archivos de configuración...${NC}"
    
    # tsconfig.json
    cat > tsconfig.json << 'EOL'
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOL

    # ESLint
    cat > .eslintrc.json << 'EOL'
{
  "root": true,
  "env": { "browser": true, "es2020": true },
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react-hooks/recommended",
    "prettier"
  ],
  "ignorePatterns": ["dist", ".eslintrc.json"],
  "parser": "@typescript-eslint/parser",
  "plugins": ["react-refresh"],
  "rules": {
    "react-refresh/only-export-components": [
      "warn",
      { "allowConstantExport": true }
    ]
  }
}
EOL

    # Prettier
    cat > .prettierrc << 'EOL'
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "printWidth": 100,
  "trailingComma": "es5",
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOL

    # Vite
    cat > vite.config.ts << 'EOL'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});
EOL

    # Tailwind
    cat > tailwind.config.js << 'EOL'
/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
  ],
}
EOL
}

# Función para crear archivos base
create_base_files() {
    echo -e "\n${YELLOW}Creando archivos base...${NC}"
    
    # index.html
    cat > index.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/icons/shield.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AET Security Platform</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOL

    # Archivo principal de estilos
    cat > src/styles/globals.css << 'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;
 
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }
 
  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}
 
@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
    font-feature-settings: "rlig" 1, "calt" 1;
  }
}
EOL
}

# Función principal
main() {
    echo -e "${BLUE}Iniciando configuración completa de AET Security Platform...${NC}"
    
    verify_requirements
    create_project_structure
    setup_dev_tools
    install_dependencies
    create_config_files
    create_base_files
    
    echo -e "${GREEN}¡Configuración completa realizada!${NC}"
    echo -e "Para iniciar el desarrollo:"
    echo -e "1. cd $PROJECT_NAME"
    echo -e "2. pnpm dev"
}

# Manejo de errores
trap 'echo -e "${RED}Error: El proceso falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar script
main
