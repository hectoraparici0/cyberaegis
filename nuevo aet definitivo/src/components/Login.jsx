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
