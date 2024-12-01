#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
PROJECT_NAME="aet-security"
DOMAIN="aetsecurity.com"
PROJECT_DIR="$HOME/Documents/$PROJECT_NAME"

echo -e "${BLUE}=== Iniciando despliegue de AET Advanced Security Ecosystem ===${NC}"

# Verificar requisitos
check_requirements() {
    echo -e "\n${YELLOW}Verificando requisitos del sistema...${NC}"
    
    # Verificar Homebrew
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Homebrew no está instalado. Instalando...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Instalar o actualizar dependencias
    brew update
    brew install node
    brew install postgresql
    brew install rust
    brew install golang
    brew install docker
    brew install kubectl
    brew install terraform
    
    # Instalar paquetes globales de Node
    npm install -g pnpm
    npm install -g pm2
    npm install -g typescript
    npm install -g wrangler

    echo -e "${GREEN}✓ Requisitos verificados e instalados${NC}"
}

# Configurar estructura del proyecto
setup_project() {
    echo -e "\n${YELLOW}Configurando estructura del proyecto...${NC}"
    
    # Crear directorios
    mkdir -p $PROJECT_DIR/{frontend,backend,mobile,desktop,infrastructure}
    mkdir -p $PROJECT_DIR/frontend/{src,public}
    mkdir -p $PROJECT_DIR/backend/{api,core,services}
    mkdir -p $PROJECT_DIR/mobile/{ios,android}
    mkdir -p $PROJECT_DIR/infrastructure/{k8s,terraform}

    # Copiar archivos de configuración
    cp .env.example $PROJECT_DIR/.env
    cp docker-compose.yml $PROJECT_DIR/
    cp package.json $PROJECT_DIR/

    echo -e "${GREEN}✓ Estructura del proyecto creada${NC}"
}

# Configurar base de datos
setup_database() {
    echo -e "\n${YELLOW}Configurando base de datos...${NC}"
    
    # Iniciar PostgreSQL
    brew services start postgresql
    
    # Crear base de datos y usuario
    psql postgres -c "CREATE DATABASE aet_security;"
    psql postgres -c "CREATE USER aet_admin WITH ENCRYPTED PASSWORD 'secure_password';"
    psql postgres -c "GRANT ALL PRIVILEGES ON DATABASE aet_security TO aet_admin;"

    echo -e "${GREEN}✓ Base de datos configurada${NC}"
}

# Configurar Docker
setup_docker() {
    echo -e "\n${YELLOW}Configurando Docker...${NC}"
    
    # Iniciar Docker Desktop
    open -a Docker
    
    # Esperar a que Docker esté listo
    while ! docker system info > /dev/null 2>&1; do
        echo "Esperando a que Docker inicie..."
        sleep 2
    done
    
    # Construir imágenes
    docker-compose -f $PROJECT_DIR/docker-compose.yml build

    echo -e "${GREEN}✓ Docker configurado${NC}"
}

# Desplegar frontend
deploy_frontend() {
    echo -e "\n${YELLOW}Desplegando frontend...${NC}"
    
    cd $PROJECT_DIR/frontend
    
    # Instalar dependencias
    pnpm install
    
    # Build
    pnpm build
    
    # Desplegar a Cloudflare Pages
    wrangler pages publish dist

    echo -e "${GREEN}✓ Frontend desplegado${NC}"
}

# Desplegar backend
deploy_backend() {
    echo -e "\n${YELLOW}Desplegando backend...${NC}"
    
    cd $PROJECT_DIR/backend
    
    # Instalar dependencias
    pnpm install
    
    # Compilar TypeScript
    pnpm build
    
    # Iniciar con PM2
    pm2 start dist/index.js --name "aet-backend"
    pm2 save

    echo -e "${GREEN}✓ Backend desplegado${NC}"
}

# Construir aplicaciones móviles
build_mobile() {
    echo -e "\n${YELLOW}Construyendo aplicaciones móviles...${NC}"
    
    cd $PROJECT_DIR/mobile
    
    # iOS
    cd ios
    pod install
    xcodebuild -workspace AETSecurity.xcworkspace -scheme AETSecurity -configuration Release
    
    # Android
    cd ../android
    ./gradlew assembleRelease

    echo -e "${GREEN}✓ Aplicaciones móviles construidas${NC}"
}

# Configurar certificados SSL
setup_ssl() {
    echo -e "\n${YELLOW}Configurando certificados SSL...${NC}"
    
    brew install mkcert
    mkcert -install
    mkcert $DOMAIN "*.${DOMAIN}" localhost 127.0.0.1 ::1

    echo -e "${GREEN}✓ Certificados SSL configurados${NC}"
}

# Configurar monitoreo
setup_monitoring() {
    echo -e "\n${YELLOW}Configurando sistema de monitoreo...${NC}"
    
    # Instalar y configurar Prometheus
    brew install prometheus
    brew services start prometheus
    
    # Instalar y configurar Grafana
    brew install grafana
    brew services start grafana

    echo -e "${GREEN}✓ Sistema de monitoreo configurado${NC}"
}

# Función principal
main() {
    echo -e "\n${BLUE}Iniciando despliegue...${NC}"
    
    # Crear archivo de log
    exec 1> >(tee -a "$PROJECT_DIR/deploy.log")
    exec 2>&1
    
    # Ejecutar pasos
    check_requirements
    setup_project
    setup_database
    setup_docker
    deploy_frontend
    deploy_backend
    build_mobile
    setup_ssl
    setup_monitoring
    
    echo -e "\n${GREEN}¡Despliegue completado!${NC}"
    echo -e "\nInformación de acceso:"
    echo -e "- Dashboard: https://dashboard.${DOMAIN}"
    echo -e "- API: https://api.${DOMAIN}"
    echo -e "- Grafana: http://localhost:3000"
    echo -e "- Prometheus: http://localhost:9090"
    
    # Guardar información
    cat > $PROJECT_DIR/deployment-info.txt << EOL
AET Advanced Security Ecosystem
=============================
Fecha de despliegue: $(date)

URLs:
- Dashboard: https://dashboard.${DOMAIN}
- API: https://api.${DOMAIN}
- Monitoreo: http://localhost:3000

Credenciales:
- Base de datos: aet_admin / secure_password
- Grafana: admin / admin (cambiar en primer inicio)

Servicios:
- Frontend: Cloudflare Pages
- Backend: PM2
- Base de datos: PostgreSQL
- Monitoreo: Prometheus + Grafana
EOL

    echo -e "\n${BLUE}La información de despliegue se ha guardado en deployment-info.txt${NC}"
}

# Manejo de errores
trap 'echo -e "\n${RED}Error: El despliegue falló. Consulta los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar
main
