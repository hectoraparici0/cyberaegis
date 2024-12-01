// src/screens/Dashboard.tsx (continuación)
        lastScan={security.lastScan}
        activeThreats={security.activeThreats}
      />

      <ToolsQuickAccess 
        tools={security.availableTools}
        onToolPress={(toolId) => navigation.navigate('Tools', { toolId })}
      />

      <AlertsList 
        alerts={security.recentAlerts}
        onAlertPress={(alertId) => navigation.navigate('Alerts', { alertId })}
      />
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0f172a'
  }
});

// src/components/SecurityStatus.tsx
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Shield, AlertTriangle, Clock } from 'lucide-react-native';

export const SecurityStatus = ({ score, threatLevel, lastScan, activeThreats }) => {
  const getScoreColor = (score) => {
    if (score >= 90) return '#22c55e';
    if (score >= 70) return '#eab308';
    return '#ef4444';
  };

  return (
    <View style={styles.container}>
      <View style={styles.scoreContainer}>
        <Shield size={32} color={getScoreColor(score)} />
        <Text style={[styles.score, { color: getScoreColor(score) }]}>
          {score}%
        </Text>
        <Text style={styles.label}>Security Score</Text>
      </View>

      <View style={styles.infoContainer}>
        <View style={styles.infoItem}>
          <AlertTriangle size={24} color="#f59e0b" />
          <Text style={styles.infoValue}>{activeThreats}</Text>
          <Text style={styles.infoLabel}>Active Threats</Text>
        </View>

        <View style={styles.infoItem}>
          <Clock size={24} color="#60a5fa" />
          <Text style={styles.infoLabel}>Last Scan</Text>
          <Text style={styles.infoValue}>{lastScan}</Text>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
    backgroundColor: '#1e293b',
    borderRadius: 12,
    margin: 16,
  },
  scoreContainer: {
    alignItems: 'center',
    marginBottom: 16,
  },
  score: {
    fontSize: 48,
    fontWeight: 'bold',
    marginVertical: 8,
  },
  label: {
    color: '#94a3b8',
    fontSize: 16,
  },
  infoContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  infoItem: {
    alignItems: 'center',
  },
  infoValue: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: '600',
    marginVertical: 4,
  },
  infoLabel: {
    color: '#94a3b8',
    fontSize: 14,
  }
});

// src/components/ToolsQuickAccess.tsx
import React from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';

export const ToolsQuickAccess = ({ tools, onToolPress }) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Quick Access</Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false}>
        {tools.map(tool => (
          <TouchableOpacity
            key={tool.id}
            style={styles.toolCard}
            onPress={() => onToolPress(tool.id)}
          >
            <tool.icon size={24} color="#8b5cf6" />
            <Text style={styles.toolName}>{tool.name}</Text>
            <Text style={styles.toolStatus}>{tool.status}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: 16,
  },
  title: {
    color: '#ffffff',
    fontSize: 20,
    fontWeight: '600',
    marginHorizontal: 16,
    marginBottom: 12,
  },
  toolCard: {
    backgroundColor: '#1e293b',
    padding: 16,
    borderRadius: 12,
    marginHorizontal: 8,
    width: 120,
    alignItems: 'center',
  },
  toolName: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '500',
    marginTop: 8,
    textAlign: 'center',
  },
  toolStatus: {
    color: '#94a3b8',
    fontSize: 14,
    marginTop: 4,
  }
});

// src/components/AlertsList.tsx
import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { AlertCircle, ChevronRight } from 'lucide-react-native';

export const AlertsList = ({ alerts, onAlertPress }) => {
  const getAlertColor = (severity) => {
    switch (severity) {
      case 'critical': return '#ef4444';
      case 'high': return '#f97316';
      case 'medium': return '#eab308';
      default: return '#3b82f6';
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Recent Alerts</Text>
      <View style={styles.alertsContainer}>
        {alerts.map(alert => (
          <TouchableOpacity
            key={alert.id}
            style={styles.alertCard}
            onPress={() => onAlertPress(alert.id)}
          >
            <View style={styles.alertHeader}>
              <AlertCircle size={20} color={getAlertColor(alert.severity)} />
              <Text style={styles.alertTitle}>{alert.title}</Text>
              <ChevronRight size={20} color="#64748b" />
            </View>
            <Text style={styles.alertDescription}>{alert.description}</Text>
            <Text style={styles.alertTime}>{alert.time}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: 16,
  },
  title: {
    color: '#ffffff',
    fontSize: 20,
    fontWeight: '600',
    marginHorizontal: 16,
    marginBottom: 12,
  },
  alertsContainer: {
    paddingHorizontal: 16,
  },
  alertCard: {
    backgroundColor: '#1e293b',
    padding: 16,
    borderRadius: 12,
    marginBottom: 8,
  },
  alertHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  alertTitle: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: '500',
    flex: 1,
    marginLeft: 8,
  },
  alertDescription: {
    color: '#94a3b8',
    fontSize: 14,
    marginBottom: 8,
  },
  alertTime: {
    color: '#64748b',
    fontSize: 12,
  }
});
