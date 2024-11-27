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

# Obtener credenciales de Cloudflare
get_cloudflare_credentials() {
    log "Configurando Cloudflare CLI..."
    
    # Instalar Cloudflare CLI si no está instalado
    if ! command -v cloudflared &> /dev/null; then
        log "Instalando Cloudflare CLI..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install cloudflare/cloudflare/cloudflared
        else
            curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
            chmod +x cloudflared
            sudo mv cloudflared /usr/local/bin
        fi
    fi

    # Login a Cloudflare
    log "Iniciando sesión en Cloudflare..."
    cloudflared login

    # Obtener credenciales
    log "Obteniendo credenciales..."
    export CF_API_TOKEN=$(cloudflared token)
    export CF_ACCOUNT_ID=$(cloudflared tunnel list --output json | jq -r '.[] | select(.name=="auto") | .account')
    
    if [[ -z "$CF_API_TOKEN" || -z "$CF_ACCOUNT_ID" ]]; then
        error "No se pudieron obtener las credenciales de Cloudflare"
    fi

    success "Credenciales de Cloudflare obtenidas"
}

# Preparar el entorno
prepare_environment() {
    log "Preparando entorno de desarrollo..."

    # Verificar Node.js y npm
    if ! command -v node &> /dev/null; then
        log "Instalando Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # Instalar dependencias globales
    npm install -g wrangler @cloudflare/workers-cli

    success "Entorno preparado"
}

# Crear configuración de proyecto
create_project_config() {
    log "Creando configuración del proyecto..."

    cat > wrangler.toml << EOL
name = "cyberaegis"
compatibility_date = "2024-02-19"
workers_dev = true

[site]
bucket = "./dist"

[env.production]
name = "cyberaegis-prod"
workers_dev = false
route = "cyberaegis.hapariciop.uk/*"
zone_id = "${CF_ZONE_ID}"

[build]
command = "npm run build"
[build.upload]
format = "service-worker"

[[kv_namespaces]]
binding = "SESSION_STORE"
preview_id = "preview-namespace-id"
id = "production-namespace-id"
EOL

    success "Configuración del proyecto creada"
}

# Configurar DNS y dominios
setup_dns() {
    log "Configurando DNS..."

    # Crear zona DNS si no existe
    CF_ZONE_ID=$(curl -X POST "https://api.cloudflare.com/client/v4/zones" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data "{\"name\":\"hapariciop.uk\",\"account\":{\"id\":\"${CF_ACCOUNT_ID}\"},\"jump_start\":true}" \
         | jq -r '.result.id')

    export CF_ZONE_ID=$CF_ZONE_ID

    # Configurar registros DNS
    curl -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data "{\"type\":\"A\",\"name\":\"cyberaegis\",\"content\":\"192.0.2.1\",\"ttl\":1,\"proxied\":true}"

    success "DNS configurado"
}

# Configurar seguridad
setup_security() {
    log "Configurando seguridad..."

    # Configurar SSL/TLS
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/settings/ssl" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data '{"value":"strict"}'

    # Configurar WAF
    curl -X POST "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/firewall/rules" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data '[
           {
             "filter": {
               "expression": "cf.threat_score > 20"
             },
             "action": "block"
           }
         ]'

    success "Seguridad configurada"
}

# Desplegar aplicación
deploy_application() {
    log "Desplegando aplicación..."

    # Construir el proyecto
    npm run build

    # Desplegar con Wrangler
    wrangler deploy

    # Verificar despliegue
    DEPLOY_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://cyberaegis.hapariciop.uk")
    if [ "$DEPLOY_STATUS" = "200" ]; then
        success "Aplicación desplegada exitosamente"
    else
        error "Error en el despliegue"
    fi
}

# Configurar monitoreo
setup_monitoring() {
    log "Configurando monitoreo..."

    # Crear monitor de uptime
    curl -X POST "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/monitors" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data "{
           \"type\":\"http\",
           \"name\":\"CyberAegis Monitor\",
           \"url\":\"https://cyberaegis.hapariciop.uk\",
           \"interval\":\"300\",
           \"retries\":2,
           \"timeout\":10
         }"

    success "Monitoreo configurado"
}

# Crear backups automáticos
setup_backups() {
    log "Configurando backups automáticos..."

    mkdir -p scripts/backup
    
    cat > scripts/backup/backup.sh << 'EOL'
#!/bin/bash

BACKUP_DIR="/backups/cyberaegis"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Crear backup de KV Store
wrangler kv:bulk export SESSION_STORE > "${BACKUP_DIR}/kv_backup_${TIMESTAMP}.json"

# Backup de configuración
wrangler kv:bulk export CONFIG_STORE > "${BACKUP_DIR}/config_backup_${TIMESTAMP}.json"

# Comprimir backups
tar -czf "${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz" \
    "${BACKUP_DIR}/kv_backup_${TIMESTAMP}.json" \
    "${BACKUP_DIR}/config_backup_${TIMESTAMP}.json"

# Limpiar backups antiguos
find ${BACKUP_DIR} -type f -mtime +7 -delete
EOL

    chmod +x scripts/backup/backup.sh

    # Agregar tarea cron para backups diarios
    (crontab -l 2>/dev/null; echo "0 0 * * * ${PWD}/scripts/backup/backup.sh") | crontab -

    success "Backups configurados"
}

# Función principal de despliegue automático
main() {
    log "Iniciando despliegue automático de CyberAegis..."

    get_cloudflare_credentials
    prepare_environment
    create_project_config
    setup_dns
    setup_security
    deploy_application
    setup_monitoring
    setup_backups

    success "¡Despliegue automático completado!"
    log "La aplicación está disponible en: https://cyberaegis.hapariciop.uk"
    log "Panel de administración: https://cyberaegis.hapariciop.uk/admin"
}

# Ejecutar el script
main