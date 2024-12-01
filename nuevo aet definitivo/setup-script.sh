#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

echo -e "${BLUE}Creando proyecto AET Advanced Security Ecosystem...${NC}"

# Crear estructura base del proyecto
PROJECT_NAME="aet-security"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Crear estructura de directorios
mkdir -p {apps,packages,platform}/{core,ui,utils}
mkdir -p apps/{aet-shield,aet-vault,aet-guard,aet-scanner,aet-monitor}
mkdir -p platform/{admin,client,api}
mkdir -p mobile/{ios,android}
mkdir -p extension
mkdir -p infrastructure/{docker,k8s,terraform}
mkdir -p docs/{api,guides,architecture}

# Inicializar git
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
out/
.next/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Testing
coverage/

# Mobile
ios/Pods/
android/.gradle/
android/app/build/

# Misc
.cache/
.temp/
EOL

# Inicializar package.json principal
cat > package.json << EOL
{
  "name": "aet-security",
  "version": "1.0.0",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*",
    "platform/*"
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "test": "turbo run test",
    "lint": "turbo run lint"
  },
  "devDependencies": {
    "turbo": "latest"
  }
}
EOL

# Configurar prettier
cat > .prettierrc << EOL
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
EOL

# Crear README.md
cat > README.md << EOL
# AET Advanced Security Ecosystem

Sistema avanzado de seguridad empresarial desarrollado por AET Security.

## Estructura del Proyecto

\`\`\`
aet-security/
├── apps/                    # Aplicaciones individuales
│   ├── aet-shield/         # Firewall IA
│   ├── aet-vault/          # Gestión de datos
│   ├── aet-guard/          # Control de acceso
│   ├── aet-scanner/        # Análisis de vulnerabilidades
│   └── aet-monitor/        # Monitorización
├── packages/               # Paquetes compartidos
│   ├── core/              # Funcionalidad core
│   ├── ui/               # Componentes UI
│   └── utils/            # Utilidades
├── platform/              # Plataforma central
│   ├── admin/            # Panel de administración
│   ├── client/           # Portal de cliente
│   └── api/              # API central
├── mobile/               # Apps móviles
│   ├── ios/             # App iOS
│   └── android/         # App Android
├── extension/            # Extensión de navegador
└── infrastructure/       # Configuración de infraestructura
    ├── docker/          # Configuración Docker
    ├── k8s/            # Kubernetes
    └── terraform/      # IaC
\`\`\`

## Requisitos

- Node.js ≥ 16
- PNPM
- Docker
- Xcode (para iOS)
- Android Studio (para Android)

## Desarrollo

1. Instalar dependencias:
\`\`\`bash
pnpm install
\`\`\`

2. Iniciar en desarrollo:
\`\`\`bash
pnpm dev
\`\`\`

## Licencias

Propiedad de AET Security. Todos los derechos reservados.
EOL

# Crear configuración de VS Code
mkdir .vscode
cat > .vscode/settings.json << EOL
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
EOL

cat > .vscode/extensions.json << EOL
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-typescript-next",
    "prisma.prisma",
    "graphql.vscode-graphql"
  ]
}
EOL

echo -e "${GREEN}✓ Estructura base del proyecto creada${NC}"

# Instalar dependencias globales necesarias
echo -e "${BLUE}Instalando dependencias globales...${NC}"
brew install node
brew install pnpm
npm install -g turbo

# Inicializar pnpm
pnpm setup

echo -e "${GREEN}¡Proyecto creado con éxito!${NC}"
echo -e "Para comenzar:"
echo -e "1. cd $PROJECT_NAME"
echo -e "2. pnpm install"
echo -e "3. code ."
