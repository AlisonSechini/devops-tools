# Estágio 1: Build da versão Web do App Mobile
FROM node:18-alpine AS build-stage

# Instala as dependências necessárias para o Expo
RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package*.json ./
# Instala as dependências (inclusive o expo-cli)
RUN npm install

COPY . .

# Comando correto para gerar a versão Web no Expo
# Isso vai criar uma pasta chamada 'web-build' ou 'dist'
RUN npx expo export:web

# Estágio 2: Servir com NGINX
FROM nginx:stable-alpine AS production-stage

# O comando export:web costuma gerar a pasta 'web-build'
# Se o seu gerar 'dist', mude de /app/web-build para /app/dist abaixo
COPY --from=build-stage /app/web-build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]