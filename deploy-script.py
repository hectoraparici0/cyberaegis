#!/usr/bin/env python3
"""
CyberAegis Deployment Script
Este script maneja el despliegue automatizado de CyberAegis
"""

import os
import subprocess
import argparse
import requests
import json
from pathlib import Path

class CyberAegisDeployer:
    def __init__(self, environment='development'):
        self.environment = environment
        self.project_root = Path.cwd()
        self.vercel_token = os.getenv('VERCEL_TOKEN')
        self.project_id = os.getenv('VERCEL_PROJECT_ID')

    def check_dependencies(self):
        """Verifica que todas las dependencias necesarias estén instaladas"""
        print("🔍 Verificando dependencias...")
        
        dependencies = ['node', 'npm', 'git']
        for dep in dependencies:
            try:
                subprocess.run([dep, '--version'], capture_output=True)
            except FileNotFoundError:
                raise Exception(f"❌ {dep} no está instalado")

        print("✅ Todas las dependencias están instaladas")

    def build_project(self):
        """Construye el proyecto para producción"""
        print("🏗️ Construyendo el proyecto...")
        
        try:
            subprocess.run(['npm', 'run', 'build'], check=True)
            print("✅ Proyecto construido exitosamente")
        except subprocess.CalledProcessError:
            raise Exception("❌ Error durante la construcción del proyecto")

    def run_tests(self):
        """Ejecuta las pruebas del proyecto"""
        print("🧪 Ejecutando pruebas...")
        
        try:
            subprocess.run(['npm', 'test'], check=True)
            print("✅ Pruebas completadas exitosamente")
        except subprocess.CalledProcessError:
            raise Exception("❌ Error en las pruebas")

    def deploy_to_vercel(self):
        """Despliega el proyecto a Vercel"""
        print("🚀 Desplegando a Vercel...")
        
        if not self.vercel_token:
            raise Exception("❌ VERCEL_TOKEN no está configurado")

        headers = {
            'Authorization': f'Bearer {self.vercel_token}',
            'Content-Type': 'application/json',
        }

        try:
            # Crear el despliegue
            deployment_url = f'https://api.vercel.com/v13/deployments'
            response = requests.post(deployment_url, headers=headers, json={
                'name': 'cyberaegis',
                'project': self.project_id,
                'target': self.environment,
            })
            
            response.raise_for_status()
            deployment_data = response.json()
            
            print(f"✅ Despliegue iniciado: {deployment_data['url']}")
            