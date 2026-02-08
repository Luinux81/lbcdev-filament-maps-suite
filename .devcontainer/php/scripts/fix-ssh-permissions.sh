#!/bin/sh
# Script para corregir permisos de SSH

if [ -d "/home/dev/.ssh" ]; then
    echo "🔧 Corrigiendo permisos de SSH..."

    # Directorio .ssh debe tener permisos 700
    chmod 700 /home/dev/.ssh 2>/dev/null || true

    # Archivos de configuración deben tener permisos 600
    if [ -f "/home/dev/.ssh/config" ]; then
        chmod 600 /home/dev/.ssh/config 2>/dev/null || true
    fi

    # Claves privadas deben tener permisos 600
    find /home/dev/.ssh -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true

    # Claves públicas pueden tener permisos 644
    find /home/dev/.ssh -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true

    # known_hosts debe tener permisos 644
    if [ -f "/home/dev/.ssh/known_hosts" ]; then
        chmod 644 /home/dev/.ssh/known_hosts 2>/dev/null || true
    fi

    echo "✅ Permisos de SSH corregidos"
else
    echo "ℹ️  Directorio .ssh no encontrado, omitiendo corrección de permisos"
fi

