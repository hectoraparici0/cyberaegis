#!/bin/bash

# Colores
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

# Configuración
DOMAIN="hapariciop.uk"
PROJECT_NAME="cyberaegis"
PORT=3000

echo -e "${BLUE}Configurando CyberAegis Self-hosted${NC}"

# Crear estructura del proyecto
mkdir -p ~/Documents/$PROJECT_NAME
cd ~/Documents/$PROJECT_NAME

# Configurar Docker
echo -e "${GREEN}Configurando Docker...${NC}"
cat > Dockerfile << EOL
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
EOL

# Configurar docker-compose
cat > docker-compose.yml << EOL
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    restart: always
    environment:
      - NODE_ENV=production
    volumes:
      - ./:/app
      - /app/node_modules
      - /app/.next
EOL

# Configurar Nginx
cat > nginx.conf << EOL
server {
    listen 80;
    server_name ${DOMAIN};

    location / {
        proxy_pass http://localhost:${PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Configurar package.json
cat > package.json << EOL
{
  "name": "cyberaegis",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start -p ${PORT}",
    "pm2": "pm2 start npm --name \"cyberaegis\" -- start"
  }
}
EOL

# Configurar next.config.js
cat > next.config.js << EOL
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: 'standalone',
  images: {
    domains: ['${DOMAIN}'],
  },
}

module.exports = nextConfig
EOL

# Crear estructura del proyecto
mkdir -p src/{pages,styles,components}
cat > src/pages/index.js << EOL
import { Shield } from 'lucide-react';

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 flex flex-col items-center justify-center">
      <Shield className="w-16 h-16 text-purple-400 mb-4" />
      <h1 className="text-4xl font-bold text-white mb-2">CyberAegis</h1>
      <p className="text-purple-300">Plataforma de Seguridad Avanzada</p>
      <p className="text-purple-200 mt-4">Self-hosted en ${DOMAIN}</p>
    </div>
  )
}
EOL

# Script de instalación de dependencias
cat > install.sh << EOL
#!/bin/bash

# Actualizar sistema
sudo apt update
sudo apt upgrade -y

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar PM2
sudo npm install -g pm2

# Instalar Docker
sudo apt install -y docker.io docker-compose

# Instalar Nginx
sudo apt install -y nginx

# Configurar Nginx
sudo cp nginx.conf /etc/nginx/sites-available/${DOMAIN}
sudo ln -s /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Configurar SSL
sudo certbot --nginx -d ${DOMAIN} --non-interactive --agree-tos --email your-email@example.com

# Reiniciar Nginx
sudo systemctl restart nginx

# Instalar dependencias del proyecto
npm install
npm install next react react-dom @heroicons/react lucide-react @radix-ui/react-slot class-variance-authority clsx tailwind-merge
npm install -D tailwindcss postcss autoprefixer typescript @types/node @types/react

# Build del proyecto
npm run build

# Iniciar con PM2
pm2 start npm --name "cyberaegis" -- start
pm2 save
pm2 startup
EOL

# Script de deploy
cat > deploy.sh << EOL
#!/bin/bash

# Pull últimos cambios
git pull

# Instalar dependencias
npm install

# Build
npm run build

# Reiniciar PM2
pm2 restart cyberaegis
EOL

# Configurar .gitignore
cat > .gitignore << EOL
node_modules
.next
out
.env
.env.local
.DS_Store
*.log
EOL

# Dar permisos a scripts
chmod +x install.sh deploy.sh

echo -e "${GREEN}¡Configuración completada!${NC}"
echo -e "\nPasos para desplegar:"
echo "1. Sube este código a tu servidor:"
echo "   scp -r ~/Documents/$PROJECT_NAME user@your-server:~/"
echo "2. SSH a tu servidor:"
echo "   ssh user@your-server"
echo "3. Ejecuta el script de instalación:"
echo "   cd $PROJECT_NAME && ./install.sh"
echo "4. Configura tu dominio en tu proveedor DNS:"
echo "   Tipo: A"
echo "   Nombre: @"
echo "   Valor: [IP-DE-TU-SERVIDOR]"

# Guardar información
cat > deployment-info.txt << EOL
Proyecto: CyberAegis (Self-hosted)
URL: https://${DOMAIN}
Puerto: ${PORT}
Fecha: $(date)

Comandos útiles:
- Reiniciar aplicación: pm2 restart cyberaegis
- Ver logs: pm2 logs cyberaegis
- Estado del servicio: pm2 status
- Reiniciar nginx: sudo systemctl restart nginx
- Ver logs nginx: sudo tail -f /var/log/nginx/error.log

Estructura de archivos:
- /etc/nginx/sites-available/${DOMAIN}: Configuración de Nginx
- ~/cyberaegis: Código de la aplicación
EOL

echo -e "\n${BLUE}Información guardada en deployment-info.txt${NC}"
