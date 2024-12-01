import React, { useState, useEffect } from 'react';
import {
  CreditCard,
  Bank,
  DollarSign,
  Calendar,
  AlertCircle,
  ArrowRight,
  PieChart,
  Settings,
  RefreshCw
} from 'lucide-react';

const TransferDashboard = () => {
  const [transferStats, setTransferStats] = useState({
    available: 0,
    pending: 0,
    nextTransfer: null
  });

  const [transferHistory, setTransferHistory] = useState([]);
  const [settings, setSettings] = useState({
    stripe: {
      enabled: true,
      minAmount: 1000,
      schedule: 'daily'
    },
    bank: {
      enabled: true,
      minAmount: 5000,
      schedule: 'weekly'
    }
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white p-8">
      {/* Balance y Acciones Rápidas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">Balance Disponible</h2>
            <DollarSign className="w-6 h-6 text-green-400" />
          </div>
          <div className="text-3xl font-bold text-green-400">
            ${transferStats.available.toLocaleString()}
          </div>
          <div className="text-sm text-gray-400 mt-2">
            Actualizado hace 5 minutos
          </div>
        </div>

        {/* Próxima Transferencia */}
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">Próxima Transferencia</h2>
            <Calendar className="w-6 h-6 text-purple-400" />
          </div>
          <div className="flex items-center">
            <div className="text-2xl font-bold text-purple-400">
              ${transferStats.pending.toLocaleString()}
            </div>
            <ArrowRight className="w-5 h-5 mx-2 text-gray-400" />
            <div className="text-sm text-gray-400">
              {transferStats.nextTransfer || 'No programada'}
            </div>
          </div>
        </div>

        {/* Acciones Rápidas */}
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <h2 className="text-xl font-bold mb-4">Acciones Rápidas</h2>
          <div className="grid grid-cols-2 gap-4">
            <button className="flex items-center justify-center gap-2 bg-purple-600 hover:bg-purple-700 p-2 rounded-lg">
              <CreditCard className="w-5 h-5" />
              Stripe
            </button>
            <button className="flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-700 p-2 rounded-lg">
              <Bank className="w-5 h-5" />
              Banco
            </button>
          </div>
        </div>
      </div>

      {/* Configuración y Estadísticas */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold">Configuración</h2>
            <Settings className="w-6 h-6 text-gray-400" />
          </div>
          
          {/* Stripe Config */}
          <div className="mb-6">
            <div className="flex items-center justify-between mb-2">
              <span className="font-medium">Stripe</span>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  checked={settings.stripe.enabled}
                  className="mr-2"
                />
                <span className="text-sm text-gray-400">Automático</span>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-sm text-gray-400">Mínimo</label>
                <input
                  type="number"
                  value={settings.stripe.minAmount}
                  className="w-full bg-slate-800/50 rounded p-2 mt-1"
                />
              </div>
              <div>
                <label className="text-sm text-gray-400">Frecuencia</label>
                <select
                  value={settings.stripe.schedule}
                  className="w-full bg-slate-800/50 rounded p-2 mt-1"
                >
                  <option value="daily">Diario</option>
                  <option value="weekly">Semanal</option>
                  <option value="monthly">Mensual</option>
                </select>
              </div>
            </div>
          </div>

          {/* Bank Config */}
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="font-medium">Banco</span>
              <div className="flex items-center">
                <input
                  type="checkbox"
                  checked={settings.bank.enabled}
                  className="mr-2"
                />
                <span className="text-sm text-gray-400">Automático</span>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-sm text-gray-400">Mínimo</label>
                <input
                  type="number"
                  value={settings.bank.minAmount}
                  className="w-full bg-slate-800/50 rounded p-2 mt-1"
                />
              </div>
              <div>
                <label className="text-sm text-gray-400">Frecuencia</label>
                <select
                  value={settings.bank.schedule}
                  className="w-full bg-slate-800/50 rounded p-2 mt-1"
                >
                  <option value="weekly">Semanal</option>
                  <option value="biweekly">Quincenal</option>
                  <option value="monthly">Mensual</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        {/* Estadísticas */}
        <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold">Estadísticas</h2>
            <PieChart className="w-6 h-6 text-gray-400" />
          </div>
          
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span>Total Transferido (Mes)</span>
              <span className="text-green-400 font-bold">$123,456</span>
            </div>
            <div className="flex justify-between items-center">
              <span>Promedio por Transferencia</span>
              <span className="text-blue-400 font-bold">$15,432</span>
            </div>
            <div className="flex justify-between items-center">
              <span>Transferencias Exitosas</span>
              <span className="text-purple-400 font-bold">98.5%</span>
            </div>
          </div>
        </div>
      </div>

      {/* Historial de Transferencias */}
      <div className="bg-white/10 rounded-xl p-6 backdrop-blur-sm">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold">Historial de Transferencias</h2>
          <RefreshCw className="w-6 h-6 text-gray-400 cursor-pointer" />
        </div>

        <div className="overflow-x-auto">
          <table className