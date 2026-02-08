#!/bin/bash
# Aliases útiles para el desarrollo

# Función para cambiar Xdebug y aplicar cambios al instante
xdebug() {
    /usr/local/bin/xdebug-control.sh "$1"
    # Aplicamos el cambio a la sesión actual inmediatamente
    export XDEBUG_MODE="$1"
}

# Xdebug shortcuts
alias xoff="xdebug off"
alias xdebug="xdebug debug"
alias xcov="xdebug coverage"
alias xstatus='php -i | grep "xdebug.mode"'

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