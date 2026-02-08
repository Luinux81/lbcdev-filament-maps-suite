#!/bin/bash
# --- CONFIGURACIÓN DE COLORES ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. VALIDACIÓN
if [ ! -f "composer.json" ]; then
    echo -e "${RED}❌ Error: No se encontró composer.json en el directorio actual.${NC}"
    exit 1
fi

# 2. EXTRACCIÓN DEL NOMBRE DEL PAQUETE
PACKAGE_NAME=$(sed -n 's/.*"name": "\(.*\)".*/\1/p' composer.json | head -1)

# 3. COMPROBACIÓN DE DIRECTORIO
if [ -d "webapp" ]; then
    echo -e "${YELLOW}⚠️  La carpeta 'webapp' ya existe.${NC}"
    exit 0
fi

echo -e "${BLUE}🏗️ Creando laboratorio Laravel para: ${YELLOW}${PACKAGE_NAME}${NC}"

# 4. CREAR PROYECTO
composer create-project laravel/laravel webapp --quiet

# 5. CONFIGURAR REPOSITORIO LOCAL
echo -e "${GREEN}🔗 Vinculando paquete raíz al laboratorio...${NC}"
cd webapp
composer config repositories.local '{"type": "path", "url": "..", "options": {"symlink": true}}' --file composer.json

# 6. INSTALACIÓN INICIAL
echo -e "${GREEN}⚙️  Configurando .env y dependencias base...${NC}"
[ ! -f ".env" ] && cp .env.example .env
php artisan key:generate --quiet
composer install --no-interaction --quiet
npm install --silent

# 7. INTERACCIÓN: ¿REQUERIR PAQUETE?
echo -e "\n${BLUE}❓ ¿Deseas instalar ${YELLOW}${PACKAGE_NAME}${BLUE} ahora mismo en la webapp? (s/N)${NC}"
read -r response

if [[ "$response" =~ ^([sS][iI]|[sS]|[yY][eE][sS]|[yY])$ ]]; then
    echo -e "${BLUE}📦 Instalando ${PACKAGE_NAME}...${NC}"
    if composer require "${PACKAGE_NAME}:@dev" --no-interaction; then
        echo -e "${GREEN}✅ Paquete instalado correctamente en la webapp.${NC}"
    else
        echo -e "${RED}❌ Error al instalar el paquete. Revisa las dependencias en composer.json.${NC}"
    fi
else
    echo -e "${YELLOW}ℹ️  Instalación omitida.${NC}"
    echo -e "${BLUE}💡 Puedes hacerlo más tarde con: ${NC}cd webapp && composer require ${PACKAGE_NAME}:@dev"
fi

cd ..

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Proceso finalizado.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"