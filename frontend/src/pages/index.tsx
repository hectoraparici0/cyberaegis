import { DashboardLayout } from '../components/dashboard/DashboardLayout';
import { SecurityMetrics } from '../components/security/SecurityMetrics';

export default function Home() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <SecurityMetrics />
      </div>
    </DashboardLayout>
  );
}
