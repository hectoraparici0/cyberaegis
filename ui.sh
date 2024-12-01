#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

PROJECT_DIR="frontend"

# Función para crear componentes UI
create_ui_components() {
    echo -e "${BLUE}Creando componentes UI...${NC}"
    
    # Crear directorios de componentes
    mkdir -p $PROJECT_DIR/src/components/{common,layout,dashboard,security,analytics}
    mkdir -p $PROJECT_DIR/src/styles/components

    # Componentes comunes
    cat > $PROJECT_DIR/src/components/common/Button.tsx << EOL
import React from 'react';

interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  className?: string;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  children,
  onClick,
  disabled,
  className,
}) => {
  const baseStyles = 'rounded-lg font-medium transition-colors';
  
  const variantStyles = {
    primary: 'bg-purple-600 hover:bg-purple-700 text-white',
    secondary: 'bg-slate-600 hover:bg-slate-700 text-white',
    danger: 'bg-red-600 hover:bg-red-700 text-white'
  };
  
  const sizeStyles = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={\`\${baseStyles} \${variantStyles[variant]} \${sizeStyles[size]} \${className}\`}
    >
      {children}
    </button>
  );
};
EOL

    # Crear panel de control principal
    cat > $PROJECT_DIR/src/components/dashboard/DashboardLayout.tsx << EOL
import React from 'react';
import { Sidebar } from '../layout/Sidebar';
import { TopBar } from '../layout/TopBar';

interface DashboardLayoutProps {
  children: React.ReactNode;
}

export const DashboardLayout: React.FC<DashboardLayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <Sidebar />
      <div className="ml-64">
        <TopBar />
        <main className="p-6">{children}</main>
      </div>
    </div>
  );
};
EOL

    # Crear componentes de estadísticas
    cat > $PROJECT_DIR/src/components/analytics/StatsCard.tsx << EOL
import React from 'react';
import { TrendingUp, TrendingDown } from 'lucide-react';

interface StatsCardProps {
  title: string;
  value: string | number;
  change: number;
  icon: React.ElementType;
  color?: string;
}

export const StatsCard: React.FC<StatsCardProps> = ({
  title,
  value,
  change,
  icon: Icon,
  color = 'purple'
}) => {
  const isPositive = change > 0;
  const TrendIcon = isPositive ? TrendingUp : TrendingDown;
  const trendColor = isPositive ? 'text-green-500' : 'text-red-500';

  return (
    <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-medium text-gray-200">{title}</h3>
        <Icon className={\`w-6 h-6 text-\${color}-400\`} />
      </div>
      <div className="mt-4">
        <div className="text-3xl font-bold text-white">{value}</div>
        <div className={\`flex items-center mt-2 \${trendColor}\`}>
          <TrendIcon className="w-4 h-4 mr-1" />
          <span>{Math.abs(change)}%</span>
        </div>
      </div>
    </div>
  );
};
EOL

    # Crear estilos globales
    cat > $PROJECT_DIR/src/styles/globals.css << EOL
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  body {
    @apply bg-slate-900 text-white;
  }
}

@layer components {
  .card {
    @apply bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/10;
  }
  
  .input {
    @apply bg-slate-800/50 border border-slate-700 rounded-lg px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-purple-500;
  }
  
  .btn {
    @apply px-4 py-2 rounded-lg font-medium transition-colors;
  }
  
  .btn-primary {
    @apply bg-purple-600 hover:bg-purple-700 text-white;
  }
}
EOL

    # Crear componentes de seguridad
    cat > $PROJECT_DIR/src/components/security/SecurityMetrics.tsx << EOL
import React from 'react';
import { Shield, Lock, AlertCircle } from 'lucide-react';
import { StatsCard } from '../analytics/StatsCard';

export const SecurityMetrics = () => {
  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <StatsCard
        title="Security Score"
        value="98%"
        change={5}
        icon={Shield}
        color="purple"
      />
      <StatsCard
        title="Threats Blocked"
        value="1,234"
        change={-12}
        icon={AlertCircle}
        color="red"
      />
      <StatsCard
        title="Systems Protected"
        value="56"
        change={8}
        icon={Lock}
        color="green"
      />
    </div>
  );
};
EOL

    # Crear página principal
    cat > $PROJECT_DIR/src/pages/index.tsx << EOL
import { DashboardLayout } from '../components/dashboard/DashboardLayout';
import { SecurityMetrics } from '../components/security/SecurityMetrics';

export default function Home() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <SecurityMetrics />
      </div>
    </DashboardLayout>
  );
}
EOL
}

# Configurar tema y estilos
setup_theme() {
    echo -e "${BLUE}Configurando tema y estilos...${NC}"
    
    # Configurar tailwind.config.js
    cat > $PROJECT_DIR/tailwind.config.js << EOL
const colors = require('tailwindcss/colors');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx}',
    './src/components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.purple,
        secondary: colors.slate,
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-out',
        'slide-up': 'slideUp 0.5s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
    },
  },
  plugins: [],
};
EOL
}

# Instalar dependencias adicionales
install_ui_dependencies() {
    echo -e "${BLUE}Instalando dependencias de UI...${NC}"
    
    cd $PROJECT_DIR
    
    # Instalar dependencias
    npm install @headlessui/react @heroicons/react lucide-react \
               @radix-ui/react-dialog @radix-ui/react-dropdown-menu \
               @radix-ui/react-tabs framer-motion recharts
               
    # Instalar dependencias de desarrollo
    npm install -D @types/recharts autoprefixer postcss tailwindcss
    
    cd ..
}

# Función principal
main() {
    echo -e "${BLUE}=== Iniciando configuración de UI ===${NC}"
    
    create_ui_components
    setup_theme
    install_ui_dependencies
    
    echo -e "\n${GREEN}¡UI configurada exitosamente!${NC}"
    echo -e "Para iniciar el desarrollo:"
    echo -e "1. cd frontend"
    echo -e "2. npm run dev"
}

# Ejecutar script
main
