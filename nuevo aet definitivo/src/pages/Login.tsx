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
