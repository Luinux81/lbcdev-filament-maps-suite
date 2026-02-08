# Archivo: .devcontainer/php/Dockerfile
# DevContainer para Laravel
FROM php:8.3-fpm-alpine

# Variables de entorno para UID/GID
ENV UID=1000
ENV GID=1000

# FLUTTER DESHABILITADO: Variables de entorno para Flutter
# ENV FLUTTER_HOME=/opt/flutter
# ENV FLUTTER_VERSION=3.27.1
# ENV PATH="$FLUTTER_HOME/bin:$PATH"
# ENV PUB_CACHE=/home/dev/.pub-cache

# FLUTTER DESHABILITADO: Variables de entorno para Android SDK
# ENV ANDROID_HOME=/opt/android-sdk
# ENV ANDROID_SDK_ROOT=/opt/android-sdk
# ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# 1. Instalación de dependencias del sistema necesarias para compilar extensiones PHP
RUN apk update && apk add --no-cache \
    # Utilidades básicas
    git \
    curl \
    bash \
    openssh-client \
    sqlite \
    unzip \
    xz \
    # Node.js y NPM
    nodejs \
    npm \
    # Dependencias para compilar extensiones PHP
    autoconf \
    g++ \
    make \
    # Librerías específicas para cada extensión PHP
    icu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    sqlite-dev \
    # FLUTTER DESHABILITADO: Dependencias para Flutter (desarrollo Linux desktop opcional)
    # clang \
    # cmake \
    # ninja \
    # pkgconf \
    # gtk+3.0-dev \
    # FLUTTER DESHABILITADO: Java para Android tooling (solo comandos básicos, sin Android Studio)
    # openjdk17-jdk \
    # FLUTTER DESHABILITADO: Android platform tools (incluye adb)
    # android-tools \
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

# FLUTTER DESHABILITADO: 4. Instalación de Android SDK command-line tools
# RUN mkdir -p $ANDROID_HOME/cmdline-tools \
#     && cd /tmp \
#     && curl -L https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip \
#     && unzip cmdline-tools.zip \
#     && mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest \
#     && rm cmdline-tools.zip \
#     && yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses || true \
#     && $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# FLUTTER DESHABILITADO: 5. Instalación de Flutter SDK
# Instalar glibc para Alpine (requerido por Dart/Flutter)
# RUN apk add --no-cache gcompat \
#     && mkdir -p $FLUTTER_HOME \
#     && cd /tmp \
#     && curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -o flutter.tar.xz \
#     && tar xf flutter.tar.xz -C /opt \
#     && rm flutter.tar.xz \
#     && git config --global --add safe.directory /opt/flutter \
#     && flutter --version --suppress-analytics \
#     && flutter config --no-analytics \
#     && flutter config --android-sdk $ANDROID_HOME \
#     && flutter precache --linux --android --no-ios --no-web

# 6. Directorio de trabajo y configuración de usuario
WORKDIR /workspace
RUN addgroup -g $GID dev \
    && adduser -u $UID -G dev -s /bin/bash -D dev \
    && mkdir -p /workspace /home/dev/.ssh \
    && chown -R dev:dev /workspace /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# 7. Configurar PHP-FPM para correr como usuario dev
COPY php/php-fpm.conf /usr/local/etc/php-fpm.d/zz-custom.conf

# 8. Copiar configuración personalizada de PHP
COPY php/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# 9. Copiar script para corregir permisos SSH y scripts de Xdebug
COPY php/fix-ssh-permissions.sh /usr/local/bin/fix-ssh-permissions.sh
COPY xdebug-debug.sh /usr/local/bin/xdebug-debug
COPY xdebug-coverage.sh /usr/local/bin/xdebug-coverage
COPY xdebug-off.sh /usr/local/bin/xdebug-off
COPY php/bash_aliases.sh /etc/profile.d/bash_aliases.sh
RUN chmod +x /usr/local/bin/fix-ssh-permissions.sh \
    && chmod +x /usr/local/bin/xdebug-debug \
    && chmod +x /usr/local/bin/xdebug-coverage \
    && chmod +x /usr/local/bin/xdebug-off \
    && chmod +x /etc/profile.d/bash_aliases.sh \
    && echo 'source /etc/profile.d/bash_aliases.sh' >> /home/dev/.bashrc

# 10. Crear entrypoint mejorado que ejecute el script y luego PHP-FPM
RUN echo '#!/bin/sh' > /usr/local/bin/docker-entrypoint.sh \
    && echo 'set -e' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '# Corregir permisos SSH si estamos como dev' >> /usr/local/bin/docker-entrypoint.sh \
    && echo 'if [ "$(id -u)" = "1000" ]; then' >> /usr/local/bin/docker-entrypoint.sh \
    && echo '    /usr/local/bin/fix-ssh-permissions.sh' >> /usr/local/bin/docker-entrypoint.sh \
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
