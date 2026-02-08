#!/bin/bash

# Colores para feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MODE=$1

# Validar entrada
if [[ ! "$MODE" =~ ^(off|debug|coverage)$ ]]; then
    echo -e "${RED}❌ Error: Modo no válido.${NC}"
    echo "Uso: xdebug [off|debug|coverage]"
    exit 1
fi

echo -e "${BLUE}🔧 Configurando Xdebug en modo: ${YELLOW}${MODE^^}${NC}..."

# 1. Actualizar el .bashrc para persistencia
if ! grep -q "export XDEBUG_MODE=" ~/.bashrc; then
    echo "export XDEBUG_MODE=$MODE" >> ~/.bashrc
else
    sed -i "s/export XDEBUG_MODE=.*/export XDEBUG_MODE=$MODE/" ~/.bashrc
fi

# 2. Exportar para la sesión actual (Nota: esto solo afecta al script, 
# el alias en el bashrc se encargará del resto)
export XDEBUG_MODE=$MODE

echo -e "${GREEN}✅ Xdebug configurado correctamente.${NC}"
echo -e "Modo activo: $(php -r "echo ini_get('xdebug.mode');")"

if [ "$MODE" == "off" ]; then
    echo -e "${GREEN}🚀 Máxima velocidad activada.${NC}"
else
    echo -e "${YELLOW}⚠️  Modo $MODE activo (el rendimiento puede verse afectado).${NC}"
fi