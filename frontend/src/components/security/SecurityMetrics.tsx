import React from 'react';
import { Shield, Lock, AlertCircle } from 'lucide-react';
import { StatsCard } from '../analytics/StatsCard';

export const SecurityMetrics = () => {
  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <StatsCard
        title="Security Score"
        value="98%"
        change={5}
        icon={Shield}
        color="purple"
      />
      <StatsCard
        title="Threats Blocked"
        value="1,234"
        change={-12}
        icon={AlertCircle}
        color="red"
      />
      <StatsCard
        title="Systems Protected"
        value="56"
        change={8}
        icon={Lock}
        color="green"
      />
    </div>
  );
};
