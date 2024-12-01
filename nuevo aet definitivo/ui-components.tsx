import React, { useState, useEffect } from 'react';
import { 
  Shield, Lock, AlertCircle, Activity, Database, Cloud, 
  DollarSign, TrendingUp, Users, Globe, Zap 
} from 'lucide-react';

const AETDashboard = () => {
  // Estados para métricas clave
  const [metrics, setMetrics] = useState({
    revenue: { current: 0, projected: 0, growth: 0 },
    clients: { total: 0, enterprise: 0, growth: 0 },
    security: { score: 0, threats: 0, incidents: 0 }
  });

  // Estado para herramientas activas
  const [activeTools, setActiveTools] = useState([]);

  // Panel de control ejecutivo
  const ExecutiveDashboard = () => (
    <div className="grid grid-cols-3 gap-6 mb-8">
      <MetricCard
        title="Ingresos"
        value={`$${metrics.revenue.current.toLocaleString()}`}
        growth={metrics.revenue.growth}
        icon={DollarSign}
        color="text-green-400"
      />
      <MetricCard
        title="Clientes Enterprise"
        value={metrics.clients.enterprise}
        growth={metrics.clients.growth}
        icon={Users}
        color="text-blue-400"
      />
      <MetricCard
        title="Puntuación de Seguridad"
        value={`${metrics.security.score}%`}
        trend="up"
        icon={Shield}
        color="text-purple-400"
      />
    </div>
  );

  // Panel de herramientas activas
  const ToolsDashboard = () => (
    <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
      {activeTools.map(tool => (
        <ToolCard
          key={tool.id}
          name={tool.name}
          status={tool.status}
          metrics={tool.metrics}
          icon={tool.icon}
        />
      ))}
    </div>
  );

  // Panel de análisis de ingresos
  const RevenueAnalysis = () => (
    <div className="bg-slate-800 rounded-xl p-6">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-xl font-bold text-white">Análisis de Ingresos</h2>
        <select className="bg-slate-700 text-white rounded-lg px-4 py-2">
          <option value="30d">Últimos 30 días</option>
          <option value="90d">Últimos 90 días</option>
          <option value="1y">Último año</option>
        </select>
      </div>
      
      <div className="grid grid-cols-2 gap-8">
        <div className="bg-slate-700/50 rounded-lg p-4">
          <h3 className="text-lg font-medium text-white mb-4">Ingresos por Producto</h3>
          {/* Gráfico de ingresos por producto */}
        </div>
        
        <div className="bg-slate-700/50 rounded-lg p-4">
          <h3 className="text-lg font-medium text-white mb-4">Proyecciones</h3>
          {/* Gráfico de proyecciones */}
        </div>
      </div>
    </div>
  );

  // Panel de clientes premium
  const PremiumClients = () => (
    <div className="bg-slate-800 rounded-xl p-6">
      <h2 className="text-xl font-bold text-white mb-6">Clientes Premium</h2>
      <div className="space-y-4">
        {/* Lista de clientes premium */}
      </div>
    </div>
  );

  // Panel de oportunidades
  const OpportunityPanel = () => (
    <div className="bg-slate-800 rounded-xl p-6">
      <h2 className="text-xl font-bold text-white mb-6">Oportunidades de Crecimiento</h2>
      <div className="grid grid-cols-2 gap-4">
        <OpportunityCard
          title="Upsell QuantumShield"
          value="$1.2M"
          probability="85%"
          clients={12}
        />
        <OpportunityCard
          title="Enterprise Expansion"
          value="$2.8M"
          probability="72%"
          clients={8}
        />
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <ExecutiveDashboard />
        
        <div className="grid grid-cols-3 gap-8 mb-8">
          <div className="col-span-2">
            <RevenueAnalysis />
          </div>
          <div className="col-span-1">
            <OpportunityPanel />
          </div>
        </div>

        <div className="grid grid-cols-4 gap-8">
          <div className="col-span-3">
            <ToolsDashboard />
          </div>
          <div className="col-span-1">
            <PremiumClients />
          </div>
        </div>
      </div>
    </div>
  );
};

// Componentes auxiliares
const MetricCard = ({ title, value, growth, icon: Icon, color }) => (
  <div className="bg-slate-800 rounded-xl p-6">
    <div className="flex items-center justify-between mb-4">
      <h3 className="text-lg font-medium text-white">{title}</h3>
      <Icon className={`w-6 h-6 ${color}`} />
    </div>
    <div className="text-3xl font-bold text-white mb-2">{value}</div>
    {growth && (
      <div className={`flex items-center ${growth >= 0 ? 'text-green-400' : 'text-red-400'}`}>
        <TrendingUp className="w-4 h-4 mr-1" />
        <span>{growth}%</span>
      </div>
    )}
  </div>
);

const ToolCard = ({ name, status, metrics, icon: Icon }) => (
  <div className="bg-slate-800 rounded-xl p-6">
    <div className="flex items-center gap-3 mb-4">
      <Icon className="w-6 h-6 text-purple-400" />
      <h3 className="text-lg font-medium text-white">{name}</h3>
    </div>
    <div className="space-y-2">
      {Object.entries(metrics).map(([key, value]) => (
        <div key={key} className="flex justify-between text-sm">
          <span className="text-gray-400">{key}</span>
          <span className="text-white">{value}</span>
        </div>
      ))}
    </div>
  </div>
);

const OpportunityCard = ({ title, value, probability, clients }) => (
  <div className="bg-slate-700/50 rounded-lg p-4">
    <h4 className="text-white font-medium mb-2">{title}</h4>
    <div className="flex justify-between text-sm text-gray-400 mb-1">
      <span>Valor Potencial</span>
      <span className="text-green-400">{value}</span>
    </div>
    <div className="flex justify-between text-sm text-gray-400">
      <span>Probabilidad</span>
      <span>{probability}</span>
    </div>
    <div className="mt-2 text-sm text-purple-400">
      {clients} clientes identificados
    </div>
  </div>
);

export default AETDashboard;