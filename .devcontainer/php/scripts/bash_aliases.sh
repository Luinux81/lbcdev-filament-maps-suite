#!/bin/bash
# Aliases útiles para el desarrollo

# Función maestra para Xdebug
# Usamos 'source' para que los 'export' del script afecten a esta terminal
xdebug_change() {
    if [ -f /usr/local/bin/xdebug-control.sh ]; then
        # IMPORTANTE: Ejecutamos con 'source' para persistencia de variables
        source /usr/local/bin/xdebug-control.sh "$1"
        
        # Sincronizamos la variable en la shell actual por si el script no lo hizo
        export XDEBUG_MODE="$1"
    else
        echo "❌ Error: xdebug-control.sh no encontrado."
    fi
}

# Xdebug shortcuts
# Redefinimos los alias para usar la nueva función
alias xdebug='xdebug_change debug'
alias xoff='xdebug_change off'
alias xcov='xdebug_change coverage'
alias xstatus='php -r "echo \"xdebug.mode => \" . ini_get(\"xdebug.mode\") . \"\n\";"'

# --- Otros Aliases ---

# Laravel shortcuts
alias art='php artisan'
alias tinker='php artisan tinker'
alias migrate='php artisan migrate'
alias fresh='php artisan migrate:fresh --seed'

# Testing shortcuts
alias t='php artisan test'
alias tf='php artisan test --filter'
alias tc='php artisan test --coverage'

# Crear webapp shortcut
alias mk-webapp='/usr/local/bin/create-webapp'


# LBCDev Scripts
alias showfilestoclipboard='/opt/luinux-scripts/scripts/filesystem/show-selected-files.sh | /opt/luinux-scripts/scripts/utils/set-clipboard.sh'
