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

echo -e "${BLUE}=== Desplegando actualización de AET Security ===${NC}"

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo -e "${RED}Error: No se encontró package.json${NC}"
    echo -e "Asegúrate de estar en el directorio raíz del proyecto"
    exit 1
fi

# Limpiar caché y módulos anteriores
echo -e "\n${YELLOW}Limpiando caché y módulos antiguos...${NC}"
rm -rf node_modules
rm -rf dist
rm -rf .cache

# Instalar dependencias actualizadas
echo -e "\n${YELLOW}Instalando dependencias...${NC}"
npm install

# Construir el proyecto
echo -e "\n${YELLOW}Construyendo el proyecto...${NC}"
npm run build

# Verificar si el build fue exitoso
if [ ! -d "dist" ]; then
    echo -e "${RED}Error: El build falló${NC}"
    exit 1
fi

# Desplegar a Cloudflare Pages
echo -e "\n${YELLOW}Desplegando a Cloudflare Pages...${NC}"
npx wrangler pages deploy dist --project-name=$PROJECT_NAME

# Verificar el despliegue
echo -e "\n${YELLOW}Verificando despliegue...${NC}"
echo -e "Tu aplicación estará disponible en:"
echo -e "https://${DOMAIN}"
echo -e "https://${PROJECT_NAME}.pages.dev"

echo -e "\n${GREEN}¡Despliegue completado!${NC}"
