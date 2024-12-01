#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

# Configuración
DOMAIN="hapariciop.uk"
PROJECT_NAME="aet-security"
CLOUDFLARE_ACCOUNT_ID="af1676425306ed5a03bdb8fcb6d12667" # Necesitarás reemplazar esto

echo -e "${BLUE}=== Preparando despliegue de AET Security a Cloudflare Pages ===${NC}"

# Verificar wrangler
if ! command -v wrangler &> /dev/null; then
    echo -e "${BLUE}Instalando Wrangler CLI...${NC}"
    npm install -g wrangler
fi

# Preparar el proyecto para producción
echo -e "${BLUE}Preparando proyecto para producción...${NC}"

# Asegurarse de que estamos en el directorio correcto
cd $PROJECT_NAME

# Crear archivo de configuración para Cloudflare Pages
cat > wrangler.toml << EOL
name = "aet-security"
type = "webpack"
account_id = "$CLOUDFLARE_ACCOUNT_ID"
workers_dev = true
route = "$DOMAIN/*"
zone_id = ""

[site]
bucket = "./dist"
entry-point = "workers-site"

[env.production]
name = "aet-security-prod"
route = "$DOMAIN/*"
EOL

# Crear archivo de configuración para el build
cat > .cloudflare/config.json << EOL
{
  "build": {
    "command": "npm run build",
    "output": "dist",
    "publicPath": "/"
  }
}
EOL

# Configurar custom domain en package.json
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
    "deploy": "npm run build && wrangler pages publish dist --project-name=aet-security"
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

# Actualizar vite.config.js para producción
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

# Script de despliegue
cat > deploy.sh << EOL
#!/bin/bash
echo "Iniciando despliegue a Cloudflare Pages..."

# Build del proyecto
npm run build

# Desplegar a Cloudflare Pages
wrangler pages publish dist --project-name=aet-security

# Configurar dominio personalizado
echo "Configurando dominio personalizado..."
wrangler pages domain set aet-security $DOMAIN

echo "Despliegue completado!"
EOL

chmod +x deploy.sh

echo -e "${GREEN}Configuración de despliegue completada!${NC}"
echo -e "Para desplegar el proyecto:"
echo -e "1. Asegúrate de tener tu cuenta de Cloudflare configurada"
echo -e "2. Ejecuta: wrangler login"
echo -e "3. Ejecuta: ./deploy.sh"
echo -e "4. El proyecto estará disponible en: https://$DOMAIN"

# Guía de configuración de DNS
cat > dns-setup.md << EOL
# Configuración de DNS para $DOMAIN

1. Accede a tu panel de Cloudflare
2. Ve a la sección DNS
3. Añade los siguientes registros:

## Registro A
- Nombre: @
- Dirección IPv4: 192.0.2.1 (será reemplazada por Cloudflare)
- Proxy status: Proxied

## Registro CNAME
- Nombre: www
- Target: $DOMAIN
- Proxy status: Proxied

4. Verifica que los nameservers de tu dominio están apuntando a Cloudflare:
   - ns1.cloudflare.com
   - ns2.cloudflare.com
EOL

echo -e "${BLUE}Se ha creado una guía de configuración DNS en dns-setup.md${NC}"
