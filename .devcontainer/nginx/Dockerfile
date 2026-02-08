# Archivo: .devcontainer/nginx/Dockerfile
FROM nginx:alpine

# Variables de entorno para UID/GID
ENV UID=1000
ENV GID=1000

# Crear usuario dev
RUN addgroup -g $GID dev \
    && adduser -u $UID -G dev -s /bin/bash -D dev

# Crear directorios necesarios para nginx
RUN mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    /var/log/nginx \
    && chown -R dev:dev /var/cache/nginx \
    && chown -R dev:dev /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown dev:dev /var/run/nginx.pid

# Copiar configuraciones
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

USER dev
CMD ["nginx", "-g", "daemon off;"]
