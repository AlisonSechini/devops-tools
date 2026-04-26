# Estágio 1: Build (Node.js)
FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Estágio 2: Produção (NGINX)
FROM nginx:stable-alpine AS production-stage
# Copia os arquivos compilados do estágio anterior para a pasta do Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]