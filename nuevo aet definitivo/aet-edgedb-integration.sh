#!/bin/bash

# Colores para output
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Configuración
PROJECT_NAME="aet-security"
DOMAIN="hapariciop.uk"

echo -e "${BLUE}=== Configurando AET Security con EdgeDB ===${NC}"

# Verificar EdgeDB
check_edgedb() {
    echo -e "${YELLOW}Verificando EdgeDB...${NC}"
    if ! command -v edgedb &> /dev/null; then
        echo -e "${RED}EdgeDB no encontrado. Instalando...${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com | sh
    fi
}

# Inicializar EdgeDB
init_edgedb() {
    echo -e "${YELLOW}Inicializando EdgeDB...${NC}"
    edgedb project init --non-interactive

    # Crear schema.esdl
    cat > dbschema/schema.esdl << 'EOL'
module default {
    # Usuario base
    type User {
        required property name -> str;
        required property email -> str {
            constraint exclusive;
        };
        property role -> str {
            default := 'user';
        };
        multi link security_groups -> SecurityGroup;
        property created_at -> datetime {
            default := datetime_current();
        };
    }

    # Grupos de seguridad
    type SecurityGroup {
        required property name -> str;
        required property description -> str;
        property permissions -> array<str>;
    }

    # Eventos de seguridad
    type SecurityEvent {
        required property type -> str;
        required property severity -> str;
        required property description -> str;
        required property timestamp -> datetime {
            default := datetime_current();
        };
        required link reported_by -> User;
        property affected_systems -> array<str>;
        property resolution_status -> str {
            default := 'pending';
        };
    }

    # Herramientas de seguridad
    type SecurityTool {
        required property name -> str;
        required property type -> str;
        required property version -> str;
        property status -> str {
            default := 'active';
        };
        property configuration -> json;
        property metrics -> json;
    }

    # Análisis de amenazas
    type ThreatAnalysis {
        required property threat_type -> str;
        required property risk_level -> str;
        required property description -> str;
        required property detection_date -> datetime {
            default := datetime_current();
        };
        required link analyzed_by -> User;
        property mitigation_steps -> array<str>;
        property status -> str {
            default := 'active';
        };
    }
}
EOL
}

# Configurar autenticación
setup_auth() {
    echo -e "${YELLOW}Configurando autenticación...${NC}"
    
    # Crear directorio de autenticación
    mkdir -p src/auth

    # Crear AuthContext
    cat > src/auth/AuthContext.jsx << 'EOL'
import { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    checkUser();
  }, []);

  const checkUser = async () => {
    try {
      const response = await fetch('/api/auth/user');
      const data = await response.json();
      setUser(data.user);
    } catch (error) {
      console.error('Error checking user:', error);
    } finally {
      setLoading(false);
    }
  };

  const login = async (email, password) => {
    // Implementar lógica de login
  };

  const logout = async () => {
    // Implementar lógica de logout
  };

  const value = {
    user,
    loading,
    login,
    logout,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
EOL

    # Crear componente de Login
    cat > src/components/Login.jsx << 'EOL'
import { useState } from 'react';
import { useAuth } from '../auth/AuthContext';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login } = useAuth();

  const handleSubmit = async (e) => {
    e.preventDefault();
    await login(email, password);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <form onSubmit={handleSubmit} className="bg-white/10 backdrop-blur-sm p-8 rounded-xl border border-purple-500/20">
        <h2 className="text-2xl font-bold text-white mb-6">AET Security Login</h2>
        
        <div className="space-y-4">
          <div>
            <label className="block text-sm text-gray-300 mb-1">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-2 bg-slate-800/50 border border-purple-500/20 rounded-lg text-white"
            />
          </div>
          
          <div>
            <label className="block text-sm text-gray-300 mb-1">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-2 bg-slate-800/50 border border-purple-500/20 rounded-lg text-white"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-purple-600 hover:bg-purple-500 text-white py-2 px-4 rounded-lg transition-colors"
          >
            Login
          </button>
        </div>
      </form>
    </div>
  );
};

export default Login;
EOL
}

# Función principal
main() {
    check_edgedb
    init_edgedb
    setup_auth
    
    echo -e "${GREEN}Configuración de EdgeDB completada${NC}"
    echo -e "Siguiente paso: Configura las credenciales SMTP en EdgeDB UI"
    echo -e "Ejecuta: edgedb ui"
}

# Manejo de errores
trap 'echo -e "${RED}Error: El proceso falló. Revisa los logs para más detalles.${NC}"; exit 1' ERR

# Ejecutar script
main
