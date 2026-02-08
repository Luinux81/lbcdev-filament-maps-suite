#!/bin/bash
# .devcontainer/php/scripts/xdebug-control.sh

# Colores para feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MODE=${1:-"status"}
FORCE_FPM=${2:-"yes"}

# Si solo se pide status, lo mostramos y salimos
if [ "$MODE" == "status" ]; then
    CLI_MODE=$(php -r "echo ini_get('xdebug.mode');")
    echo -e "${BLUE}📍 Estado actual de Xdebug:${NC}"
    echo -e "   CLI: ${YELLOW}$CLI_MODE${NC}"
    exit 0
fi

# Validar entrada
if [[ ! "$MODE" =~ ^(off|debug|coverage|develop|profile|trace)$ ]]; then
    echo -e "${RED}❌ Error: Modo '$MODE' no válido.${NC}"
    exit 1
fi

echo -e "${BLUE}🔧 Cambiando Xdebug a modo: ${YELLOW}${MODE^^}${NC}..."

# 1. Export para la sesión actual (gracias al 'source' en el alias funcionará)
export XDEBUG_MODE=$MODE

# 2. Actualizar el archivo INI dinámico
# (Asegúrate de haber hecho el chown dev:dev en el Dockerfile)
INI_FILE="/usr/local/etc/php/conf.d/zz-xdebug-runtime.ini"
echo "xdebug.mode=$MODE" > "$INI_FILE"

# 3. Intentar recargar PHP-FPM
if [ "$FORCE_FPM" == "yes" ]; then
    echo -e "${BLUE}🔄 Intentando recargar PHP-FPM...${NC}"
    
    # Intentamos enviar la señal. Si falla por permisos, no ensuciamos la pantalla.
    if kill -USR2 1 2>/dev/null; then
        echo -e "${GREEN}✅ PHP-FPM recargado (PID 1).${NC}"
    else
        echo -e "${YELLOW}⚠️  Nota: No se pudo enviar señal de recarga al proceso root.${NC}"
        echo -e "${YELLOW}   PHP-FPM aplicará el cambio en el próximo ciclo o petición.${NC}"
    fi
fi

# 4. Verificación final en CLI
CLI_CHECK=$(php -r "echo ini_get('xdebug.mode');")
echo -e "${GREEN}✅ Configuración CLI actualizada a: ${YELLOW}$CLI_CHECK${NC}"