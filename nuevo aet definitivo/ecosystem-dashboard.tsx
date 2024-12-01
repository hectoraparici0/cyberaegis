import React, { useState, useEffect } from 'react';
import { Shield, Lock, AlertCircle, Activity, Database, Cloud, Mobile, Cpu, Code, Key } from 'lucide-react';

const AETDashboard = () => {
  const [selectedTool, setSelectedTool] = useState(null);
  const [systemStatus, setSystemStatus] = useState({});
  const [alerts, setAlerts] = useState([]);

  const securityTools = {
    'Core Protection': [
      {
        id: 'quantum-shield',
        name: 'AET Quantum Shield',
        price: 799,
        icon: Shield,
        category: 'Premium',
        status: 'active',
        description: 'Firewall de próxima generación con IA cuántica',
        metrics: {
          threats_blocked: 1547,
          efficiency: 99.9,
          response_time: '0.001ms'
        }
      },
      {
        id: 'neural-guard',
        name: 'AET Neural Guard',
        price: 699,
        icon: Lock,
        category: 'Advanced',
        status: 'active',
        description: 'Sistema de autenticación neuromorfica',
        metrics: {
          active_sessions: 342,
          security_score: 98,
          authentications: 15789
        }
      }
    ],
    // ... más categorías y herramientas
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <nav className="bg-slate-800/80 backdrop-blur-sm border-b border-purple-500/20">
        {/* Navegación */}
      </nav>

      <main className="p-6">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Panel de Control */}
          <div className="lg:col-span-3 grid gap-6">
            {/* Estado del Sistema */}
            <div className="bg-white/5 rounded-xl p-6 backdrop-blur-sm">
              <h2 className="text-2xl font-bold text-white mb-4">Estado del Sistema</h2>
              <div className="grid grid-cols-4 gap-4">
                {/* Métricas */}
              </div>
            </div>

            {/* Herramientas Activas */}
            <div className="grid grid-cols-2 lg:grid-cols-3 gap-6">
              {Object.entries(securityTools).map(([category, tools]) => (
                tools.map(tool => (
                  <div key={tool.id} className="bg-white/5 rounded-xl p-6 backdrop-blur-sm hover:bg-white/10 transition-colors">
                    <div className="flex items-center gap-4 mb-4">
                      <tool.icon className="w-8 h-8 text-purple-400" />
                      <div>
                        <h3 className="text-lg font-semibold text-white">{tool.name}</h3>
                        <span className="text-sm text-purple-300">{category}</span>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-400">Estado</span>
                        <span className="text-green-400">Activo</span>
                      </div>
                      {Object.entries(tool.metrics).map(([key, value]) => (
                        <div key={key} className="flex justify-between text-sm">
                          <span className="text-gray-400">{key.replace('_', ' ')}</span>
                          <span className="text-white">{value}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                ))
              ))}
            </div>
          </div>

          {/* Panel Lateral */}
          <div className="lg:col-span-1 space-y-6">
            {/* Alertas */}
            <div className="bg-white/5 rounded-xl p-6 backdrop-blur-sm">
              <h2 className="text-xl font-bold text-white mb-4">Alertas Recientes</h2>
              <div className="space-y-4">
                {alerts.map(alert => (
                  <div key={alert.id} className="flex items-start gap-3 p-3 bg-red-500/10 rounded-lg">
                    <AlertCircle className="w-5 h-5 text-red-400" />
                    <div>
                      <h4 className="text-sm font-medium text-white">{alert.title}</h4>
                      <p className="text-xs text-gray-400">{alert.description}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Rendimiento */}
            <div className="bg-white/5 rounded-xl p-6 backdrop-blur-sm">
              <h2 className="text-xl font-bold text-white mb-4">Rendimiento</h2>
              {/* Gráficos de rendimiento */}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default AETDashboard;
