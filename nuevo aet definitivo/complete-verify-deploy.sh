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

echo -e "${BLUE}=== AET Security Platform - Verificación y Despliegue ===${NC}"

verify_dependencies() {
    echo -e "\n${YELLOW}Verificando dependencias del sistema...${NC}"
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Node.js no encontrado. Instalando...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # Verificar npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}npm no encontrado. Por favor, instala Node.js${NC}"
        exit 1
    fi

    # Instalar Wrangler globalmente si no existe
    if ! command -v wrangler &> /dev/null; then
        echo -e "${YELLOW}Instalando Wrangler CLI...${NC}"
        npm install -g wrangler
    fi

    echo -e "${GREEN}✓ Dependencias verificadas${NC}"
}

verify_project_files() {
    echo -e "\n${YELLOW}Verificando archivos del proyecto...${NC}"
    
    # Verificar package.json
    if [ ! -f "package.json" ]; then
        echo -e "${YELLOW}Creando package.json...${NC}"
        cat > package.json << EOL
{
  "name": "aet-security",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "deploy": "./deploy.sh"
  },
  "dependencies": {
    "lucide-react": "^0.263.1",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.3",
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.27",
    "tailwindcss": "^3.3.3",
    "vite": "^4.4.5",
    "wrangler": "^3.0.0"
  }
}
EOL
    fi

    # Verificar vite.config.js
    if [ ! -f "vite.config.js" ]; then
        echo -e "${YELLOW}Creando vite.config.js...${NC}"
        cat > vite.config.js << EOL
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['lucide-react']
        }
      }
    }
  },
  base: '/',
  server: {
    host: true,
    port: 3000
  }
})
EOL
    fi

    # Verificar tailwind.config.js
    if [ ! -f "tailwind.config.js" ]; then
        echo -e "${YELLOW}Creando tailwind.config.js...${NC}"
        cat > tailwind.config.js << EOL
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOL
    fi

    # Verificar postcss.config.js
    if [ ! -f "postcss.config.js" ]; then
        echo -e "${YELLOW}Creando postcss.config.js...${NC}"
        cat > postcss.config.js << EOL
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOL
    fi

    # Verificar estructura de directorios
    if [ ! -d "src" ]; then
        echo -e "${YELLOW}Creando estructura de directorios...${NC}"
        mkdir -p src/components
    fi

    echo -e "${GREEN}✓ Archivos del proyecto verificados${NC}"
}

setup_cloudflare() {
    echo -e "\n${YELLOW}Configurando Cloudflare...${NC}"
    
    # Crear archivo de configuración de Cloudflare
    cat > wrangler.toml << EOL
name = "${PROJECT_NAME}"
compatibility_date = "2023-01-01"

[site]
bucket = "./dist"
EOL

    echo -e "${GREEN}✓ Configuración de Cloudflare completada${NC}"
}

build_project() {
    echo -e "\n${YELLOW}Construyendo el proyecto...${NC}"
    
    # Instalar dependencias
    npm install

    # Limpiar build anterior
    rm -rf dist

    # Construir proyecto
    npm run build

    if [ ! -d "dist" ]; then
        echo -e "${RED}Error: El build falló${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Build completado${NC}"
}

deploy_to_cloudflare() {
    echo -e "\n${YELLOW}Desplegando a Cloudflare Pages...${NC}"
    
    # Login en Cloudflare si es necesario
    if ! wrangler whoami &> /dev/null; then
        echo -e "${YELLOW}Por favor, inicia sesión en Cloudflare...${NC}"
        wrangler login
    fi

    # Desplegar
    wrangler pages deploy dist --project-name=${PROJECT_NAME}

    # Configurar dominio personalizado
    echo -e "${YELLOW}Configurando dominio personalizado...${NC}"
    wrangler pages project set-domains ${PROJECT_NAME} ${DOMAIN}

    echo -e "${GREEN}✓ Despliegue completado${NC}"
}

# Función principal
main() {
    echo -e "\n${BLUE}Iniciando proceso de verificación y despliegue...${NC}"
    
    verify_dependencies
    verify_project_files
    setup_cloudflare
    build_project
    deploy_to_cloudflare
    
    echo -e "\n${GREEN}¡Proceso completado!${NC}"
    echo -e "Tu proyecto debería estar disponible pronto en: https://${DOMAIN}"
}

# Manejo de errores
trap 'echo -e "\n${RED}Error: El proceso falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar script
main
