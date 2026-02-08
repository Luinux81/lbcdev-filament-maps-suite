#!/bin/bash
# --- CONFIGURACIÓN DE COLORES ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Comprobar si ya existe para evitar desastres
if [ -d "webapp" ]; then
    echo -e "${YELLOW}⚠️  La carpeta 'webapp' ya existe. Si quieres recrearla, bórrala primero.${NC}"
    exit 0
fi

echo -e "${BLUE}🏗️ Creando nuevo laboratorio Laravel (webapp)...${NC}"

# 1. Crear proyecto
composer create-project laravel/laravel webapp --quiet

# 2. Configurar el repositorio local (Symlink)
echo -e "${GREEN}🔗 Vinculando paquete raíz al laboratorio...${NC}"
cd webapp
composer config repositories.local '{"type": "path", "url": "..", "options": {"symlink": true}}' --file composer.json

# 3. Instalación inicial y entorno
echo -e "${GREEN}⚙️  Configurando .env y dependencias...${NC}"
[ ! -f ".env" ] && cp .env.example .env
php artisan key:generate --quiet
composer install --no-interaction --quiet
npm install --silent

cd ..

echo -e "${GREEN}✅ Laboratorio 'webapp' creado con éxito.${NC}"
echo -e "${BLUE}💡 Sugerencia: Ejecuta 'cd webapp && composer require tu-vendor/tu-paquete:@dev' para empezar a probar.${NC}"