import React, { useState, useEffect } from 'react';
import { 
  BarChart, 
  Activity, 
  Zap, 
  DollarSign, 
  TrendingUp,
  AlertCircle,
  RefreshCw,
  CheckCircle
} from 'lucide-react';

const DeploymentMonitor = () => {
  const [deploymentStatus, setDeploymentStatus] = useState({
    phase: 'initializing',
    progress: 0,
    revenueGenerated: 0,
    optimization: 0,
    metrics: {
      conversion: 0,
      efficiency: 0,
      performance: 0
    }
  });

  const [realtimeMetrics, setRealtimeMetrics] = useState({
    currentRevenue: 0,
    growthRate: 0,
    optimizationLevel: 0,
    opportunities: 0
  });

  useEffect(() => {
    // Actualización en tiempo real cada 100ms
    const metricsInterval = setInterval(async () => {
      const metrics = await fetchRealtimeMetrics();
      setRealtimeMetrics(metrics);
    }, 100);

    return () => clearInterval(metricsInterval);
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white p-8">
      {/* Estado del Despliegue */}
      <div className="grid grid-cols-4 gap-6 mb-8">
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold">Estado del Despliegue</h2>
            <Activity className={`w-6 h-6 ${
              deploymentStatus.phase === 'complete' 
                ? 'text-green-400' 
                : 'text-yellow-400'
            }`} />
          </div>
          <div className="text-2xl font-bold mb-2">
            {deploymentStatus.phase === 'complete' ? 'Activo' : 'Desplegando'}
          </div>
          <div className="w-full bg-slate-700 rounded-full h-2">
            <div 
              className="bg-purple-500 rounded-full h-2 transition-all"
              style={{ width: `${deploymentStatus.progress}%` }}
            />
          </div>
        </div>

        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold">Ingresos Generados</h2>
            <DollarSign className="w-6 h-6 text-green-400" />
          </div>
          <div className="text-2xl font-bold text-green-400">
            ${realtimeMetrics.currentRevenue.toLocaleString()}
          </div>
          <div className="flex items-center text-sm text-gray-400 mt-2">
            <TrendingUp className="w-4 h-4 mr-1" />
            +{realtimeMetrics.growthRate}% crecimiento
          </div>
        </div>

        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold">Nivel de Optimización</h2>
            <Zap className="w-6 h-6 text-blue-400" />
          </div>
          <div className="text-2xl font-bold text-blue-400">
            {realtimeMetrics.optimizationLevel}%
          </div>
          <div className="text-sm text-gray-400 mt-2">
            Optimización continua activa
          </div>
        </div>

        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold">Oportunidades</h2>
            <AlertCircle className="w-6 h-6 text-purple-400" />
          </div>
          <div className="text-2xl font-bold text-purple-400">
            {realtimeMetrics.opportunities}
          </div>
          <div className="text-sm text-gray-400 mt-2">
            Detectadas y ejecutadas
          </div>
        </div>
      </div>

      {/* Métricas Detalladas */}
      <div className="grid grid-cols-2 gap-6 mb-8">
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <h2 className="text-xl font-bold mb-6">Métricas de Rendimiento</h2>
          <div className="space-y-4">
            {Object.entries(deploymentStatus.metrics).map(([key, value]) => (
              <div key={key} className="flex items-center justify-between">
                <span className="capitalize">{key}</span>
                <div className="flex items-center">
                  <div className="w-32 h-2 bg-slate-700 rounded-full mr-3">
                    <div 
                      className="bg-purple-500 h-2 rounded-full"
                      style={{ width: `${value}%` }}
                    />
                  </div>
                  <span>{value}%</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <h2 className="text-xl font-bold mb-6">Estado del Sistema</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-3 bg-green-500/10 rounded-lg">
              <div className="flex items-center">
                <CheckCircle className="w-5 h-5 text-green-400 mr-2" />
                <span>Generación de Ingresos</span>
              </div>
              <span className="text-green-400">Activo</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-blue-500/10 rounded-lg">
              <div className="flex items-center">
                <RefreshCw className="w-5 h-5 text-blue-400 mr-2" />
                <span>Optimización Continua</span>
              </div>
              <span className="text-blue-400">Ejecutando</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-purple-500/10 rounded-lg">
              <div className="flex items-center">
                <Zap className="w-5 h-5 text-purple-400 mr-2" />
                <span>Detección de Oportunidades</span>
              </div>
              <span className="text-purple-400">Automático</span>
            </div>
          </div>
        </div>
      </div>

      {/* Logs en Tiempo Real */}
      <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
        <h2 className="text-xl font-bold mb-6">Actividad del Sistema</h2>
        <div className="space-y-3 max-h-60 overflow-y-auto">
          {systemLogs.map((log, index) => (
            <div 
              key={index}
              className="flex items-start space-x-3 p-3 bg-slate-800/50 rounded-lg"
            >
              <Activity className="w-5 h-5 text-gray-400 mt-1" />
              <div>
                <div className="font-medium">{log.action}</div>
                <div className="text-sm text-gray-400">{log.timestamp}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default DeploymentMonitor;