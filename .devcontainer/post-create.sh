#!/bin/bash

echo "🚀 Inicializando workspace..."

# Instalar extensiones PHP manualmente
echo "📦 Instalando extensiones PHP..."

# Instalar dependencias del sistema necesarias para compilar extensiones
echo "  → Instalando dependencias del sistema..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq > /dev/null 2>&1
sudo apt-get install -y -qq \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    libzstd-dev \
    liblz4-dev \
    > /dev/null 2>&1

# Instalar extensiones PHP usando docker-php-ext-install
echo "  → Instalando pdo_pgsql, pgsql..."
sudo docker-php-ext-install -j$(nproc) pdo_pgsql pgsql > /dev/null 2>&1

echo "  → Instalando zip, gd, intl, bcmath..."
sudo docker-php-ext-install -j$(nproc) zip gd intl bcmath > /dev/null 2>&1

# Instalar Redis via PECL - Responder "no" a todas las opciones excepto usar liblz4 del sistema
echo "  → Instalando redis via PECL..."
# Opciones de redis:
# enable igbinary serializer support? [no] : no
# enable lzf compression support? [no] : no
# enable zstd compression support? [no] : no
# enable msgpack serializer support? [no] : no
# enable lz4 compression? [no] : no
# use system liblz4? [yes] : yes (por defecto)
yes '' | sudo pecl install redis > /dev/null 2>&1 || true
sudo docker-php-ext-enable redis 2>/dev/null || true

# Instalar Xdebug via PECL (no tiene prompts)
echo "  → Instalando xdebug via PECL..."
sudo pecl install xdebug > /dev/null 2>&1 || true
sudo docker-php-ext-enable xdebug 2>/dev/null || true

echo "✅ Extensiones PHP instaladas"

# Configurar Xdebug
echo "🐛 Configurando Xdebug..."
sudo bash -c 'cat > /usr/local/etc/php/conf.d/xdebug.ini << EOF
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
zend_extension=xdebug.so
EOF'

# Verificar extensiones instaladas
echo "🔍 Verificando extensiones instaladas:"
php -m 2>/dev/null | grep -E "pdo_pgsql|pgsql|redis|xdebug|zip|gd|intl|bcmath" | while read ext; do
    echo "  ✓ $ext"
done

# Verificar PHP funcional
echo ""
echo "📋 Información de PHP:"
php -v | head -n 1

# Instalar Composer globalmente si no existe
if ! command -v composer &> /dev/null; then
    echo ""
    echo "📦 Instalando Composer..."
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1
    echo "✅ Composer instalado"
else
    echo ""
    echo "✅ Composer: $(composer --version | head -n 1)"
fi

# Configurar Git
echo ""
echo "🔧 Configurando Git..."
git config --global --add safe.directory /workspace
git config --global --add safe.directory '/workspace/*'
echo "✅ Git configurado"

# Inicializar submodules si existen
echo ""
if [ -f ".gitmodules" ]; then
    echo "📦 Inicializando git submodules..."
    git submodule update --init --recursive
    echo "✅ Submodules inicializados"
else
    echo "ℹ️  No se encontró archivo .gitmodules (normal en proyecto nuevo)"
fi

# Instalar dependencias del monorepo si existe composer.json
echo ""
if [ -f "composer.json" ]; then
    echo "📚 Instalando dependencias de composer (monorepo)..."
    composer install --no-interaction --quiet
    echo "✅ Dependencias del monorepo instaladas"
else
    echo "⚠️  No se encontró composer.json en la raíz"
    echo "   Créalo con: composer init"
fi

# Instalar dependencias de cada paquete en packages/
echo ""
if [ -d "packages" ] && [ "$(ls -A packages 2>/dev/null)" ]; then
    echo "📦 Instalando dependencias de paquetes..."
    for pkg in packages/*/; do
        if [ -f "$pkg/composer.json" ]; then
            pkg_name=$(basename "$pkg")
            echo "  → $pkg_name"
            (cd "$pkg" && composer install --no-interaction --quiet)
        fi
    done
    echo "✅ Dependencias de paquetes instaladas"
else
    echo "ℹ️  Carpeta packages/ vacía o no existe"
fi

# Instalar dependencias de docs si existe
echo ""
if [ -f "docs/package.json" ]; then
    echo "📖 Instalando dependencias de documentación..."
    (cd docs && npm install --silent)
    echo "✅ Dependencias de docs instaladas"
else
    echo "ℹ️  No se encontró docs/package.json"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ¡Workspace completamente configurado!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔧 Comandos útiles para verificar:"
echo "   • php -v                          → Versión de PHP"
echo "   • php -m                          → Extensiones instaladas"
echo "   • composer --version              → Versión de Composer"
echo "   • psql -h postgres -U lbcdev      → Conectar a PostgreSQL (password: secret)"
echo "   • redis-cli -h redis ping         → Probar Redis"
echo ""
echo "📚 Empieza a desarrollar:"
echo "   • cd packages/                    → Navegar a paquetes"
echo "   • composer test                   → Ejecutar tests"
echo "   • composer install                → Instalar dependencias"
echo ""