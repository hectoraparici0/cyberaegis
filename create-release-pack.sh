#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
VERSION="1.0.0"
RELEASE_DIR="aet-security-${VERSION}"
DOMAIN="hapariciop.uk"

echo -e "${BLUE}=== Creando Release Pack AET Security v${VERSION} ===${NC}"

# Crear estructura del release
mkdir -p $RELEASE_DIR/{src,public,scripts,docs,config}
mkdir -p $RELEASE_DIR/src/{components,layouts,pages,hooks,utils,styles}

# Configurar package.json
echo -e "\n${YELLOW}Configurando package.json...${NC}"
cat > $RELEASE_DIR/package.json << EOL
{
  "name": "aet-security",
  "version": "${VERSION}",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "deploy": "./scripts/deploy.sh"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.11.2",
    "@tanstack/react-query": "^4.29.12",
    "lucide-react": "^0.263.1",
    "tailwindcss": "^3.3.3",
    "zustand": "^4.3.8",
    "clsx": "^1.2.1",
    "class-variance-authority": "^0.6.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@vitejs/plugin-react": "^4.0.3",
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.27",
    "typescript": "^5.0.2",
    "vite": "^4.4.5"
  }
}
EOL

# Crear scripts de despliegue
echo -e "\n${YELLOW}Creando scripts de despliegue...${NC}"
mkdir -p $RELEASE_DIR/scripts
cat > $RELEASE_DIR/scripts/deploy.sh << EOL
#!/bin/bash
npm run build
npx wrangler pages deploy dist --project-name=aet-security
EOL
chmod +x $RELEASE_DIR/scripts/deploy.sh

# Configurar Vite
echo -e "\n${YELLOW}Configurando Vite...${NC}"
cat > $RELEASE_DIR/vite.config.ts << EOL
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    sourcemap: true
  },
  server: {
    port: 3000,
    host: true
  }
})
EOL

# Configurar TailwindCSS
echo -e "\n${YELLOW}Configurando TailwindCSS...${NC}"
cat > $RELEASE_DIR/tailwind.config.js << EOL
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

cat > $RELEASE_DIR/postcss.config.js << EOL
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOL

# Crear index.html
echo -e "\n${YELLOW}Creando index.html...${NC}"
cat > $RELEASE_DIR/index.html << EOL
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
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOL

# Crear documentación
echo -e "\n${YELLOW}Creando documentación...${NC}"
cat > $RELEASE_DIR/README.md << EOL
# AET Security Platform v${VERSION}

## Instalación

1. Instalar dependencias:
\`\`\`bash
npm install
\`\`\`

2. Iniciar desarrollo:
\`\`\`bash
npm run dev
\`\`\`

3. Construir para producción:
\`\`\`bash
npm run build
\`\`\`

4. Desplegar:
\`\`\`bash
npm run deploy
\`\`\`

## Estructura del Proyecto

\`\`\`
src/
├── components/    # Componentes reutilizables
├── layouts/       # Layouts de la aplicación
├── pages/        # Páginas principales
├── hooks/        # Custom hooks
├── utils/        # Utilidades
└── styles/       # Estilos globales
\`\`\`

## Configuración

- Node.js >= 16
- npm >= 7
- Cuenta en Cloudflare Pages

## Despliegue

La aplicación se despliega automáticamente a Cloudflare Pages cuando se ejecuta:
\`\`\`bash
npm run deploy
\`\`\`

La aplicación estará disponible en: https://${DOMAIN}
EOL

# Crear archivo de inicio rápido
echo -e "\n${YELLOW}Creando guía de inicio rápido...${NC}"
cat > $RELEASE_DIR/QUICKSTART.md << EOL
# Guía de Inicio Rápido

## Requisitos Previos

1. Instalar Node.js >= 16
2. Instalar npm >= 7
3. Tener una cuenta en Cloudflare

## Pasos para Iniciar

1. Clonar el repositorio:
\`\`\`bash
git clone https://github.com/yourusername/aet-security.git
cd aet-security
\`\`\`

2. Instalar dependencias:
\`\`\`bash
npm install
\`\`\`

3. Iniciar desarrollo:
\`\`\`bash
npm run dev
\`\`\`

4. Abrir http://localhost:3000

## Despliegue

1. Construir para producción:
\`\`\`bash
npm run build
\`\`\`

2. Desplegar a Cloudflare Pages:
\`\`\`bash
npm run deploy
\`\`\`

## Soporte

Para soporte, contactar a:
- Email: support@aetsecurity.com
EOL

# Crear archivo zip del release
echo -e "\n${YELLOW}Creando archivo del release...${NC}"
zip -r "${RELEASE_DIR}.zip" $RELEASE_DIR

echo -e "\n${GREEN}¡Release pack creado exitosamente!${NC}"
echo -e "Ubicación: ${RELEASE_DIR}.zip"
echo -e "\nPara usar:"
echo -e "1. Descomprimir ${RELEASE_DIR}.zip"
echo -e "2. cd ${RELEASE_DIR}"
echo -e "3. npm install"
echo -e "4. npm run dev"
