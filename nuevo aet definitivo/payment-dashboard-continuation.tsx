"table className="w-full">
          <thead>
            <tr className="text-left border-b border-gray-700">
              <th className="p-3">Fecha</th>
              <th className="p-3">Método</th>
              <th className="p-3">Cantidad</th>
              <th className="p-3">Estado</th>
              <th className="p-3">ID Transacción</th>
            </tr>
          </thead>
          <tbody>
            {transferHistory.map((transfer, index) => (
              <tr key={index} className="border-b border-gray-700/50 hover:bg-white/5">
                <td className="p-3">{transfer.date}</td>
                <td className="p-3">
                  <div className="flex items-center gap-2">
                    {transfer.method === 'stripe' ? (
                      <CreditCard className="w-4 h-4 text-purple-400" />
                    ) : (
                      <Bank className="w-4 h-4 text-blue-400" />
                    )}
                    {transfer.method}
                  </div>
                </td>
                <td className="p-3 font-medium text-green-400">
                  ${transfer.amount.toLocaleString()}
                </td>
                <td className="p-3">
                  <span className={`px-2 py-1 rounded-full text-xs ${
                    transfer.status === 'success' 
                      ? 'bg-green-500/20 text-green-400'
                      : transfer.status === 'pending'
                      ? 'bg-yellow-500/20 text-yellow-400'
                      : 'bg-red-500/20 text-red-400'
                  }`}>
                    {transfer.status}
                  </span>
                </td>
                <td className="p-3 font-mono text-sm text-gray-400">
                  {transfer.transactionId}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Sistema de Alertas */}
      <div className="fixed bottom-6 right-6">
        {alerts.map((alert, index) => (
          <div
            key={index}
            className={`mb-4 p-4 rounded-lg shadow-lg backdrop-blur-sm flex items-center gap-3 ${
              alert.type === 'success'
                ? 'bg-green-500/20 text-green-400'
                : alert.type === 'warning'
                ? 'bg-yellow-500/20 text-yellow-400'
                : 'bg-red-500/20 text-red-400'
            }`}
          >
            <AlertCircle className="w-5 h-5" />
            <div>
              <div className="font-medium">{alert.title}</div>
              <div className="text-sm opacity-80">{alert.message}</div>
            </div>
          </div>
        ))}
      </div>

      {/* Modal de Transferencia Manual */}
      {showTransferModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center">
          <div className="bg-slate-800 rounded-xl p-6 w-full max-w-md">
            <h2 className="text-xl font-bold mb-4">Nueva Transferencia</h2>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm text-gray-400 mb-1">Método</label>
                <select 
                  value={transferForm.method}
                  onChange={(e) => setTransferForm({...transferForm, method: e.target.value})}
                  className="w-full bg-slate-700 rounded p-2"
                >
                  <option value="stripe">Stripe</option>
                  <option value="bank">Banco</option>
                </select>
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Cantidad</label>
                <input
                  type="number"
                  value={transferForm.amount}
                  onChange={(e) => setTransferForm({...transferForm, amount: e.target.value})}
                  className="w-full bg-slate-700 rounded p-2"
                  placeholder="0.00"
                />
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Descripción</label>
                <input
                  type="text"
                  value={transferForm.description}
                  onChange={(e) => setTransferForm({...transferForm, description: e.target.value})}
                  className="w-full bg-slate-700 rounded p-2"
                  placeholder="Opcional"
                />
              </div>

              <div className="flex justify-end gap-3 mt-6">
                <button
                  onClick={() => setShowTransferModal(false)}
                  className="px-4 py-2 rounded bg-gray-700 hover:bg-gray-600"
                >
                  Cancelar
                </button>
                <button
                  onClick={handleTransfer}
                  className="px-4 py-2 rounded bg-purple-600 hover:bg-purple-500"
                >
                  Transferir
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TransferDashboard;