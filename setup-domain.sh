```bash
#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
DOMAIN="hapariciop.uk"
SUBDOMAIN="cyberaegis"
FULL_DOMAIN="$SUBDOMAIN.$DOMAIN"
PROJECT_NAME="cyberaegis"

echo -e "${BLUE}=== Configuración Automática de Dominio para CyberAegis ===${NC}"

# Solicitar credenciales
echo -e "\n${YELLOW}Ingresa tus credenciales de Cloudflare:${NC}"
read -p "Email de Cloudflare: " CF_EMAIL
read -sp "API Token de Cloudflare: " CF_API_TOKEN
echo
read -p "Account ID de Cloudflare: " CF_ACCOUNT_ID
read -p "Zone ID de Cloudflare: " CF_ZONE_ID

# Verificar credenciales
verify_credentials() {
    echo -e "\n${YELLOW}Verificando credenciales...${NC}"
    
    response=$(curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
         -H "Authorization: Bearer $CF_API_TOKEN")
    
    if echo "$response" | grep -q "\"success\":true"; then
        echo -e "${GREEN}✓ Credenciales válidas${NC}"
        return 0
    else
        echo -e "${RED}✗ Credenciales inválidas${NC}"
        return 1
    fi
}

# Configurar DNS
setup_dns() {
    echo -e "\n${YELLOW}Configurando DNS...${NC}"
    
    # Crear registro DNS
    curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
         -H "Authorization: Bearer $CF_API_TOKEN" \
         -H "Content-Type: application/json" \
         --data "{
           \"type\": \"CNAME\",
           \"name\": \"$SUBDOMAIN\",
           \"content\": \"$PROJECT_NAME.pages.dev\",
           \"ttl\": 1,
           \"proxied\": true
         }"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ DNS configurado correctamente${NC}"
    else
        echo -e "${RED}✗ Error al configurar DNS${NC}"
        return 1
    fi
}

# Configurar SSL
setup_ssl() {
    echo -e "\n${YELLOW}Configurando SSL...${NC}"
    
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/ssl" \
         -H "Authorization: Bearer $CF_API_TOKEN" \
         -H "Content-Type: application/json" \
         --data '{"value":"strict"}'
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ SSL configurado correctamente${NC}"
    else
        echo -e "${RED}✗ Error al configurar SSL${NC}"
        return 1
    fi
}

# Configurar Pages
setup_pages() {
    echo -e "\n${YELLOW}Configurando Cloudflare Pages...${NC}"
    
    # Actualizar configuración de proyecto
    curl -X POST "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/pages/projects" \
         -H "Authorization: Bearer $CF_API_TOKEN" \
         -H "Content-Type: application/json" \
         --data "{
           \"name\": \"$PROJECT_NAME\",
           \"production_branch\": \"main\",
           \"build_config\": {
             \"build_command\": \"npm run build\",
             \"destination_dir\": \".next/static\",
             \"root_dir\": \"/\"
           }
         }"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Pages configurado correctamente${NC}"
    else
        echo -e "${RED}✗ Error al configurar Pages${NC}"
        return 1
    fi
}

# Configurar Wrangler
setup_wrangler() {
    echo -e "\n${YELLOW}Configurando Wrangler...${NC}"
    
    cat > wrangler.toml << EOL
name = "$PROJECT_NAME"
compatibility_date = "2024-02-19"

[env.production]
routes = [
  { pattern = "$FULL_DOMAIN", custom_domain = true }
]

[site]
bucket = ".next/static"

[build]
command = "npm run build"
[build.upload]
format = "service-worker"
EOL
    
    echo -e "${GREEN}✓ Wrangler configurado${NC}"
}

# Verificar estado
check_status() {
    echo -e "\n${YELLOW}Verificando estado del dominio...${NC}"
    
    response=$(curl -s -I "https://$FULL_DOMAIN")
    http_code=$(echo "$response" | grep "HTTP/" | cut -d' ' -f2)
    
    if [ "$http_code" = "200" ]; then
        echo -e "${GREEN}✓ Dominio accesible (HTTP 200)${NC}"
    else
        echo -e "${YELLOW}! Dominio no accesible aún (HTTP $http_code)${NC}"
        echo -e "Puede tomar unos minutos para la propagación DNS"
    fi
}

# Desplegar UI
deploy_ui() {
    echo -e "\n${YELLOW}Desplegando UI...${NC}"
    
    # Build del proyecto
    npm run build
    
    # Desplegar a Cloudflare
    wrangler deploy
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ UI desplegada correctamente${NC}"
    else
        echo -e "${RED}✗ Error al desplegar UI${NC}"
        return 1
    fi
}

# Función principal
main() {
    verify_credentials || exit 1
    setup_dns || exit 1
    setup_ssl || exit 1
    setup_pages || exit 1
    setup_wrangler || exit 1
    deploy_ui || exit 1
    check_status
    
    echo -e "\n${GREEN}=== Configuración completada ===${NC}"
    echo -e "\nInformación importante:"
    echo -e "URL: https://$FULL_DOMAIN"
    echo -e "Panel de control: https://dash.cloudflare.com"
    
    # Guardar configuración
    cat > domain-config.txt << EOL
Configuración del dominio:
- Dominio: $FULL_DOMAIN
- Proyecto: $PROJECT_NAME
- SSL: Strict
- DNS: Configurado
- Pages: Activado

Próximos pasos:
1. Verificar acceso: https://$FULL_DOMAIN
2. Revisar DNS en Cloudflare
3. Verificar SSL/TLS
4. Monitorear despliegue en Pages

Fecha de configuración: $(date)
EOL
}

# Ejecutar script
main

echo -e "\n${BLUE}La configuración ha sido guardada en domain-config.txt${NC}"
```
