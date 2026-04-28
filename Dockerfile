# Estágio 1: Build (Node 20 é essencial aqui)
FROM node:20-alpine AS build-stage

# Instala ferramentas de compilação
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

COPY package*.json ./

# 1. Instala as dependências ignorando conflitos de versão do React
RUN npm install --legacy-peer-deps

# 2. Garante que os pacotes Web existam (mesmo que não estejam no seu package.json original)
RUN npm install react-dom@19.0.0 react-native-web@0.19.13 @expo/metro-runtime --legacy-peer-deps

COPY . .

# 3. Roda o build forçando o modo de produção e ignorando avisos de ambiente
ENV NODE_ENV=production
RUN npx expo export:web --clear

# Estágio 2: Produção (NGINX)
FROM nginx:stable-alpine AS production-stage

# Tenta copiar da pasta 'dist' (padrão atual do Expo)
# Se falhar no GitHub Actions dizendo que a pasta não existe, mude para 'web-build'
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]