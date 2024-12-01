import { create } from 'zustand';

interface AuthState {
  user: any | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

export const useAuth = create<AuthState>((set) => ({
  user: null,
  login: async (email, password) => {
    // Implementar lógica de login
    set({ user: { email } });
  },
  logout: async () => {
    // Implementar lógica de logout
    set({ user: null });
  },
}));
