#!/bin/bash

echo "🚀 Inicializando workspace..."

# Instalar extensiones PHP manualmente
echo "📦 Instalando extensiones PHP..."

# Instalar dependencias del sistema necesarias para compilar extensiones
sudo apt-get update
sudo apt-get install -y \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libicu-dev

# Instalar extensiones PHP usando docker-php-ext-install
echo "  → Instalando pdo_pgsql, pgsql..."
sudo docker-php-ext-install pdo_pgsql pgsql

echo "  → Instalando zip, gd, intl, bcmath..."
sudo docker-php-ext-install zip gd intl bcmath

# Instalar Redis y Xdebug via PECL
echo "  → Instalando redis y xdebug via PECL..."
sudo pecl install redis xdebug
sudo docker-php-ext-enable redis xdebug

echo "✅ Extensiones PHP instaladas"

# Configurar Xdebug
echo "🐛 Configurando Xdebug..."
sudo bash -c 'cat > /usr/local/etc/php/conf.d/xdebug.ini << EOF
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
EOF'

# Verificar extensiones instaladas
echo "🔍 Verificando extensiones instaladas:"
php -m | grep -E "pdo_pgsql|pgsql|redis|xdebug|zip|gd|intl|bcmath"

# Instalar Composer globalmente si no existe (aunque ya debería estar)
if ! command -v composer &> /dev/null; then
    echo "📦 Instalando Composer..."
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
else
    echo "✅ Composer ya está instalado: $(composer --version)"
fi

# Configurar Git
echo "🔧 Configurando Git..."
git config --global --add safe.directory /workspace
git config --global --add safe.directory '/workspace/*'

# Inicializar submodules si existen
if [ -f ".gitmodules" ]; then
    echo "📦 Inicializando git submodules..."
    git submodule update --init --recursive
else
    echo "⚠️  No se encontró archivo .gitmodules (normal si es nuevo proyecto)"
fi

# Instalar dependencias del monorepo si existe composer.json
if [ -f "composer.json" ]; then
    echo "📚 Instalando dependencias de composer (monorepo)..."
    composer install
else
    echo "⚠️  No se encontró composer.json en la raíz (normal si es nuevo proyecto)"
    echo "   Puedes crearlo después con 'composer init'"
fi

# Instalar dependencias de cada paquete en packages/
if [ -d "packages" ]; then
    echo "📦 Buscando paquetes en packages/..."
    for pkg in packages/*/; do
        if [ -f "$pkg/composer.json" ]; then
            echo "  → Instalando dependencias de $pkg..."
            (cd "$pkg" && composer install)
        fi
    done
else
    echo "ℹ️  Carpeta packages/ no existe aún"
fi

# Instalar dependencias de docs si existe
if [ -f "docs/package.json" ]; then
    echo "📖 Instalando dependencias de documentación..."
    (cd docs && npm install)
else
    echo "ℹ️  Carpeta docs/ no existe aún"
fi

echo ""
echo "✅ ¡Workspace listo!"
echo ""
echo "📌 Próximos pasos:"
echo "   1. Crear composer.json en la raíz si vas a usar meta-package"
echo "   2. Inicializar git submodules si vas a usarlos"
echo "   3. Empezar a desarrollar en packages/"
echo ""