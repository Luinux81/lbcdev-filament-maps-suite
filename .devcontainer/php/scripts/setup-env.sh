#!/bin/bash

# --- CONFIGURACIÓN DE COLORES ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🚀 INICIALIZANDO WORKSPACE LARAVEL ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 1. SEGURIDAD DE GIT (Fundamental para Monorepos y Submódulos)
echo -e "${GREEN}🔧 Configurando permisos de Git...${NC}"
git config --global --add safe.directory /workspace
git config --global --add safe.directory '/workspace/*'

# 2. GESTIÓN DE SUBMÓDULOS
if [ -f ".gitmodules" ]; then
    echo -e "${GREEN}📦 Detectados submódulos. Sincronizando...${NC}"
    git submodule update --init --recursive
else
    echo -e "${YELLOW}ℹ️  No se detectaron submódulos Git.${NC}"
fi

# 3. DEPENDECIAS DE LA RAÍZ (Paquete o Monorepo)
if [ -f "composer.json" ]; then
    echo -e "${GREEN}📚 Instalando dependencias en la raíz...${NC}"
    composer install --no-interaction
else
    echo -e "${YELLOW}ℹ️  No hay composer.json en la raíz.${NC}"
fi

# 4. INTELIGENCIA MONOREPO (Sub-paquetes)
if [ -d "packages" ] && [ "$(ls -A packages 2>/dev/null)" ]; then
    echo -e "${BLUE}📂 Monorepo detectado. Procesando carpeta 'packages/'...${NC}"
    for pkg in packages/*/; do
        if [ -f "$pkg/composer.json" ]; then
            pkg_name=$(basename "$pkg")
            echo -e "  → Instalando: ${YELLOW}$pkg_name${NC}"
            (cd "$pkg" && composer install --no-interaction --quiet)
        fi
    done
else
    echo -e "${YELLOW}ℹ️  No se detectaron sub-paquetes en 'packages/'.${NC}"
fi

# 5. LÓGICA DE LABORATORIO (webapp)
# Si no hay webapp, ni packages, ni carpeta src, creamos un Laravel fresco
if [ ! -d "webapp" ] && [ ! -d "packages" ] && [ ! -d "src" ]; then
    echo -e "${YELLOW}🏗️ Entorno vacío detectado. Creando laboratorio Laravel...${NC}"
    composer create-project laravel/laravel webapp
    echo -e "${GREEN}🔗 Vinculando paquete raíz al laboratorio...${NC}"
    cd webapp
    composer config repositories.local '{"type": "path", "url": "..", "options": {"symlink": true}}' --file composer.json
    cd ..
fi

# 6. CONFIGURACIÓN DE LA WEBAPP (Sea laboratorio o proyecto real)
if [ -d "webapp" ]; then
    echo -e "${BLUE}🖥️  Configurando aplicación 'webapp'...${NC}"
    cd webapp
    
    # Instalación de Composer
    if [ -f "composer.json" ]; then
        composer install --no-interaction
    fi

    # Configuración de Entorno (.env)
    if [ ! -f ".env" ]; then
        echo -e "  → Creando archivo .env..."
        cp .env.example .env
        php artisan key:generate
    fi

    # Dependencias JS (Vite/NPM)
    if [ -f "package.json" ]; then
        echo -e "  → Instalando dependencias NPM..."
        npm install --silent
    fi
    
    cd ..
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ ¡CONFORMADO! El entorno está listo para trabajar.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"