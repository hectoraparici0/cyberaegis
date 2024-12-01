#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

PROJECT_NAME="aet-security"
GITHUB_USERNAME=""
GITHUB_TOKEN=""

# Función para manejar errores
handle_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Obtener credenciales de GitHub
get_credentials() {
    echo -e "${YELLOW}Configurando credenciales...${NC}"
    read -p "Ingresa tu nombre de usuario de GitHub: " GITHUB_USERNAME
    read -sp "Ingresa tu token de GitHub: " GITHUB_TOKEN
    echo
}

# Verificar y instalar dependencias
install_dependencies() {
    echo -e "${BLUE}Verificando e instalando dependencias...${NC}"

    # Node.js y npm
    if ! command -v node &> /dev/null; then
        echo "Instalando Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # Docker
    if ! command -v docker &> /dev/null; then
        echo "Instalando Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
    fi

    # Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo "Instalando Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    # pnpm
    if ! command -v pnpm &> /dev/null; then
        echo "Instalando pnpm..."
        npm install -g pnpm
    fi
}

# Crear estructura del proyecto
create_project_structure() {
    echo -e "${BLUE}Creando estructura del proyecto...${NC}"
    
    mkdir -p $PROJECT_NAME/{frontend,backend,nginx,infrastructure/{docker,k8s},docs}
    cd $PROJECT_NAME

    # Frontend
    mkdir -p frontend/{src/{components,pages,layouts,hooks,utils,styles,contexts,services},public}
    
    # Backend
    mkdir -p backend/{src/{controllers,models,routes,services,middleware,utils},config,tests}
}

# Configurar Frontend
setup_frontend() {
    echo -e "${BLUE}Configurando Frontend...${NC}"
    
    cd frontend

    # Inicializar Next.js
    pnpm create next-app . --typescript --tailwind --eslint

    # Instalar dependencias adicionales
    pnpm add @headlessui/react @heroicons/react lucide-react react-query axios recharts @tanstack/react-query

    # Configurar Tailwind
    cat > tailwind.config.js << EOL
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.purple,
        secondary: colors.slate,
      },
    },
  },
  plugins: [],
}
EOL

    cd ..
}

# Configurar Backend
setup_backend() {
    echo -e "${BLUE}Configurando Backend...${NC}"
    
    cd backend

    # Inicializar proyecto
    pnpm init

    # Instalar dependencias
    pnpm add express cors helmet morgan pg redis dotenv winston
    pnpm add -D typescript @types/express @types/node ts-node nodemon

    # Configurar TypeScript
    npx tsc --init

    # Crear archivo principal
    cat > src/index.ts << EOL
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(\`Server running on port \${port}\`);
});
EOL

    cd ..
}

# Crear archivos Docker
create_docker_files() {
    echo -e "${BLUE}Creando archivos Docker...${NC}"

    # Frontend Dockerfile
    cat > frontend/Dockerfile << EOL
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOL

    # Backend Dockerfile
    cat > backend/Dockerfile << EOL
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 4000
CMD ["npm", "start"]
EOL

    # docker-compose.yml
    cat > docker-compose.yml << EOL
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
    environment:
      - NODE_ENV=development
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:password@db:5432/aetdb
    depends_on:
      - db

  db:
    image: postgres:14-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=aetdb
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
EOL
}

# Inicializar Git y subir a GitHub
setup_git() {
    echo -e "${BLUE}Configurando Git y GitHub...${NC}"

    git init

    # Crear .gitignore
    cat > .gitignore << EOL
# Dependencies
node_modules/
.pnpm-store/

# Environment
.env
.env.local
.env.*

# Build
dist/
build/
.next/

# IDE
.vscode/
.idea/

# Logs
*.log
npm-debug.log*

# System
.DS_Store
Thumbs.db
EOL

    # Primer commit
    git add .
    git commit -m "Initial commit"

    # Crear repositorio en GitHub y subir
    curl -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{\"name\":\"$PROJECT_NAME\",\"private\":true}"

    git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
    git branch -M main
    git push -u origin main
}

# Crear scripts de inicio
create_startup_scripts() {
    echo -e "${BLUE}Creando scripts de inicio...${NC}"

    # Script de desarrollo
    cat > dev.sh << EOL
#!/bin/bash
docker-compose up -d
EOL
    chmod +x dev.sh

    # Script de producción
    cat > prod.sh << EOL
#!/bin/bash
docker-compose -f docker-compose.prod.yml up -d
EOL
    chmod +x prod.sh
}

# Función principal
main() {
    echo -e "${BLUE}=== Iniciando configuración automática de AET Security ===${NC}"
    
    get_credentials
    install_dependencies
    create_project_structure
    setup_frontend
    setup_backend
    create_docker_files
    setup_git
    create_startup_scripts

    echo -e "\n${GREEN}¡Configuración completada!${NC}"
    echo -e "\nPara iniciar el desarrollo:"
    echo -e "1. cd $PROJECT_NAME"
    echo -e "2. ./dev.sh"
    
    echo -e "\nAccede a:"
    echo -e "- Frontend: http://localhost:3000"
    echo -e "- Backend: http://localhost:4000"
}

# Manejo de errores
trap 'handle_error "La configuración falló. Revisa los mensajes anteriores."' ERR

# Ejecutar script
main