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

# Función para verificar y crear directorios
create_directory_structure() {
    echo -e "${BLUE}Creando estructura de directorios...${NC}"
    mkdir -p src/components
    mkdir -p public
}

# Función para crear package.json
create_package_json() {
    echo -e "${BLUE}Creando package.json...${NC}"
    cat > package.json << 'EOL'
{
  "name": "aet-security",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "lucide-react": "^0.263.1",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@vitejs/plugin-react": "^4.0.3",
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.27",
    "tailwindcss": "^3.3.3",
    "vite": "^4.4.5"
  }
}
EOL
}

# Función para crear index.html
create_index_html() {
    echo -e "${BLUE}Creando index.html...${NC}"
    cat > index.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/shield.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AET Security Platform</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOL
}

# Función para crear vite.config.js
create_vite_config() {
    echo -e "${BLUE}Creando vite.config.js...${NC}"
    cat > vite.config.js << 'EOL'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true
  },
  server: {
    host: true,
    port: 3000
  }
})
EOL
}

# Función para crear archivos de CSS
create_css_files() {
    echo -e "${BLUE}Creando archivos CSS...${NC}"
    cat > src/index.css << 'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;

html, body, #root {
  height: 100%;
  margin: 0;
  padding: 0;
}
EOL
}

# Función para crear archivos de configuración
create_config_files() {
    echo -e "${BLUE}Creando archivos de configuración...${NC}"
    
    # tailwind.config.js
    cat > tailwind.config.js << 'EOL'
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

    # postcss.config.js
    cat > postcss.config.js << 'EOL'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOL
}

# Función para crear archivos de React
create_react_files() {
    echo -e "${BLUE}Creando archivos de React...${NC}"
    
    # main.jsx
    cat > src/main.jsx << 'EOL'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOL

    # App.jsx
    cat > src/App.jsx << 'EOL'
import Dashboard from './components/Dashboard'

function App() {
  return <Dashboard />
}

export default App
EOL

    # Dashboard.jsx
    cat > src/components/Dashboard.jsx << 'EOL'
import { useState } from 'react';
import { Shield, Lock, AlertCircle, Activity, BarChart, Cloud, 
         Code, Cpu, Smartphone, Wifi, Server, Settings, 
         ChevronRight, AlertTriangle, Timer, Menu } from 'lucide-react';

// [Contenido del Dashboard.jsx que teníamos antes]

const Dashboard = () => {
  // [Contenido del componente Dashboard]
};

export default Dashboard;
EOL
}

# Función para crear archivos de Cloudflare
create_cloudflare_files() {
    echo -e "${BLUE}Creando archivos de Cloudflare...${NC}"
    cat > wrangler.toml << EOL
name = "${PROJECT_NAME}"
compatibility_date = "2023-01-01"

[site]
bucket = "./dist"
EOL
}

# Función para instalar dependencias
install_dependencies() {
    echo -e "${BLUE}Instalando dependencias...${NC}"
    npm install
}

# Función para construir el proyecto
build_project() {
    echo -e "${BLUE}Construyendo el proyecto...${NC}"
    npm run build
}

# Función para desplegar a Cloudflare
deploy_to_cloudflare() {
    echo -e "${BLUE}Desplegando a Cloudflare...${NC}"
    npx wrangler pages deploy dist --project-name=${PROJECT_NAME}
}

# Función principal
main() {
    echo -e "${BLUE}Iniciando configuración completa de AET Security Platform...${NC}"
    
    create_directory_structure
    create_package_json
    create_index_html
    create_vite_config
    create_css_files
    create_config_files
    create_react_files
    create_cloudflare_files
    
    install_dependencies
    build_project
    deploy_to_cloudflare
    
    echo -e "${GREEN}¡Configuración y despliegue completados!${NC}"
    echo -e "Tu aplicación estará disponible en: https://${DOMAIN}"
}

# Manejo de errores
trap 'echo -e "${RED}Error: El proceso falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar script
main
