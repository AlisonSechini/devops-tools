# Estágio 1: Build (Usando Node 20 para evitar erros de versão)
FROM node:20-alpine AS build-stage

# Instala dependências de sistema
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

COPY package*.json ./

# Instala as dependências do projeto
RUN npm install

# FORÇA a instalação das dependências Web que o erro apontou
RUN npx expo install react-dom react-native-web @expo/metro-runtime

COPY . .

# Roda o build (usando CI=1 que o log sugeriu)
RUN CI=1 npx expo export:web

# Estágio 2: Produção (NGINX)
FROM nginx:stable-alpine AS production-stage

# No Expo moderno, a pasta de saída é a 'dist'
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]