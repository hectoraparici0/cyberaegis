# Etapa de desarrollo
FROM node:18-alpine

WORKDIR /app

# Copiar archivos de configuración
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY . .

EXPOSE 4000

# Usar nodemon en desarrollo
CMD ["npm", "run", "dev"]
