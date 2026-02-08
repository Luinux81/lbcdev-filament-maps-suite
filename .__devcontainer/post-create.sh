#!/bin/bash

echo "🚀 Inicializando workspace..."

# 1. Descargar el instalador de extensiones si no existe
if [ ! -f "/usr/local/bin/install-php-extensions" ]; then
    echo "📥 Descargando instalador de extensiones PHP..."
    sudo curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions
    sudo chmod +x /usr/local/bin/install-php-extensions
fi

# Instalar extensiones PHP manualmente
echo "📦 Instalando extensiones PHP..."

# 2. Instalar extensiones con el instalador (gestiona dependencias de sistema por ti)
echo "📦 Instalando extensiones PHP (intl, zip, gd, bcmath, pdo_pgsql, pgsql, redis, xdebug)..."
# Este comando es atómico: instala, configura y habilita.
sudo install-php-extensions intl zip gd bcmath pdo_pgsql pgsql redis xdebug 

echo "🔍 DEBUG: ¿Dónde están los archivos .ini?"
ls -l /usr/local/etc/php/conf.d/

echo "🔍 DEBUG: ¿Qué archivos está cargando PHP realmente?"
php --ini

echo "🔍 Verificando extensiones instaladas:"
# Si alguna de estas falla, el script se detendrá aquí por el 'set -e'
php -m | grep -E "intl|zip|gd|pdo_pgsql|redis"

# Si llegamos aquí, las extensiones están vivas.
echo "✅ Verificación exitosa"

echo "✅ Extensiones PHP instaladas"

# 3. Configurar Xdebug
echo "🐛 Configurando Xdebug..."
sudo bash -c 'cat > /usr/local/etc/php/conf.d/xdebug.ini << EOF
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
zend_extension=xdebug.so
EOF'

# 4. Forzar refresco de la configuración para Composer
# A veces el socket de PHP queda en caché durante el post-create
# export PHP_INI_SCAN_DIR=:/usr/local/etc/php/conf.d

# Verificar extensiones instaladas
echo "🔍 Verificando extensiones instaladas:"
php -m 2>/dev/null | grep -E "pdo_pgsql|pgsql|redis|xdebug|zip|gd|intl|bcmath" | while read ext; do
    echo "  ✓ $ext"
done

# Verificar PHP funcional
echo ""
echo "📋 Información de PHP:"
php -v | head -n 1

read -p "Press enter to continue"

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