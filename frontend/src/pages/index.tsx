import React from 'react';
import { Shield } from 'lucide-react';

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="container mx-auto px-4 py-16">
        <div className="flex items-center justify-center">
          <Shield className="w-12 h-12 text-purple-400" />
          <h1 className="text-4xl font-bold text-white ml-4">
            AET Security Platform
          </h1>
        </div>
      </div>
    </div>
  );
}
