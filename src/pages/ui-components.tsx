import React from 'react';
import { createContext, useContext, useState } from 'react';

// Tema y contexto
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType>({
  theme: 'dark',
  toggleTheme: () => {}
});

export const ThemeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<'light' | 'dark'>('dark');

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

// Componentes base
export const Button = ({ 
  children, 
  variant = 'primary', 
  size = 'medium',
  ...props 
}: {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
}) => {
  const { theme } = useContext(ThemeContext);
  
  return (
    <button 
      className={`
        rounded-lg font-medium transition-colors
        ${variant === 'primary' ? 'bg-purple-600 text-white hover:bg-purple-700' :
          variant === 'secondary' ? 'bg-gray-200 text-gray-800 hover:bg-gray-300' :
          'bg-red-600 text-white hover:bg-red-700'}
        ${size === 'small' ? 'px-3 py-1 text-sm' :
          size === 'medium' ? 'px-4 py-2' :
          'px-6 py-3 text-lg'}
        ${theme === 'dark' ? 'border-gray-700' : 'border-gray-200'}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export const Card = ({
  children,
  className = '',
  ...props
}: {
  children: React.ReactNode;
  className?: string;
}) => {
  const { theme } = useContext(ThemeContext);
  
  return (
    <div 
      className={`
        rounded-xl p-6
        ${theme === 'dark' ? 
          'bg-gray-800 text-white border border-gray-700' : 
          'bg-white text-gray-900 border border-gray-200'}
        ${className}
      `}
      {...props}
    >
      {children}
    </div>
  );
};

export const Alert = ({
  children,
  type = 'info',
  className = '',
  ...props
}: {
  children: React.ReactNode;
  type?: 'info' | 'success' | 'warning' | 'error';
  className?: string;
}) => {
  const typeStyles = {
    info: 'bg-blue-100 text-blue-800 border-blue-200',
    success: 'bg-green-100 text-green-800 border-green-200',
    warning: 'bg-yellow-100 text-yellow-800 border-yellow-200',
    error: 'bg-red-100 text-red-800 border-red-200'
  };

  return (
    <div 
      className={`
        rounded-lg p-4 border
        ${typeStyles[type]}
        ${className}
      `}
      role="alert"
      {...props}
    >
      {children}
    </div>
  );
};

export const Input = ({
  label,
  error,
  ...props
}: {
  label?: string;
  error?: string;
} & React.InputHTMLAttributes<HTMLInputElement>) => {
  const { theme } = useContext(ThemeContext);
  
  return (
    <div className="space-y-1">
      {label && (
        <label className={`block text-sm font-medium ${
          theme === 'dark' ? 'text-gray-200' : 'text-gray-700'
        }`}>
          {label}
        </label>
      )}
      <input
        className={`
          w-full rounded-lg border px-3 py-2 outline-none transition-colors
          ${theme === 'dark' ? 
            'bg-gray-700 border-gray-600 text-white' : 
            'bg-white border-gray-300 text-gray-900'}
          ${error ? 'border-red-500' : 'focus:border-purple-500'}
        `}
        {...props}
      />
      {error && (
        <p className="text-red-500 text-sm mt-1">{error}</p>
      )}
    </div>
  );
};

export const Table = ({
  headers,
  data,
  className = '',
}: {
  headers: string[];
  data: Record<string, any>[];
  className?: string;
}) => {
  const { theme } = useContext(ThemeContext);
  
  return (
    <div className={`overflow-x-auto ${className}`}>
      <table className="min-w-full divide-y divide-gray-200">
        <thead className={theme === 'dark' ? 'bg-gray-700' : 'bg-gray-50'}>
          <tr>
            {headers.map((header, index) => (
              <th
                key={index}
                className={`
                  px-6 py-3 text-left text-xs font-medium uppercase tracking-wider
                  ${theme === 'dark' ? 'text-gray-200' : 'text-gray-500'}
                `}
              >
                {header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className={`divide-y ${
          theme === 'dark' ? 'divide-gray-700 bg-gray-800' : 'divide-gray-200 bg-white'
        }`}>
          {data.map((row, rowIndex) => (
            <tr key={rowIndex}>
              {Object.values(row).map((cell, cellIndex) => (
                <td
                  key={cellIndex}
                  className={`
                    px-6 py-4 whitespace-nowrap text-sm
                    ${theme === 'dark' ? 'text-gray-200' : 'text-gray-900'}
                  `}
                >
                  {cell}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
