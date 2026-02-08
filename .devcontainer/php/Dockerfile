# Archivo: .devcontainer/php/Dockerfile
FROM php:8.3-fpm-alpine

# Variables de entorno para UID/GID
ENV UID=1000
ENV GID=1000

# 1. Instalación de dependencias del sistema
RUN apk update && apk add --no-cache \
    git \
    curl \
    bash \
    openssh-client \
    sqlite \
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
    linux-headers \
    && npm install -g pnpm \
    && rm -rf /var/cache/apk/*

# 2. Instalación de extensiones PHP (Compilación manual)
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
    opcache

# 3. Instalación de Xdebug y Redis vía PECL
# Instalamos $PHPIZE_DEPS temporalmente para la compilación
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install xdebug redis \
    && docker-php-ext-enable xdebug redis \
    && apk del .build-deps

# 4. Instalación de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Directorio de trabajo y configuración de usuario
WORKDIR /workspace
RUN addgroup -g $GID dev \
    && adduser -u $UID -G dev -s /bin/bash -D dev \
    && mkdir -p /workspace /home/dev/.ssh \
    && chown -R dev:dev /workspace /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# 6. Copiar configuraciones
COPY php/config/php-fpm.conf /usr/local/etc/php-fpm.d/zz-custom.conf
COPY php/config/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY php/config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# 7. Copiar scripts
COPY php/scripts/fix-ssh-permissions.sh /usr/local/bin/fix-ssh-permissions.sh
COPY php/scripts/setup-env.sh /usr/local/bin/setup-env.sh
COPY php/scripts/xdebug-control.sh /usr/local/bin/xdebug-control.sh
COPY php/scripts/bash_aliases.sh /etc/profile.d/bash_aliases.sh

RUN chmod +x /usr/local/bin/fix-ssh-permissions.sh \
    && chmod +x /usr/local/bin/setup-env.sh \
    && chmod +x /usr/local/bin/xdebug-control.sh \
    && chmod +x /etc/profile.d/bash_aliases.sh \
    && echo 'source /etc/profile.d/bash_aliases.sh' >> /home/dev/.bashrc

# 8. Entrypoint mejorado
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh \
    && echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ "$(id -u)" = "1000" ]; then /usr/local/bin/fix-ssh-permissions.sh; fi' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ "$#" -eq 0 ]; then exec php-fpm -F -R; else exec "$@"; fi' >> /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD []