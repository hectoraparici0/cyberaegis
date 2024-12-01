#!/usr/bin/env python3
"""
CyberAegis Project Setup Script
This script automatiza la creación y configuración del proyecto CyberAegis
"""

import os
import subprocess
import json
import shutil
from pathlib import Path
import requests
import sys
import time

class CyberAegisSetup:
    def __init__(self):
        self.project_name = "cyberaegis"
        self.github_repo = "cyberaegis-platform"
        self.root_dir = Path.cwd() / self.project_name

    def create_directory_structure(self):
        """Crea la estructura de directorios del proyecto"""
        print("🚀 Creando estructura de directorios...")
        
        directories = [
            "src/components/ui",
            "src/pages/api/auth",
            "src/pages/api/scan",
            "src/pages/api/payments",
            "src/styles",
            "src/utils",
            "src/hooks",
            "src/contexts",
            "src/types",
            "public/images",
            "scripts",
            "tests/unit",
            "tests/integration",
            "docs/api",
            "docs/deployment",
            ".github/workflows",
        ]

        for dir_path in directories:
            full_path = self.root_dir / dir_path
            full_path.mkdir(parents=True, exist_ok=True)
            (full_path / '.gitkeep').touch()

        print("✅ Estructura de directorios creada")

    def create_github_files(self):
        """Crea archivos relacionados con GitHub"""
        print("📝 Creando archivos de GitHub...")

        # README.md
        readme_content = """# CyberAegis Platform

## Plataforma de Seguridad Avanzada Impulsada por IA

CyberAegis es una plataforma de seguridad de última generación que utiliza inteligencia artificial para proteger infraestructuras digitales.

### Características Principales

- 🛡️ Escaneo avanzado de vulnerabilidades
- 🤖 IA para detección de amenazas
- 🔄 Monitoreo continuo 24/7
- 🌐 Protección global
- ⚡ Respuesta automática a incidentes

### Requisitos

- Node.js 18+
- MongoDB
- Redis (opcional)
- Python 3.8+ (para scripts de utilidad)

### Instalación

```bash
git clone https://github.com/yourusername/cyberaegis-platform.git
cd cyberaegis-platform
npm install
npm run dev
```

### Documentación

Visita nuestra [documentación completa](docs/README.md) para más información.

### Licencia

MIT © CyberAegis Platform
"""
        
        # GitHub Actions workflow
        workflow_content = """name: CyberAegis CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [18.x]
        
    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v2
      with:
        node-version: ${{ matrix.node-version }}
    - run: npm ci
    - run: npm run build
    - run: npm test
    
  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v2
    - uses: amondnet/vercel-action@v20
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.ORG_ID}}
        vercel-project-id: ${{ secrets.PROJECT_ID}}
        vercel-args: '--prod'
"""

        # .gitignore
        gitignore_content = """# dependencies
node_modules/
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# IDE
.idea/
.vscode/
"""

        # Write files
        with open(self.root_dir / "README.md", "w") as f:
            f.write(readme_content)
            
        with open(self.root_dir / ".github/workflows/main.yml", "w") as f:
            f.write(workflow_content)
            
        with open(self.root_dir / ".gitignore", "w") as f:
            f.write(gitignore_content)

        print("✅ Archivos de GitHub creados")

    def initialize_npm_project(self):
        """Inicializa el proyecto NPM y instala dependencias"""
        print("📦 Inicializando proyecto NPM...")
        
        package_json = {
            "name": "cyberaegis",
            "version": "1.0.0",
            "private": True,
            "scripts": {
                "dev": "next dev",
                "build": "next build",
                "start": "next start",
                "lint": "next lint",
                "test": "jest",
                "prepare": "husky install"
            },
            "dependencies": {
                "@stripe/stripe-js": "^1.54.0",
                "@vercel/analytics": "^1.0.1",
                "next": "^13.4.7",
                "next-auth": "^4.22.1",
                "react": "^18.2.0",
                "react-dom": "^18.2.0",
                "mongodb": "^5.6.0",
                "stripe": "^12.9.0",
                "@sendgrid/mail": "^7.7.0",
                "lucide-react": "^0.263.1",
                "tailwindcss": "^3.3.2",
                "postcss": "^8.4.24",
                "autoprefixer": "^10.4.14"
            },
            "devDependencies": {
                "@types/react": "^18.2.0",
                "@types/node": "^20.2.5",
                "typescript": "^5.1.3",
                "eslint": "^8.42.0",
                "eslint-config-next": "^13.4.7",
                "husky": "^8.0.3",
                "jest": "^29.5.0",
                "@testing-library/react": "^14.0.0"
            }
        }

        with open(self.root_dir / "package.json", "w") as f:
            json.dump(package_json, f, indent=2)

        # Install dependencies
        os.chdir(self.root_dir)
        subprocess.run(["npm", "install"])

        print("✅ Proyecto NPM inicializado")

    def setup_git_repository(self):
        """Inicializa el repositorio Git y hace el commit inicial"""
        print("🔄 Configurando repositorio Git...")
        
        os.chdir(self.root_dir)
        
        # Initialize git
        subprocess.run(["git", "init"])
        
        # Add all files
        subprocess.run(["git", "add", "."])
        
        # Initial commit
        subprocess.run(["git", "commit", "-m", "🚀 Initial commit - CyberAegis Platform"])

        print("✅ Repositorio Git configurado")

    def create_env_files(self):
        """Crea los archivos de variables de entorno"""
        print("🔒 Creando archivos de entorno...")

        env_content = """MONGODB_URI=your_mongodb_uri
MONGODB_DB=cyberaegis
JWT_SECRET=your_jwt_secret
NEXTAUTH_URL=https://cyberaegis.com
NEXTAUTH_SECRET=your_nextauth_secret
STRIPE_SECRET_KEY=your_stripe_secret
STRIPE_PUBLISHABLE_KEY=your_stripe_public
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret
SENDGRID_API_KEY=your_sendgrid_key
FROM_EMAIL=noreply@cyberaegis.com
SCANNER_API_KEY=your_scanner_api_key"""

        env_example_content = env_content.replace("your_", "YOUR_")

        with open(self.root_dir / ".env", "w") as f:
            f.write(env_content)
            
        with open(self.root_dir / ".env.example", "w") as f:
            f.write(env_example_content)

        print("✅ Archivos de entorno creados")

    def setup_deployment_files(self):
        """Crea archivos de configuración para despliegue"""
        print("🚀 Creando archivos de despliegue...")

        # Vercel configuration
        vercel_config = {
            "version": 2,
            "builds": [
                {
                    "src": "package.json",
                    "use": "@vercel/next"
                }
            ],
            "env": {
                "MONGODB_URI": "@mongodb_uri",
                "JWT_SECRET": "@jwt_secret",
                "STRIPE_SECRET_KEY": "@stripe_secret"
            }
        }

        with open(self.root_dir / "vercel.json", "w") as f:
            json.dump(vercel_config, f, indent=2)

        print("✅ Archivos de despliegue creados")

    def create_documentation(self):
        """Crea documentación básica del proyecto"""
        print("📚 Generando documentación...")

        docs = {
            "README.md": """# CyberAegis Documentation

## Contenido

1. [API Documentation](api/README.md)
2. [Deployment Guide](deployment/README.md)
3. [Development Guide](development.md)
""",
            "api/README.md": """# API Documentation

## Endpoints

### Authentication
- POST /api/auth/login
- POST /api/auth/register
- POST /api/auth/logout

### Scanning
- POST /api/scan/free
- POST /api/scan/full
- GET /api/scan/history

### Payments
- POST /api/payments/create-checkout
- POST /api/payments/webhook
""",
            "deployment/README.md": """# Deployment Guide

## Prerequisites

1. Vercel Account
2. MongoDB Atlas Account
3. Stripe Account
4. SendGrid Account

## Deployment Steps

1. Clone repository
2. Configure environment variables
3. Deploy to Vercel
4. Configure DNS
5. Test deployment
"""
        }

        for path, content in docs.items():
            full_path = self.root_dir / "docs" / path
            full_path.parent.mkdir(parents=True, exist_ok=True)
            with open(full_path, "w") as f:
                f.write(content)

        print("✅ Documentación generada")

    def setup_all(self):
        """Ejecuta todo el proceso de configuración"""
        try:
            print("🎯 Iniciando configuración de CyberAegis...")
            
            self.create_directory_structure()
            self.create_github_files()
            self.initialize_npm_project()
            self.setup_git_repository()
            self.create_env_files()
            self.setup_deployment_files()
            self.create_documentation()
            
            print("""
✨ ¡Configuración completada con éxito! ✨

Próximos pasos:
1. Configura las variables de entorno en .env
2. Conecta el repositorio con GitHub
3. Configura el proyecto en Vercel
4. Revisa la documentación en /docs

Para iniciar el desarrollo:
cd cyberaegis
npm run dev
""")
            
        except Exception as e:
            print(f"❌ Error durante la configuración: {str(e)}")
            raise

if __name__ == "__main__":
    setup = CyberAegisSetup()
    setup.setup_all()
