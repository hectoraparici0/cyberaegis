#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
PROJECT_NAME="aet-security"

echo -e "${BLUE}=== Configurando AET Security Platform ===${NC}"

# Crear proyecto y estructura base
echo -e "\n${YELLOW}Creando proyecto...${NC}"
npm create vite@latest $PROJECT_NAME -- --template react-ts
cd $PROJECT_NAME

# Instalar dependencias
echo -e "\n${YELLOW}Instalando dependencias...${NC}"
npm install lucide-react @tanstack/react-query zustand tailwindcss postcss autoprefixer

# Inicializar Tailwind
echo -e "\n${YELLOW}Inicializando Tailwind...${NC}"
npx tailwindcss init -p

# Crear estructura de directorios
echo -e "\n${YELLOW}Creando estructura de directorios...${NC}"
mkdir -p src/{components,layouts,hooks,utils,styles}

# Configurar Tailwind
echo -e "\n${YELLOW}Configurando Tailwind...${NC}"
cat > tailwind.config.js << 'EOL'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOL

# Crear archivos base
echo -e "\n${YELLOW}Creando archivos base...${NC}"

# index.css
cat > src/index.css << 'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;

html, body, #root {
  height: 100%;
  margin: 0;
  padding: 0;
}
EOL

# App.tsx
cat > src/App.tsx << 'EOL'
import Dashboard from './components/Dashboard'

function App() {
  return <Dashboard />
}

export default App
EOL

# main.tsx
cat > src/main.tsx << 'EOL'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOL

# Dashboard.tsx
cat > src/components/Dashboard.tsx << 'EOL'
import { useState } from 'react';
import { Shield, Lock, AlertCircle, Activity, BarChart, Cloud, 
         Code, Cpu, Smartphone, Wifi, Server, Settings, 
         ChevronRight, AlertTriangle, Timer, Menu } from 'lucide-react';

const Dashboard = () => {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);
  const [activeModule, setActiveModule] = useState('overview');

  const metrics = {
    security: { score: 98, threats: 156, incidents: 0 },
    system: { uptime: "99.99%", response: "45ms", load: "23%" },
    revenue: { current: 1250000, growth: 15.4, projected: 1500000 }
  };

  return (
    <div className="h-screen w-screen overflow-hidden bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="flex h-full">
        {/* Sidebar */}
        <div className={`${sidebarCollapsed ? 'w-16' : 'w-64'} bg-slate-800/50 h-full backdrop-blur-sm border-r border-purple-500/20 transition-all duration-300`}>
          <div className="p-4">
            <div className="flex items-center space-x-2 mb-8">
              <button 
                onClick={() => setSidebarCollapsed(!sidebarCollapsed)}
                className="p-2 rounded-lg hover:bg-white/10 transition-colors"
              >
                <Menu className="w-6 h-6 text-white" />
              </button>
              {!sidebarCollapsed && <span className="text-xl font-bold text-white">AET Security</span>}
            </div>

            <nav className="space-y-2">
              {[
                { name: 'Overview', icon: Activity },
                { name: 'Network', icon: Shield },
                { name: 'Cloud', icon: Cloud },
                { name: 'Quantum', icon: Cpu },
                { name: 'Mobile', icon: Smartphone },
                { name: 'IoT', icon: Wifi },
                { name: 'Infrastructure', icon: Server },
                { name: 'Development', icon: Code },
                { name: 'Settings', icon: Settings }
              ].map(item => (
                <button
                  key={item.name}
                  onClick={() => setActiveModule(item.name.toLowerCase())}
                  className={`flex items-center w-full px-3 py-2 rounded-lg transition-colors
                    ${activeModule === item.name.toLowerCase()
                      ? 'bg-purple-600 text-white'
                      : 'text-gray-300 hover:bg-white/10'
                    }`}
                >
                  <item.icon className="w-5 h-5" />
                  {!sidebarCollapsed && <span className="ml-3">{item.name}</span>}
                </button>
              ))}
            </nav>
          </div>
        </div>

        {/* Main Content */}
        <div className="flex-1 overflow-auto">
          <div className="p-8">
            {/* Header */}
            <div className="mb-8">
              <h1 className="text-3xl font-bold text-white">Welcome to AET Security</h1>
              <p className="text-gray-400">Your security systems overview</p>
            </div>

            {/* Security Metrics */}
            <div className="grid grid-cols-3 gap-6 mb-8">
              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-medium text-white">Security Score</h3>
                  <Shield className="w-6 h-6 text-purple-400" />
                </div>
                <div className="text-3xl font-bold text-white mb-2">{metrics.security.score}%</div>
                <div className="text-sm text-green-400">Optimal Protection</div>
              </div>

              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-medium text-white">Active Threats</h3>
                  <AlertTriangle className="w-6 h-6 text-orange-400" />
                </div>
                <div className="text-3xl font-bold text-white mb-2">{metrics.security.threats}</div>
                <div className="text-sm text-orange-400">Under Control</div>
              </div>

              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-medium text-white">System Status</h3>
                  <Activity className="w-6 h-6 text-green-400" />
                </div>
                <div className="text-3xl font-bold text-white mb-2">{metrics.system.uptime}</div>
                <div className="text-sm text-green-400">All Systems Operational</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
EOL

# Iniciar el proyecto
echo -e "\n${YELLOW}Iniciando el proyecto...${NC}"
npm install
npm run dev

echo -e "\n${GREEN}¡Configuración completada!${NC}"
echo -e "El proyecto está ejecutándose en http://localhost:5173"
