# Estágio 1: Build
FROM node:18-alpine AS build-stage

# 1. Instala dependências de sistema necessárias para compilação no Linux
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

# 2. Copia apenas os arquivos de dependências primeiro (otimiza o cache)
COPY package*.json ./

# 3. Instala TUDO (incluindo devDependencies necessárias para o build)
RUN npm install

# 4. Copia o restante do código
COPY . .

# 5. Roda o export web com uma flag para evitar travar em avisos
RUN npx expo export:web --non-interactive

# Estágio 2: Produção (NGINX)
FROM nginx:stable-alpine AS production-stage
# O Expo 50+ agora costuma gerar na pasta /dist por padrão, 
# se o seu for antigo e gerar 'web-build', troque o nome abaixo:
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]