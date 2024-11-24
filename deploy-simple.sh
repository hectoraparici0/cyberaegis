#!/bin/bash

echo "Desplegando CyberAegis en hapariciop.uk"

# Instalar dependencias globales
npm install -g wrangler

# Configurar proyecto
cat > wrangler.toml << EOL
name = "cyberaegis"
type = "webpack"
route = "cyberaegis.hapariciop.uk/*"

[site]
bucket = ".next/static"
EOL

# Construir proyecto
npm run build

# Desplegar
wrangler pages publish .next/static

echo "Despliegue completado"
echo "Visita: https://cyberaegis.hapariciop.uk"
