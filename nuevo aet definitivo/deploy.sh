#!/bin/bash
echo "Iniciando despliegue a Cloudflare Pages..."

# Build del proyecto
npm run build

# Desplegar a Cloudflare Pages
wrangler pages publish dist --project-name=aet-security

# Configurar dominio personalizado
echo "Configurando dominio personalizado..."
wrangler pages domain set aet-security hapariciop.uk

echo "Despliegue completado!"
