#!/bin/bash

# Colores para output
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" ]]; then
    GREEN="\033[0;32m"
    BLUE="\033[0;34m"
    RED="\033[0;31m"
    YELLOW="\033[1;33m"
    NC="\033[0m"
fi

# Verificar y crear package.json para frontend
create_frontend_package() {
    echo -e "${BLUE}Configurando frontend...${NC}"
    
    mkdir -p frontend
    cat > frontend/package.json << EOL
{
  "name": "aet-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "^13.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-query": "^3.39.0",
    "axios": "^1.6.0",
    "tailwindcss": "^3.3.0",
    "lucide-react": "latest"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/node": "^18.0.0",
    "typescript": "^5.0.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOL

    # Crear archivo de configuración de Next.js
    cat > frontend/next.config.js << EOL
/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  swcMinify: true
}
EOL

    # Crear archivo index.tsx
    mkdir -p frontend/src/pages
    cat > frontend/src/pages/index.tsx << EOL
import React from 'react';
import { Shield } from 'lucide-react';

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="container mx-auto px-4 py-16">
        <div className="flex items-center justify-center">
          <Shield className="w-12 h-12 text-purple-400" />
          <h1 className="text-4xl font-bold text-white ml-4">
            AET Security Platform
          </h1>
        </div>
      </div>
    </div>
  );
}
EOL
}

# Verificar y crear package.json para backend
create_backend_package() {
    echo -e "${BLUE}Configurando backend...${NC}"
    
    mkdir -p backend/src
    cat > backend/package.json << EOL
{
  "name": "aet-backend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "nodemon src/index.js",
    "start": "node src/index.js",
    "build": "tsc"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "pg": "^8.11.0",
    "dotenv": "^16.3.1",
    "winston": "^3.11.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.2",
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "typescript": "^5.3.0"
  }
}
EOL

    # Crear archivo principal de backend
    cat > backend/src/index.js << EOL
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

app.listen(port, () => {
  console.log(\`Server running on port \${port}\`);
});
EOL
}

# Actualizar Dockerfile del frontend
update_frontend_dockerfile() {
    echo -e "${BLUE}Actualizando Dockerfile del frontend...${NC}"
    
    cat > frontend/Dockerfile << EOL
# Etapa de desarrollo
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar archivos de configuración
COPY package*.json ./
COPY next.config.js ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:18-alpine

WORKDIR /app

# Copiar archivos necesarios desde el builder
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
EOL
}

# Actualizar Dockerfile del backend
update_backend_dockerfile() {
    echo -e "${BLUE}Actualizando Dockerfile del backend...${NC}"
    
    cat > backend/Dockerfile << EOL
# Etapa de desarrollo
FROM node:18-alpine

WORKDIR /app

# Copiar archivos de configuración
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY . .

EXPOSE 4000

# Usar nodemon en desarrollo
CMD ["npm", "run", "dev"]
EOL
}

# Actualizar docker-compose.yml
update_docker_compose() {
    echo -e "${BLUE}Actualizando docker-compose.yml...${NC}"
    
    cat > docker-compose.yml << EOL
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    environment:
      - NODE_ENV=development
      - NEXT_PUBLIC_API_URL=http://localhost:4000
    depends_on:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - PORT=4000
      - DATABASE_URL=postgresql://postgres:password@db:5432/aetdb
    depends_on:
      - db

  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=aetdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
EOL
}

# Inicializar npm para ambos proyectos
initialize_npm() {
    echo -e "${BLUE}Inicializando npm...${NC}"
    
    # Frontend
    cd frontend
    echo -e "${YELLOW}Instalando dependencias del frontend...${NC}"
    npm install
    cd ..
    
    # Backend
    cd backend
    echo -e "${YELLOW}Instalando dependencias del backend...${NC}"
    npm install
    cd ..
}

# Función principal
main() {
    echo -e "${BLUE}=== Corrigiendo configuración de npm y package.json ===${NC}"
    
    create_frontend_package
    create_backend_package
    update_frontend_dockerfile
    update_backend_dockerfile
    update_docker_compose
    initialize_npm
    
    echo -e "\n${GREEN}¡Configuración completada!${NC}"
    echo -e "\nPara iniciar el proyecto:"
    echo -e "docker-compose up --build"
}

# Ejecutar script
main