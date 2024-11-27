```typescript
// src/App.tsx
import React from 'react';
import { 
  BrowserRouter as Router,
  Routes,
  Route 
} from 'react-router-dom';
import { 
  Dashboard,
  SecurityTools,
  Analysis,
  Settings,
  Profile 
} from './pages';
import { Sidebar, Navbar } from './components';
import { ThemeProvider } from './context/ThemeContext';

const App: React.FC = () => {
  return (
    <ThemeProvider>
      <Router>
        <div className="flex h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
          <Sidebar />
          <div className="flex-1 flex flex-col overflow-hidden">
            <Navbar />
            <main className="flex-1 overflow-y-auto p-4">
              <Routes>
                <Route path="/" element={<Dashboard />} />
                <Route path="/tools" element={<SecurityTools />} />
                <Route path="/analysis" element={<Analysis />} />
                <Route path="/settings" element={<Settings />} />
                <Route path="/profile" element={<Profile />} />
              </Routes>
            </main>
          </div>
        </div>
      </Router>
    </ThemeProvider>
  );
};

export default App;
```


```typescript
// Estructura de archivos
src/
  ├── components/
  │   ├── layout/
  │   │   ├── Navbar.tsx
  │   │   ├── Sidebar.tsx
  │   │   └── Footer.tsx
  │   ├── security/
  │   │   ├── SecurityCard.tsx
  │   │   ├── ThreatAlert.tsx
  │   │   └── SecurityMetrics.tsx
  │   ├── analysis/
  │   │   ├── AnalyticsChart.tsx
  │   │   ├── MetricsDisplay.tsx
  │   │   └── TrendAnalysis.tsx
  │   └── shared/
  │       ├── Button.tsx
  │       ├── Card.tsx
  │       └── Input.tsx
  ├── pages/
  │   ├── Dashboard.tsx
  │   ├── SecurityTools.tsx
  │   ├── Analysis.tsx
  │   ├── Settings.tsx
  │   └── Profile.tsx
  ├── context/
  │   ├── ThemeContext.tsx
  │   └── SecurityContext.tsx
  ├── hooks/
  │   ├── useSecurityData.ts
  │   └── useAnalytics.ts
  ├── utils/
  │   ├── api.ts
  │   └── helpers.ts
  └── styles/
      └── globals.css
```

Ahora, implementaré algunos componentes clave:


```typescript
// components/layout/Sidebar.tsx
import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Shield, 
  Layout, 
  AlertCircle, 
  Settings, 
  User 
} from 'lucide-react';

const Sidebar: React.FC = () => {
  const location = useLocation();

  const menuItems = [
    { icon: Layout, label: 'Dashboard', path: '/' },
    { icon: Shield, label: 'Security Tools', path: '/tools' },
    { icon: AlertCircle, label: 'Analysis', path: '/analysis' },
    { icon: Settings, label: 'Settings', path: '/settings' },
    { icon: User, label: 'Profile', path: '/profile' }
  ];

  return (
    <div className="w-64 bg-slate-800 text-white">
      <div className="p-4">
        <div className="flex items-center space-x-2 mb-8">
          <Shield className="w-8 h-8 text-purple-400" />
          <span className="text-xl font-bold">CyberAegis</span>
        </div>
        <nav className="space-y-2">
          {menuItems.map(({ icon: Icon, label, path }) => (
            <Link
              key={path}
              to={path}
              className={`flex items-center space-x-2 p-3 rounded-lg transition-colors ${
                location.pathname === path
                  ? 'bg-purple-600 text-white'
                  : 'hover:bg-slate-700 text-gray-300'
              }`}
            >
              <Icon className="w-5 h-5" />
              <span>{label}</span>
            </Link>
          ))}
        </nav>
      </div>
    </div>
  );
};

export default Sidebar;
```


```typescript
// pages/Dashboard.tsx
import React from 'react';
import { Card, SecurityMetrics, ThreatAlert, AnalyticsChart } from '../components';

const Dashboard: React.FC = () => {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-white mb-8">
        Security Dashboard
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card title="System Status" className="bg-green-500/10">
          <SecurityMetrics />
        </Card>
        <Card title="Active Threats" className="bg-red-500/10">
          <ThreatAlert />
        </Card>
        <Card title="Security Score" className="bg-blue-500/10">
          <div className="text-4xl font-bold text-center text-white">
            98%
          </div>
        </Card>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card title="Security Trends">
          <AnalyticsChart type="line" />
        </Card>
        <Card title="Threat Distribution">
          <AnalyticsChart type="pie" />
        </Card>
      </div>

      <div className="grid grid-cols-1 gap-6">
        <Card title="Recent Activities">
          {/* Activity list */}
        </Card>
      </div>
    </div>
  );
};

export default Dashboard;
```

Para la integración con GitHub y Cloudflare, necesitamos:

1. **GitHub Actions Workflow**:
```yaml
# .github/workflows/deploy.yml
name: Deploy CyberAegis

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '16'
        
    - name: Install Dependencies
      run: npm install
      
    - name: Build
      run: npm run build
      
    - name: Deploy to Cloudflare Pages
      uses: cloudflare/wrangler-action@2.0.0
      with:
        apiToken: ${{ secrets.CF_API_TOKEN }}
        accountId: ${{ secrets.CF_ACCOUNT_ID }}
```

2. **Configuración de Cloudflare**:
```toml
# wrangler.toml
name = "cyberaegis"
type = "webpack"
account_id = "your_account_id"
workers_dev = true
route = "cyberaegis.hapariciop.uk/*"
zone_id = "your_zone_id"

[site]
bucket = "./dist"
entry-point = "workers-site"
```

3. **Script de despliegue**:
```bash
#!/bin/bash
# deploy.sh

# Build
npm run build

# Deploy to Cloudflare
wrangler publish
```

Para implementar:

1. **Clonar repositorio**:
```bash
git clone https://github.com/hectoraparici0/cyberaegis.git
cd cyberaegis
```

2. **Instalar dependencias**:
```bash
npm install
```

3. **Configurar variables de entorno**:
```bash
# .env
REACT_APP_API_URL=https://api.cyberaegis.com
REACT_APP_CF_TOKEN=your_cloudflare_token
```

4. **Desarrollo local**:
```bash
npm run dev
```

5. **Desplegar**:
```bash
./deploy.sh
```

¿Quieres que profundice en algún componente específico o que agregue más funcionalidades a la UI?