import React from 'react';
import { TrendingUp, TrendingDown } from 'lucide-react';

interface StatsCardProps {
  title: string;
  value: string | number;
  change: number;
  icon: React.ElementType;
  color?: string;
}

export const StatsCard: React.FC<StatsCardProps> = ({
  title,
  value,
  change,
  icon: Icon,
  color = 'purple'
}) => {
  const isPositive = change > 0;
  const TrendIcon = isPositive ? TrendingUp : TrendingDown;
  const trendColor = isPositive ? 'text-green-500' : 'text-red-500';

  return (
    <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-medium text-gray-200">{title}</h3>
        <Icon className={`w-6 h-6 text-${color}-400`} />
      </div>
      <div className="mt-4">
        <div className="text-3xl font-bold text-white">{value}</div>
        <div className={`flex items-center mt-2 ${trendColor}`}>
          <TrendIcon className="w-4 h-4 mr-1" />
          <span>{Math.abs(change)}%</span>
        </div>
      </div>
    </div>
  );
};
