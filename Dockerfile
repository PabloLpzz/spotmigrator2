# syntax=docker/dockerfile:1

FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:1.27-alpine AS runtime
COPY --from=build /app/public /usr/share/nginx/html
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

RUN chmod -R a+r /usr/share/nginx/html && \
    find /usr/share/nginx/html -type d -exec chmod a+rx {} \;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
