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
    mkdir -p $PROJECT_NAME/src/{core,security,monitoring,ai,financial,user,mobile,support,components}
    mkdir -p $PROJECT_NAME/src/components/{ui,forms,charts,monitoring}
    mkdir -p $PROJECT_NAME/src/deployment
    mkdir -p $PROJECT_NAME/docs/{legal,security,api,technical}
}

# Convertir y mover archivos
move_files() {
    echo -e "\n${YELLOW}Moviendo archivos a sus ubicaciones correctas...${NC}"
    
    # Core files
    mv access-control-system.txt $PROJECT_NAME/src/security/AccessControl.ts
    mv aeg-ecosystem.ts $PROJECT_NAME/src/core/Ecosystem.ts
    mv aeg-guard.ts $PROJECT_NAME/src/security/Guard.ts
    mv aeg-monitor.ts $PROJECT_NAME/src/monitoring/Monitor.ts
    mv aeg-scanner.ts $PROJECT_NAME/src/security/Scanner.ts
    mv aeg-shield.ts $PROJECT_NAME/src/security/Shield.ts
    mv aeg-solutions-ui.tsx $PROJECT_NAME/src/components/SolutionsUI.tsx
    mv aet-platform-ui.tsx $PROJECT_NAME/src/components/PlatformUI.tsx
    mv aet-tools-core.ts $PROJECT_NAME/src/core/Tools.ts
    
    # Security files
    mv automated-response.txt $PROJECT_NAME/src/security/AutomatedResponse.ts
    mv autonomous-deployment.txt $PROJECT_NAME/src/deployment/AutonomousDeployment.ts
    mv deployment-monitor.tsx $PROJECT_NAME/src/components/monitoring/DeploymentMonitor.tsx
    
    # AI and Financial files
    mv quantum-ai-core.ts $PROJECT_NAME/src/ai/QuantumCore.ts
    mv quantum-evolution.txt $PROJECT_NAME/src/ai/QuantumEvolution.ts
    mv revenue-automation.txt $PROJECT_NAME/src/financial/RevenueAutomation.ts
    mv revenue-optimization.txt $PROJECT_NAME/src/financial/RevenueOptimization.ts
    mv revenue-optimizer.ts $PROJECT_NAME/src/financial/RevenueOptimizer.ts
    mv revenue-protection.txt $PROJECT_NAME/src/financial/RevenueProtection.ts
    
    # UI Components
    mv ecosystem-dashboard.tsx $PROJECT_NAME/src/components/EcosystemDashboard.tsx
    mv payment-dashboard.tsx $PROJECT_NAME/src/components/payment/PaymentDashboard.tsx
    mv security-platform.tsx $PROJECT_NAME/src/components/SecurityPlatform.tsx
    mv ui-components.tsx $PROJECT_NAME/src/components/ui/Components.tsx
    
    # Documentation
    mv data-processing-agreement.md $PROJECT_NAME/docs/legal/DPA.md
    mv enterprise-agreements.md $PROJECT_NAME/docs/legal/EnterpriseAgreements.md
    mv incident-response.md $PROJECT_NAME/docs/security/IncidentResponse.md
    mv industry-specific-terms.md $PROJECT_NAME/docs/legal/IndustryTerms.md
    mv legal-documents.md $PROJECT_NAME/docs/legal/Documents.md
    mv support-agreement.md $PROJECT_NAME/docs/legal/SupportAgreement.md
    
    # Browser Extension
    mv browser-extension.js $PROJECT_NAME/extension/background.js
    mv browser-extension-update.txt $PROJECT_NAME/extension/update.js
    
    # Scripts
    mv macos-deploy.sh $PROJECT_NAME/scripts/macos-deploy.sh
    mv setup-script.sh $PROJECT_NAME/scripts/setup.sh

    echo -e "${GREEN}✓ Archivos movidos correctamente${NC}"
}

# Configurar dependencias
setup_dependencies() {
    echo -e "\n${YELLOW}Configurando dependencias...${NC}"
    cd $PROJECT_NAME
    
    # Crear package.json
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

# Configurar archivos de desarrollo
setup_development_files() {
    echo -e "\n${YELLOW}Configurando archivos de desarrollo...${NC}"
    cd $PROJECT_NAME
    
    # Configurar TypeScript
    cat > tsconfig.json << EOL
{
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
}
EOL

    # Configurar Vite
    cat > vite.config.ts << EOL
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    sourcemap: true
  },
  server: {
    port: 3000,
    host: true
  }
})
EOL
}

# Función principal
main() {
    create_directory_structure
    move_files
    setup_dependencies
    setup_development_files
    
    echo -e "\n${GREEN}¡Integración completada exitosamente!${NC}"
    echo -e "Para iniciar el desarrollo:"
    echo -e "1. cd $PROJECT_NAME"
    echo -e "2. npm run dev"
}

# Manejo de errores
trap 'echo -e "\n${RED}Error: La integración falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar
main
