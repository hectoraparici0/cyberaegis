import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Shield, Activity, Cloud, Cpu, Smartphone, 
  Wifi, Server, Code, Settings, ChevronRight,
  Menu
} from 'lucide-react';

export const Sidebar = () => {
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();

  const navItems = [
    { name: 'Overview', icon: Activity, path: '/' },
    { name: 'Security', icon: Shield, path: '/security' },
    { name: 'Cloud', icon: Cloud, path: '/cloud' },
    { name: 'Quantum', icon: Cpu, path: '/quantum' },
    { name: 'Mobile', icon: Smartphone, path: '/mobile' },
    { name: 'IoT', icon: Wifi, path: '/iot' },
    { name: 'Infrastructure', icon: Server, path: '/infrastructure' },
    { name: 'Development', icon: Code, path: '/development' },
    { name: 'Settings', icon: Settings, path: '/settings' }
  ];

  return (
    <div className={`${collapsed ? 'w-20' : 'w-64'} bg-slate-800/50 h-full backdrop-blur-sm border-r border-purple-500/20 transition-all duration-300`}>
      {/* Sidebar content */}
    </div>
  );
};
