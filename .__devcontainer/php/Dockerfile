# Archivo: .devcontainer/php/Dockerfile
# DevContainer para Laravel
FROM php:8.3-fpm-alpine

# Variables de entorno para UID/GID
ENV UID=1000
ENV GID=1000

# 1. Instalación de dependencias del sistema necesarias para compilar extensiones PHP
RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    openssh-client \
    sqlite \
    unzip \
    xz \
    nodejs \
    npm \
    autoconf \
    g++ \
    make \
    icu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    sqlite-dev \
    && npm install -g pnpm \
    && rm -rf /var/cache/apk/*

# 2. Instalación de extensiones PHP usando docker-php-ext-*
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mysqli \
    pdo_sqlite \
    mbstring \
    xml \
    gd \
    intl \
    zip \
    opcache \
    exif \
    && docker-php-ext-enable \
    pdo_mysql \
    mysqli \
    mbstring \
    xml \
    gd \
    intl \
    zip \
    opcache \
    exif

# 2.5. Instalar Xdebug y Redis
RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    && pecl install xdebug redis \
    && docker-php-ext-enable xdebug redis \
    && apk del $PHPIZE_DEPS

# 3. Instalación de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Directorio de trabajo y configuración de usuario
WORKDIR /workspace
RUN addgroup -g $GID dev \
    && adduser -u $UID -G dev -s /bin/bash -D dev \
    && mkdir -p /workspace /home/dev/.ssh \
    && chown -R dev:dev /workspace /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# NOTA: Las siguientes copias de archivos de configuración están comentadas
# porque los archivos no fueron provistos. Si quieres que los incluya,
# dime y los crearé o los descomento.
# COPY php/php-fpm.conf /usr/local/etc/php-fpm.d/zz-custom.conf
# COPY php/php.ini /usr/local/etc/php/conf.d/custom.ini
# COPY php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# COPY php/fix-ssh-permissions.sh /usr/local/bin/fix-ssh-permissions.sh
# COPY xdebug-debug.sh /usr/local/bin/xdebug-debug
# COPY xdebug-coverage.sh /usr/local/bin/xdebug-coverage
# COPY xdebug-off.sh /usr/local/bin/xdebug-off
# COPY php/bash_aliases.sh /etc/profile.d/bash_aliases.sh

# Crear entrypoint que corrige permisos SSH y arranca php-fpm por defecto
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh \
    && echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '# Corregir permisos SSH si estamos como dev' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ "$(id -u)" = "1000" ]; then' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '    if [ -d /home/dev/.ssh ]; then' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '        chown -R dev:dev /home/dev/.ssh' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '        chmod 700 /home/dev/.ssh' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '    fi' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'fi' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '# Si no se pasa comando, ejecutar php-fpm' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ "$#" -eq 0 ]; then' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '    exec php-fpm -F -R' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'else' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '    exec "$@"' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'fi' >> /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD []
