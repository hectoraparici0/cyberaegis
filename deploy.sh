#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función de logging
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# Verificar dependencias
check_dependencies() {
    log "Verificando dependencias..."
    
    command -v node >/dev/null 2>&1 || error "Node.js no está instalado"
    command -v npm >/dev/null 2>&1 || error "npm no está instalado"
    command -v docker >/dev/null 2>&1 || error "Docker no está instalado"
    command -v docker-compose >/dev/null 2>&1 || error "Docker Compose no está instalado"
    
    success "Todas las dependencias están instaladas"
}

# Crear estructura de directorios
create_directory_structure() {
    log "Creando estructura de directorios..."
    
    mkdir -p .github/workflows
    mkdir -p scripts/{backup,maintenance,deployment}
    mkdir -p config/{nginx,security}
    mkdir -p docker
    
    success "Estructura de directorios creada"
}

# Crear archivos de configuración
create_config_files() {
    log "Creando archivos de configuración..."
    
    # Crear .env.development
    cat > .env.development << 'EOL'
NODE_ENV=development
API_URL=http://localhost:3000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/netfixhub_dev
JWT_SECRET=dev_secret_key_change_in_production
STRIPE_API_KEY=sk_test_your_stripe_test_key
STRIPE_WEBHOOK_SECRET=whsec_your_stripe_webhook_secret
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
EOL

    # Crear .env.production
    cat > .env.production << 'EOL'
NODE_ENV=production
API_URL=https://api.netfixhub.com
DATABASE_URL=postgresql://user:password@production-host:5432/netfixhub_prod
JWT_SECRET=your_secure_production_jwt_secret
STRIPE_API_KEY=sk_live_your_stripe_live_key
STRIPE_WEBHOOK_SECRET=whsec_your_stripe_webhook_secret
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_your_stripe_publishable_key
CLOUDFLARE_API_TOKEN=your_cloudflare_api_token
CLOUDFLARE_ZONE_ID=your_cloudflare_zone_id
CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id
EOL

    # Crear docker-compose.yml
    cat > docker-compose.yml << 'EOL'
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - API_URL=http://backend:8000
    depends_on:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/netfixhub
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=netfixhub
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOL

    # Crear GitHub Actions workflow
    cat > .github/workflows/main.yml << 'EOL'
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: netfixhub_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v3
    
    - name: Test and Deploy
      run: |
        # Tus pasos de test
        echo "Running tests..."
        
        # Si los tests pasan, desplegar
        if [ $? -eq 0 ]; then
          echo "Tests passed, deploying..."
        else
          echo "Tests failed!"
          exit 1
        fi
EOL

    success "Archivos de configuración creados"
}

# Inicializar proyecto
initialize_project() {
    log "Inicializando proyecto..."
    
    # Instalar dependencias del frontend
    cd frontend
    npm install
    cd ..
    
    # Instalar dependencias del backend
    cd backend
    pip install -r requirements.txt
    cd ..
    
    success "Proyecto inicializado"
}

# Configurar base de datos
setup_database() {
    log "Configurando base de datos..."
    
    docker-compose up -d db
    sleep 5  # Esperar a que la base de datos esté lista
    
    cd backend
    python manage.py migrate
    python scripts/create_superuser.py
    cd ..
    
    success "Base de datos configurada"
}

# Desplegar aplicación
deploy_application() {
    log "Desplegando aplicación..."
    
    # Construir frontend
    cd frontend
    npm run build
    cd ..
    
    # Construir y desplegar con Docker Compose
    docker-compose up -d --build
    
    success "Aplicación desplegada"
}

# Configurar Cloudflare
setup_cloudflare() {
    log "Configurando Cloudflare..."
    
    if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
        error "CLOUDFLARE_API_TOKEN no está configurado"
    fi
    
    # Desplegar a Cloudflare Pages
    wrangler deploy
    
    success "Cloudflare configurado"
}

# Función principal
main() {
    log "Iniciando despliegue de CyberAegis..."
    
    check_dependencies
    create_directory_structure
    create_config_files
    initialize_project
    setup_database
    deploy_application
    setup_cloudflare
    
    success "¡Despliegue completado exitosamente!"
    log "La aplicación está disponible en: https://cyberaegis.hapariciop.uk"
    log "Panel de administración: https://cyberaegis.hapariciop.uk/admin"
}

# Ejecutar el script
main

# Crear script de mantenimiento
cat > scripts/maintenance/update.sh << 'EOL'
#!/bin/bash

# Actualizar dependencias
cd frontend && npm update
cd ../backend && pip install -r requirements.txt --upgrade

# Realizar backup
./scripts/backup/backup.sh

# Actualizar certificados SSL
./scripts/maintenance/update_ssl_certs.sh

# Reiniciar servicios
docker-compose restart
EOL

chmod +x scripts/maintenance/update.sh

# Crear script de backup
cat > scripts/backup/backup.sh << 'EOL'
#!/bin/bash

BACKUP_DIR="/backups/netfixhub"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup de la base de datos
docker-compose exec db pg_dump -U postgres netfixhub > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

# Comprimir backup
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" "$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

# Limpiar backups antiguos
find $BACKUP_DIR -type f -mtime +7 -delete
EOL

chmod +x scripts/backup/backup.sh

# Crear script de monitoreo
cat > scripts/maintenance/monitor.sh << 'EOL'
#!/bin/bash

# Verificar servicios
docker-compose ps

# Verificar uso de recursos
docker stats --no-stream

# Verificar logs
docker-compose logs --tail=100
EOL

chmod +x scripts/maintenance/monitor.sh