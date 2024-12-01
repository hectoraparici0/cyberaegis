// App.tsx
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { ThemeProvider } from './src/context/ThemeContext';
import { SecurityProvider } from './src/context/SecurityContext';

import Dashboard from './src/screens/Dashboard';
import SecureScanner from './src/screens/SecureScanner';
import ToolsPanel from './src/screens/ToolsPanel';
import Settings from './src/screens/Settings';
import Alerts from './src/screens/Alerts';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <ThemeProvider>
      <SecurityProvider>
        <NavigationContainer>
          <Stack.Navigator>
            <Stack.Screen 
              name="Dashboard" 
              component={Dashboard}
              options={{
                headerStyle: {
                  backgroundColor: '#1e1b4b',
                },
                headerTintColor: '#fff',
                title: 'AET Security'
              }}
            />
            <Stack.Screen 
              name="Scanner" 
              component={SecureScanner}
              options={{
                headerStyle: {
                  backgroundColor: '#1e1b4b',
                },
                headerTintColor: '#fff',
                title: 'Security Scanner'
              }}
            />
            <Stack.Screen 
              name="Tools" 
              component={ToolsPanel}
              options={{
                headerStyle: {
                  backgroundColor: '#1e1b4b',
                },
                headerTintColor: '#fff',
                title: 'Security Tools'
              }}
            />
            <Stack.Screen 
              name="Settings" 
              component={Settings}
              options={{
                headerStyle: {
                  backgroundColor: '#1e1b4b',
                },
                headerTintColor: '#fff',
                title: 'Settings'
              }}
            />
            <Stack.Screen 
              name="Alerts" 
              component={Alerts}
              options={{
                headerStyle: {
                  backgroundColor: '#1e1b4b',
                },
                headerTintColor: '#fff',
                title: 'Security Alerts'
              }}
            />
          </Stack.Navigator>
        </NavigationContainer>
      </SecurityProvider>
    </ThemeProvider>
  );
};

export default App;

// src/screens/Dashboard.tsx
import React, { useState, useEffect } from 'react';
import { View, ScrollView, StyleSheet } from 'react-native';
import { SecurityStatus } from '../components/SecurityStatus';
import { ToolsQuickAccess } from '../components/ToolsQuickAccess';
import { AlertsList } from '../components/AlertsList';
import { useSecurityContext } from '../context/SecurityContext';

const Dashboard = ({ navigation }) => {
  const { security } = useSecurityContext();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    // Cargar datos del dashboard
    setLoading(false);
  };

  return (
    <ScrollView style={styles.container}>
      <SecurityStatus 
        score={security.score}
        threatLevel={security.threatLevel}
        lastScan={security.