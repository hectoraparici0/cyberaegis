#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

echo -e "${BLUE}=== Creando componentes y páginas ===${NC}"

# Crear layouts
create_layouts() {
    echo -e "\n${YELLOW}Creando layouts...${NC}"
    
    mkdir -p src/layouts
    
    # Layout principal
    cat > src/layouts/MainLayout.tsx << 'EOL'
import { ReactNode } from 'react';
import { Sidebar } from '../components/navigation/Sidebar';
import { TopBar } from '../components/navigation/TopBar';

interface MainLayoutProps {
  children: ReactNode;
}

export const MainLayout = ({ children }: MainLayoutProps) => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <TopBar />
      <div className="flex h-[calc(100vh-4rem)]">
        <Sidebar />
        <main className="flex-1 overflow-auto">
          <div className="container mx-auto px-6 py-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};
EOL

    # Layout de autenticación
    cat > src/layouts/AuthLayout.tsx << 'EOL'
import { ReactNode } from 'react';

interface AuthLayoutProps {
  children: ReactNode;
}

export const AuthLayout = ({ children }: AuthLayoutProps) => {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="w-full max-w-md">
        {children}
      </div>
    </div>
  );
};
EOL
}

# Crear componentes de navegación
create_navigation_components() {
    echo -e "\n${YELLOW}Creando componentes de navegación...${NC}"
    
    mkdir -p src/components/navigation
    
    # Sidebar
    cat > src/components/navigation/Sidebar.tsx << 'EOL'
import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Shield, Activity, Cloud, Cpu, Smartphone, 
  Wifi, Server, Code, Settings, ChevronRight,
  Menu
} from 'lucide-react';

export const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();

  const navItems = [
    { name: 'Overview', icon: Activity, path: '/' },
    { name: 'Security', icon: Shield, path: '/security' },
    { name: 'Cloud', icon: Cloud, path: '/cloud' },
    { name: 'Quantum', icon: Cpu, path: '/quantum' },
    { name: 'Mobile', icon: Smartphone, path: '/mobile' },
    { name: 'IoT', icon: Wifi, path: '/iot' },
    { name: 'Infrastructure', icon: Server, path: '/infrastructure' },
    { name: 'Development', icon: Code, path: '/development' },
    { name: 'Settings', icon: Settings, path: '/settings' }
  ];

  return (
    <div className={`${collapsed ? 'w-20' : 'w-64'} bg-slate-800/50 h-full backdrop-blur-sm border-r border-purple-500/20 transition-all duration-300`}>
      {/* Sidebar content */}
    </div>
  );
};
EOL

    # TopBar
    cat > src/components/navigation/TopBar.tsx << 'EOL'
import { Bell, User, Search } from 'lucide-react';

export const TopBar = () => {
  return (
    <div className="h-16 bg-slate-800/50 backdrop-blur-sm border-b border-purple-500/20">
      <div className="h-full px-6 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <h1 className="text-xl font-bold text-white">AET Security</h1>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <input
              type="text"
              placeholder="Search..."
              className="pl-10 pr-4 py-2 bg-slate-700/50 border border-purple-500/20 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-purple-500"
            />
          </div>
        </div>
        <div className="flex items-center gap-4">
          <button className="text-gray-400 hover:text-white transition-colors">
            <Bell className="w-5 h-5" />
          </button>
          <button className="flex items-center gap-2 text-gray-400 hover:text-white transition-colors">
            <User className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
};
EOL
}

# Crear páginas principales
create_pages() {
    echo -e "\n${YELLOW}Creando páginas principales...${NC}"
    
    mkdir -p src/pages
    
    # Página de Dashboard
    cat > src/pages/Dashboard.tsx << 'EOL'
import { MainLayout } from '../layouts/MainLayout';
import { SecurityMetrics } from '../components/security/SecurityMetrics';
import { ActiveTools } from '../components/security/ActiveTools';
import { SecurityEvents } from '../components/security/SecurityEvents';
import { SystemStatus } from '../components/system/SystemStatus';

export const DashboardPage = () => {
  return (
    <MainLayout>
      <div className="grid gap-6">
        <SecurityMetrics />
        <div className="grid grid-cols-2 gap-6">
          <ActiveTools />
          <SystemStatus />
        </div>
        <SecurityEvents />
      </div>
    </MainLayout>
  );
};
EOL

    # Página de Login
    cat > src/pages/Login.tsx << 'EOL'
import { AuthLayout } from '../layouts/AuthLayout';
import { useState } from 'react';
import { useAuth } from '../hooks/useAuth';

export const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await login(email, password);
  };

  return (
    <AuthLayout>
      {/* Form content */}
    </AuthLayout>
  );
};
EOL
}

# Crear hooks personalizados
create_hooks() {
    echo -e "\n${YELLOW}Creando hooks personalizados...${NC}"
    
    mkdir -p src/hooks
    
    # Hook de autenticación
    cat > src/hooks/useAuth.ts << 'EOL'
import { create } from 'zustand';

interface AuthState {
  user: any | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

export const useAuth = create<AuthState>((set) => ({
  user: null,
  login: async (email, password) => {
    // Implementar lógica de login
    set({ user: { email } });
  },
  logout: async () => {
    // Implementar lógica de logout
    set({ user: null });
  },
}));
EOL

    # Hook de tema
    cat > src/hooks/useTheme.ts << 'EOL'
import { create } from 'zustand';

interface ThemeState {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

export const useTheme = create<ThemeState>((set) => ({
  theme: 'dark',
  toggleTheme: () => set((state) => ({ theme: state.theme === 'light' ? 'dark' : 'light' })),
}));
EOL
}

# Configurar enrutamiento
setup_routing() {
    echo -e "\n${YELLOW}Configurando enrutamiento...${NC}"
    
    # Router principal
    cat > src/router.tsx << 'EOL'
import { createBrowserRouter } from 'react-router-dom';
import { DashboardPage } from './pages/Dashboard';
import { LoginPage } from './pages/Login';
import { ProtectedRoute } from './components/auth/ProtectedRoute';

export const router = createBrowserRouter([
  {
    path: '/login',
    element: <LoginPage />,
  },
  {
    path: '/',
    element: <ProtectedRoute><DashboardPage /></ProtectedRoute>,
  },
  // Añadir más rutas aquí
]);
EOL
}

# Función principal
main() {
    create_layouts
    create_navigation_components
    create_pages
    create_hooks
    setup_routing
    
    echo -e "${GREEN}¡Componentes y páginas creados exitosamente!${NC}"
}

# Manejo de errores
trap 'echo -e "${RED}Error: El proceso falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar script
main
