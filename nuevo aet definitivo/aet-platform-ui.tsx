import React, { useState, useEffect } from 'react';
import { 
  Shield, Lock, AlertCircle, Activity, BarChart, Cloud, 
  Database, Cpu, Code, Mobile, Server, Key, Radio, User,
  Settings, Terminal, Search, Eye, FileText, ChevronRight
} from 'lucide-react';

const AETPlatform = () => {
  const [activeCategory, setActiveCategory] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTool, setSelectedTool] = useState(null);
  const [systemHealth, setSystemHealth] = useState({
    status: 'optimal',
    threats_blocked: 15789,
    security_score: 98,
    active_tools: 20
  });

  const categories = [
    { id: 'network', name: 'Network Security', icon: Shield },
    { id: 'endpoint', name: 'Endpoint Protection', icon: Lock },
    { id: 'cloud', name: 'Cloud Security', icon: Cloud },
    { id: 'data', name: 'Data Protection', icon: Database },
    { id: 'identity', name: 'Identity & Access', icon: User },
    { id: 'intelligence', name: 'Threat Intelligence', icon: Activity },
    { id: 'quantum', name: 'Quantum Security', icon: Cpu },
    { id: 'mobile', name: 'Mobile Security', icon: Mobile },
    { id: 'iot', name: 'IoT Security', icon: Radio },
    { id: 'audit', name: 'Security Audit', icon: FileText }
  ];

  const tools = [
    {
      id: 'quantum-shield',
      name: 'AET Quantum Shield',
      category: 'network',
      price: 1999,
      icon: Shield,
      status: 'active',
      metrics: {
        threats_blocked: 5243,
        bandwidth_protected: '2.1 TB',
        attack_prevention: '99.9%'
      }
    },
    {
      id: 'neural-guard',
      name: 'AET Neural Guard',
      category: 'identity',
      price: 1199,
      icon: Lock,
      status: 'active',
      metrics: {
        identities_protected: 1542,
        auth_requests: '25K/day',
        breach_prevention: '99.8%'
      }
    },
    // ... más herramientas
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="flex h-screen">
        {/* Sidebar */}
        <div className="w-64 bg-slate-800/50 backdrop-blur-sm border-r border-purple-500/20">
          <div className="p-4">
            <div className="flex items-center space-x-2 mb-8">
              <Shield className="w-8 h-8 text-purple-400" />
              <span className="text-xl font-bold text-white">AET Security</span>
            </div>

            <nav className="space-y-2">
              {categories.map(category => (
                <button
                  key={category.id}
                  onClick={() => setActiveCategory(category.id)}
                  className={`flex items-center w-full px-3 py-2 rounded-lg transition-colors ${
                    activeCategory === category.id
                      ? 'bg-purple-600 text-white'
                      : 'text-gray-300 hover:bg-white/10'
                  }`}
                >
                  <category.icon className="w-5 h-5 mr-3" />
                  <span>{category.name}</span>
                </button>
              ))}
            </nav>
          </div>
        </div>

        {/* Main Content */}
        <div className="flex-1 overflow-hidden">
          {/* Top Bar */}
          <div className="h-16 bg-slate-800/50 backdrop-blur-sm border-b border-purple-500/20 flex items-center justify-between px-6">
            <div className="flex items-center">
              <div className="relative">
                <Search className="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
                <input
                  type="text"
                  placeholder="Buscar herramientas..."
                  className="pl-10 pr-4 py-2 bg-slate-700/50 border border-purple-500/20 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:border-purple-500"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <button className="p-2 text-gray-300 hover:text-white">
                <Bell className="w-5 h-5" />
              </button>
              <button className="p-2 text-gray-300 hover:text-white">
                <Settings className="w-5 h-5" />
              </button>
              <div className="w-8 h-8 rounded-full bg-purple-600 flex items-center justify-center">
                <User className="w-5 h-5 text-white" />
              </div>
            </div>
          </div>

          {/* Content Area */}
          <div className="p-6 overflow-auto h-[calc(100vh-4rem)]">
            {/* System Status */}
            <div className="grid grid-cols-4 gap-6 mb-8">
              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-white">Estado del Sistema</h3>
                  <Activity className="w-6 h-6 text-green-400" />
                </div>
                <div className="text-3xl font-bold text-white mb-2">
                  {systemHealth.status === 'optimal' ? 'Óptimo' : 'Atención Requerida'}
                </div>
                <p className="text-gray-400">Todas las herramientas operativas</p>
              </div>

              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-white">Amenazas Bloqueadas</h3>
                  <Shield className="w-6 h-6 text-purple-400" />
                </div>
                <div className="text-3xl font-bold text-white mb-2">
                  {systemHealth.threats_blocked.toLocaleString()}
                </div>
                <p className="text-gray-400">En las últimas 24 horas</p>
              </div>

              <div className="bg-white/5 backdrop-blur-sm rounded-xl p-6 border border-purple-500/20">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-semibold text-white">Nivel de Seguridad</h3>
                  <BarChart className="w-6 h-6 text-blue-400" />
                </div>