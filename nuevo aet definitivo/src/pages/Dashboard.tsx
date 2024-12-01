import { MainLayout } from '../layouts/MainLayout';
import { SecurityMetrics } from '../components/security/SecurityMetrics';
import { ActiveTools } from '../components/security/ActiveTools';
import { SecurityEvents } from '../components/security/SecurityEvents';
import { SystemStatus } from '../components/system/SystemStatus';

export const DashboardPage = () => {
  return (
    <MainLayout>
      <div className="grid gap-6">
        <SecurityMetrics />
        <div className="grid grid-cols-2 gap-6">
          <ActiveTools />
          <SystemStatus />
        </div>
        <SecurityEvents />
      </div>
    </MainLayout>
  );
};
