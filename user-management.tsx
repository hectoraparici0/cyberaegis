import React, { useState } from 'react';
import { User, Key, Mail, Building2, AlertCircle } from 'lucide-react';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Alert, AlertDescription } from '@/components/ui/alert';

const UserManagement = () => {
  const [formType, setFormType] = useState('login'); // login, register, forgot
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    companyName: '',
    role: 'user'
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleInputChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (formType === 'register' && formData.password !== formData.confirmPassword) {
      setError('Las contraseñas no coinciden');
      return;
    }

    try {
      const response = await fetch(`/api/auth/${formType}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Error en la autenticación');
      }

      setSuccess(formType === 'login' ? 'Inicio de sesión exitoso' : 'Cuenta creada exitosamente');
      // Manejar token y redirección
      if (data.token) {
        localStorage.setItem('token', data.token);
        window.location.href = '/dashboard';
      }
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-indigo-900 via-purple-900 to-slate-900 py-12 px-4 sm:px-6 lg:px-8">
      <Card className="w-full max-w-md bg-white/5 backdrop-blur-lg border-indigo-500/20">
        <CardHeader>
          <CardTitle className="text-2xl font-bold text-white text-center">
            {formType === 'login' ? 'Iniciar Sesión' : formType === 'register' ? 'Crear Cuenta' : 'Recuperar Contraseña'}
          </CardTitle>
          <CardDescription className="text-center text-indigo-300">
            {formType === 'login' ? 'Accede a tu cuenta de Net-Fix Hub' : 'Únete a la plataforma líder en ciberseguridad'}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium text-indigo-200">Email</label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-indigo-400 h-5 w-5" />
                <input
                  type="email"
                  name="email"
                  required
                  className="w-full pl-10 pr-4 py-2 bg-slate-800/50 border border-indigo-500/30 rounded-lg text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                  placeholder="tu@email.com"
                  value={formData.email}
                  onChange={handleInputChange}
                />
              </div>
            </div>

            {formType !== 'forgot' && (
              <div className="space-y-2">
                <label className="text-sm font-medium text-indigo-200">Contraseña</label>
                <div className="relative">
                  <Key className="absolute left-3 top-1/2 transform -translate-y-1/2 text-indigo-400 h-5 w-5" />
                  <input
                    type="password"
                    name="password"
                    required
                    className="w-full pl-10 pr-4 py-2 bg-slate-800/50 border border-indigo-500/30 rounded-lg text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                    placeholder="********"
                    value={formData.password}
                    onChange={handleInputChange}
                  />
                </div>
              </div>
            )}

            {formType === 'register' && (
              <>
                <div className="space-y-2">
                  <label className="text-sm font-medium text-indigo-200">Confirmar Contraseña</label>
                  <div className="relative">
                    <Key className="absolute left-3 top-1/2 transform -translate-y-1/2 text-indigo-400 h-5 w-5" />
                    <input
                      type="password"
                      name="confirmPassword"
                      required
                      className="w-full pl-10 pr-4 py-2 bg-slate-800/50 border border-indigo-500/30 rounded-lg text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                      placeholder="********"
                      value={formData.confirmPassword}
                      onChange={handleInputChange}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium text-indigo-200">Nombre de la Empresa</label>
                  <div className="relative">
                    <Building2 className="absolute left-3 top-1/2 transform -translate-y-1/2 text-indigo-400 h-5 w-5" />
                    <input
                      type="text"
                      name="companyName"
                      required
                      className="w-full pl-10 pr-4 py-2 bg-slate-800/50 border border-indigo-500/30 rounded-lg text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                      placeholder="Nombre de tu empresa"
                      value={formData.companyName}
                      onChange={handleInputChange}
                    />
                  </div>
                </div>
              </>
            )}

            {error && (
              <Alert variant="destructive" className="bg-red-500/10 border-red-500/50">
                <AlertCircle className="h-4 w-4" />
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}

            {success && (
              <Alert className="bg-green-500/10 border-green-500/50">
                <AlertDescription>{success}</AlertDescription>
              </Alert>
            )}

            <button
              type="submit"
              className="w-full py-2 px-4 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-500 hover:to-purple-500 text-white rounded-lg transition-all duration-200 flex items-center justify-center gap-2"
            >
              <User className="h-5 w-5" />
              {formType === 'login' ? 'Iniciar Sesión' : formType === 'register' ? 'Crear Cuenta' : 'Recuperar Contraseña'}
            </button>
          </form>
        </CardContent>
        <CardFooter className="flex flex-col space-y-2">
          <div className="text-sm text-indigo-200 text-center">
            {formType === 'login' ? (
              <>
                ¿No tienes una cuenta?{' '}
                <button
                  onClick={() => setFormType('register')}
                  className="text-indigo-400 hover:text-indigo-300"
                >
                  Regístrate aquí
                </button>
              </>
            ) : (
              <>
                ¿Ya tienes una cuenta?{' '}
                <button
                  onClick={() => setFormType('login')}
                  className="text-indigo-400 hover:text-indigo-300"
                >
                  Inicia sesión
                </button>
              </>
            )}
          </div>
          {formType !== 'forgot' && (
            <button
              onClick={() => setFormType('forgot')}
              className="text-sm text-indigo-400 hover:text-indigo-300"
            >
              ¿Olvidaste tu contraseña?
            </button>
          )}
        </CardFooter>
      </Card>
    </div>
  );
};

export default UserManagement;
