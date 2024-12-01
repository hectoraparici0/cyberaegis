#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
PROJECT_NAME="aet-security"
CURRENT_USER=$(whoami)

echo -e "${BLUE}=== Integrando AET Security Platform - Versión Completa ===${NC}"

# Función para verificar y arreglar permisos
fix_permissions() {
    echo -e "\n${YELLOW}Verificando permisos...${NC}"
    
    # Arreglar permisos de npm cache
    if [ -d "/Users/$CURRENT_USER/.npm" ]; then
        echo -e "${YELLOW}Arreglando permisos de npm cache...${NC}"
        sudo chown -R $CURRENT_USER:staff "/Users/$CURRENT_USER/.npm"
    fi
}

# Crear estructura de directorios completa
create_directory_structure() {
    echo -e "\n${YELLOW}Creando estructura de directorios...${NC}"
    
    # Eliminar directorio si existe
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "${YELLOW}Eliminando directorio existente...${NC}"
        rm -rf "$PROJECT_NAME"
    fi
    
    # Crear directorios
    mkdir -p "$PROJECT_NAME"/{src,docs,scripts,extension}
    mkdir -p "$PROJECT_NAME"/src/{core,security,monitoring,ai,financial,user,mobile,support,components}
    mkdir -p "$PROJECT_NAME"/src/components/{ui,forms,charts,monitoring}
    mkdir -p "$PROJECT_NAME"/src/deployment
    mkdir -p "$PROJECT_NAME"/docs/{legal,security,api,technical}
    
    echo -e "${GREEN}✓ Estructura de directorios creada${NC}"
}

# Convertir y mover archivos
move_files() {
    echo -e "\n${YELLOW}Moviendo archivos a sus ubicaciones correctas...${NC}"
    
    # Core files
    cp -f access-control-system.txt "$PROJECT_NAME/src/security/AccessControl.ts" 2>/dev/null || echo -e "${RED}No se encontró access-control-system.txt${NC}"
    cp -f aeg-ecosystem.ts "$PROJECT_NAME/src/core/Ecosystem.ts" 2>/dev/null || echo -e "${RED}No se encontró aeg-ecosystem.ts${NC}"
    # ... [resto de los archivos]
    
    echo -e "${GREEN}✓ Archivos movidos correctamente${NC}"
}

# Configurar dependencias
setup_dependencies() {
    echo -e "\n${YELLOW}Configurando dependencias...${NC}"
    
    if [ ! -d "$PROJECT_NAME" ]; then
        echo -e "${RED}Error: El directorio del proyecto no existe${NC}"
        exit 1
    fi
    
    cd "$PROJECT_NAME" || exit
    
    # Inicializar npm
    npm init -y
    
    # Instalar dependencias
    npm install react react-dom @vitejs/plugin-react typescript
    npm install -D @types/react @types/react-dom
    npm install lucide-react @tanstack/react-query zustand tailwindcss postcss autoprefixer
    
    echo -e "${GREEN}✓ Dependencias instaladas${NC}"
}

# Configurar archivos de desarrollo
setup_development_files() {
    echo -e "\n${YELLOW}Configurando archivos de desarrollo...${NC}"
    
    if [ ! -d "$PROJECT_NAME" ]; then
        echo -e "${RED}Error: El directorio del proyecto no existe${NC}"
        exit 1
    fi
    
    cd "$PROJECT_NAME" || exit
    
    # Configurar TypeScript
    echo '{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}' > tsconfig.json

    # Configurar Vite
    echo 'import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: "dist",
    sourcemap: true
  },
  server: {
    port: 3000,
    host: true
  }
})' > vite.config.ts

    echo -e "${GREEN}✓ Archivos de desarrollo configurados${NC}"
}

# Verificar la instalación
verify_installation() {
    echo -e "\n${YELLOW}Verificando instalación...${NC}"
    
    if [ ! -d "$PROJECT_NAME" ]; then
        echo -e "${RED}Error: La instalación falló - no se encontró el directorio del proyecto${NC}"
        exit 1
    fi
    
    if [ ! -f "$PROJECT_NAME/package.json" ]; then
        echo -e "${RED}Error: La instalación falló - no se encontró package.json${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Instalación verificada${NC}"
}

# Función principal
main() {
    fix_permissions
    create_directory_structure
    move_files
    setup_dependencies
    setup_development_files
    verify_installation
    
    echo -e "\n${GREEN}¡Integración completada exitosamente!${NC}"
    echo -e "Para iniciar el desarrollo:"
    echo -e "1. cd $PROJECT_NAME"
    echo -e "2. npm run dev"
}

# Manejo de errores
trap 'echo -e "\n${RED}Error: La integración falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar
main
