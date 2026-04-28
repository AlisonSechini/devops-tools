# Estágio 1: Build
FROM node:20-alpine AS build-stage

# Dependências de sistema
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

# Instala o CLI do Expo globalmente para garantir que o comando exista
RUN npm install -g expo-cli

COPY package*.json ./

# Instala dependências ignorando conflitos
RUN npm install --legacy-peer-deps

# Garante suporte Web
RUN npm install react-dom react-native-web @expo/metro-runtime --legacy-peer-deps

COPY . .

# Comando de build definitivo (usando a variável CI=1 para silenciar o terminal)
ENV CI=1
RUN npx expo export --platform web

# Estágio 2: Produção (NGINX)
FROM nginx:stable-alpine AS production-stage

# Tenta copiar da 'dist' (padrão do expo export). 
# Se der erro de "folder not found", mude para 'web-build'
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]