#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
PROJECT_NAME="aet-security"

echo -e "${BLUE}=== Integrando AET Security Platform - Versión Completa ===${NC}"

# Crear estructura de directorios completa
create_directory_structure() {
    echo -e "\n${YELLOW}Creando estructura de directorios...${NC}"
    
    mkdir -p $PROJECT_NAME/{src,docs,scripts,extension}
    
    # Estructura src
    mkdir -p $PROJECT_NAME/src/{core,security,monitoring,ai,financial,user,mobile,support,components}
    mkdir -p $PROJECT_NAME/src/components/{ui,forms,charts,monitoring}
    mkdir -p $PROJECT_NAME/src/deployment
    
    # Estructura docs
    mkdir -p $PROJECT_NAME/docs/{legal,security,api,technical}
}

# Convertir y mover archivos
convert_and_move_files() {
    echo -e "\n${YELLOW}Moviendo archivos a sus ubicaciones correctas...${NC}"
    
    # Array de mapeo de archivos [origen:destino]
    declare -A file_mappings=(
        ["access-control-system.txt"]="src/security/AccessControl.ts"
        ["aeg-ecosystem.ts"]="src/core/Ecosystem.ts"
        ["aeg-guard.ts"]="src/security/Guard.ts"
        # ... [Lista completa de mapeos]
    )
    
    for source in "${!file_mappings[@]}"; do
        target="${file_mappings[$source]}"
        if [ -f "$source" ]; then
            mkdir -p "$PROJECT_NAME/$(dirname "$target")"
            cp "$source" "$PROJECT_NAME/$target"
            echo -e "${GREEN}✓ Movido: $source → $target${NC}"
        else
            echo -e "${RED}✗ No encontrado: $source${NC}"
        fi
    done
}

# Actualizar imports y referencias
update_references() {
    echo -e "\n${YELLOW}Actualizando referencias...${NC}"
    
    find $PROJECT_NAME/src -type f -name "*.ts" -o -name "*.tsx" | while read -r file; do
        sed -i '' 's/@aet\/core/..\/core/g' "$file"
        sed -i '' 's/@aet\/quantum-ai/..\/ai\/quantum/g' "$file"
        echo -e "${GREEN}✓ Referencias actualizadas: $file${NC}"
    done
}

# Configurar dependencias
setup_dependencies() {
    echo -e "\n${YELLOW}Configurando dependencias...${NC}"
    
    cd $PROJECT_NAME
    
    cat > package.json << EOL
{
  "name": "aet-security",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint src",
    "test": "vitest"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.11.2",
    "@tanstack/react-query": "^4.29.12",
    "lucide-react": "^0.263.1",
    "tailwindcss": "^3.3.3",
    "zustand": "^4.3.8",
    "date-fns": "^2.30.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@vitejs/plugin-react": "^4.0.3",
    "typescript": "^5.0.2",
    "vite": "^4.4.5",
    "vitest": "^0.34.1"
  }
}
EOL

    npm install
}

# Verificar integridad
verify_integration() {
    echo -e "\n${YELLOW}Verificando integridad de la integración...${NC}"
    
    # Lista de archivos críticos que deben existir
    critical_files=(
        "src/core/MasterControl.ts"
        "src/security/AccessControl.ts"
        "src/ai/QuantumCore.ts"
        "src/components/SecurityPlatform.tsx"
    )
    
    for file in "${critical_files[@]}"; do
        if [ -f "$PROJECT_NAME/$file" ]; then
            echo -e "${GREEN}✓ Verificado: $file${NC}"
        else
            echo -e "${RED}✗ Falta archivo crítico: $file${NC}"
            exit 1
        fi
    done
}

# Configurar scripts de desarrollo
setup_scripts() {
    echo -e "\n${YELLOW}Configurando scripts de desarrollo...${NC}"
    
    cd $PROJECT_NAME
    mkdir -p scripts
    
    # Script de desarrollo
    cat > scripts/dev.sh << EOL
#!/bin/bash
npm run dev
EOL
    
    # Script de build
    cat > scripts/build.sh << EOL
#!/bin/bash
npm run build
EOL
    
    # Script de despliegue
    cat > scripts/deploy.sh << EOL
#!/bin/bash
npm run build
npx wrangler pages deploy dist --project-name=aet-security
EOL
    
    chmod +x scripts/*.sh
}

# Función principal
main() {
    create_directory_structure
    convert_and_move_files
    update_references
    setup_dependencies
    verify_integration
    setup_scripts
    
    echo -e "\n${GREEN}¡Integración completada exitosamente!${NC}"
    echo -e "Para iniciar el desarrollo:"
    echo -e "1. cd $PROJECT_NAME"
    echo -e "2. ./scripts/dev.sh"
}

# Manejo de errores
trap 'echo -e "\n${RED}Error: La integración falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar
main
