# DevContainer - QR Showers

## Estructura

```shell
.devcontainer/
├── nginx/          # Servidor web
├── php/            # PHP-FPM
├── mysql/          # Base de datos
├── redis/          # Cache y Colas (implícito en docker-compose)
└── docker-compose.yml
```

## Uso

### Con VSCode

1. Abrir proyecto en VSCode
2. F1 → "Dev Containers: Reopen in Container"

### Manual

```bash
cd .devcontainer
docker-compose up -d
docker-compose exec php bash
```

## Configuración Laravel

```bash
# Dentro del contenedor PHP (desde /workspace)
cd webapp
cp .env.example .env
php artisan key:generate
php artisan migrate
```

## Acceso

- Web: <http://localhost:8080>
- MySQL: localhost:3307 (user: dev, pass: dev)
- Redis: localhost:6379

## Redis - Cache y Colas

Redis está configurado como driver para:

- **Cache**: Almacenamiento rápido en memoria
- **Colas**: Procesamiento asíncrono de trabajos
- **Sesiones**: Gestión de sesiones de usuario

### Verificar conexión a Redis

```bash
# Desde el contenedor PHP
php artisan tinker
>>> Redis::ping()
# Debería retornar: "PONG"

# O usando redis-cli directamente
docker exec -it qr_showers_redis redis-cli ping
```

### Usar Cache

```php
// Guardar en caché
Cache::put('key', 'value', 3600); // 3600 segundos

// Recuperar de caché
$value = Cache::get('key');

// Cache con callback (remember)
$users = Cache::remember('users', 3600, function () {
    return User::all();
});

// Limpiar caché
Cache::flush();
```

### Usar Colas

```bash
# Crear un Job
php artisan make:job ProcessShowerUsage

# Despachar el job
ProcessShowerUsage::dispatch($data);

# Ejecutar el worker de colas (en desarrollo)
php artisan queue:work redis --tries=3

# Ver trabajos fallidos
php artisan queue:failed

# Reintentar trabajos fallidos
php artisan queue:retry all
```

### Comandos útiles de Redis

```bash
# Ver todas las claves
docker exec -it qr_showers_redis redis-cli KEYS '*'

# Ver información del servidor
docker exec -it qr_showers_redis redis-cli INFO

# Limpiar toda la base de datos Redis (¡cuidado!)
docker exec -it qr_showers_redis redis-cli FLUSHALL

# Monitorear comandos en tiempo real
docker exec -it qr_showers_redis redis-cli MONITOR
```

### Bases de datos Redis separadas

El proyecto usa diferentes bases de datos Redis para separar responsabilidades:

- **DB 0**: Conexión por defecto
- **DB 1**: Cache
- **DB 2**: Colas
- **DB 3**: Sesiones

Esto permite limpiar selectivamente cada tipo de datos sin afectar los demás.

## Git y SSH

### Desarrollo Local (DevContainer)

El devcontainer monta tu carpeta `~/.ssh` del host, permitiéndote usar tus claves SSH para git push/pull.
Los permisos se corrigen automáticamente al iniciar el contenedor.

Para verificar que SSH funciona:

```bash
ssh -T git@github.com
# o
ssh -T git@gitlab.com
```

**Ventajas de este enfoque:**

- ✅ No depende de sockets temporales que cambian al reiniciar
- ✅ Funciona de forma consistente sin scripts adicionales
- ✅ Los permisos SSH se corrigen automáticamente en el entrypoint

### Producción/VPS

Para producción, usa `docker-compose.production.yml` que no monta SSH del host.
En su lugar, configura las claves SSH directamente en el contenedor o usa HTTPS para Git.

## Xdebug - Cambiar entre modos

El devcontainer incluye scripts para cambiar fácilmente entre diferentes modos de Xdebug sin necesidad de reconstruir el contenedor:

### Modo Debug (Rápido - Recomendado para desarrollo)

```bash
xdebug-debug
source ~/.bashrc
```

Activa solo el debugger. Los tests son **mucho más rápidos**.

### Modo Coverage (Lento - Solo para análisis de cobertura)

```bash
xdebug-coverage
source ~/.bashrc
```

Activa el análisis de cobertura de código. Los tests son **significativamente más lentos**.

### Desactivar Xdebug (Máxima velocidad)

```bash
xdebug-off
source ~/.bashrc
```

Desactiva Xdebug completamente. Máxima velocidad de ejecución.

### Verificar modo actual

```bash
php -i | grep "xdebug.mode"
```

**Nota:** Los cambios se aplican inmediatamente sin necesidad de reiniciar el contenedor.

## Troubleshooting

### Error 502 Bad Gateway

Si recibes un error 502 al acceder a `http://localhost:8080`, significa que PHP-FPM no está corriendo.

**Solución rápida:**

```bash
./.devcontainer/start-php-fpm.sh
```

**Verificar que PHP-FPM está corriendo:**

```bash
ps aux | grep php-fpm
```

Deberías ver algo como:

```shell
1585 dev       0:00 php-fpm: master process
1587 dev       0:00 php-fpm: pool www
1588 dev       0:00 php-fpm: pool www
```

**¿Por qué ocurre esto?**

VS Code Dev Containers puede sobrescribir el comando por defecto del contenedor. Si `overrideCommand: true` está en `devcontainer.json`, PHP-FPM no se iniciará automáticamente.

**Solución permanente:**

Asegúrate de que `devcontainer.json` tenga:

```json
"overrideCommand": false
```

Luego haz rebuild del contenedor.

### Error 'ContainerConfig' al hacer Rebuild

Si recibes el error `KeyError: 'ContainerConfig'` al hacer rebuild del devcontainer, usa una de estas soluciones:

#### Opción 1: Script de Rebuild Seguro (Recomendado)

```bash
./.devcontainer/rebuild-safe.sh
```

Luego haz rebuild desde VS Code (Ctrl+Shift+P → "Dev Containers: Rebuild Container")

#### Opción 2: Limpieza Manual Específica

```bash
# Detener y eliminar solo los contenedores del proyecto
docker-compose -f .devcontainer/docker-compose.yml down --remove-orphans
docker rm -f qr_showers_php qr_showers_nginx qr_showers_mysql
```

#### Opción 3: Limpieza Completa (Solo si las anteriores fallan)

```bash
docker rm -f $(docker ps -aq)
```

⚠️ **Advertencia**: Esto eliminará TODOS los contenedores, no solo los del proyecto.

#### ¿Por qué ocurre este error?

El error ocurre cuando Docker Compose intenta recrear contenedores que tienen metadatos corruptos o incompletos. Esto puede suceder cuando:

- Los contenedores se detienen abruptamente
- Hay cambios en las imágenes base pero los contenedores viejos persisten
- Hay inconsistencias entre el estado de Docker y los metadatos

**Cambios implementados para prevenir este problema:**

- `restart: unless-stopped` en todos los servicios
- `shutdownAction: stopCompose` en devcontainer.json
- Scripts de limpieza específicos del proyecto

### Error 404 en rutas dinámicas de Laravel (Flux UI, Livewire, etc.)

Si recibes errores 404 para rutas como `/flux/flux.js`, `/livewire/livewire.js` u otras rutas dinámicas que Laravel debería manejar, el problema es que nginx está intentando servir estos archivos como estáticos antes de pasarlos a Laravel.

**Síntomas:**

- Error 404 en la consola del navegador para `/flux/flux.js`
- Componentes de Flux UI no funcionan (dropdowns, modals, etc.)
- Alpine.js funciona pero los componentes Flux no responden a clicks

**Causa:**
La configuración de nginx en `.devcontainer/nginx/default.conf` tiene una regla que sirve todos los archivos `.js` como estáticos. Cuando Laravel registra rutas dinámicas (como `/flux/flux.js`), nginx intenta buscar el archivo físico en `/workspace/webapp/public/flux/flux.js`, que no existe.

**Solución:**
Agregar excepciones en nginx para que las rutas dinámicas sean manejadas por Laravel antes de la regla de archivos estáticos.

En `.devcontainer/nginx/default.conf`, **antes** de la sección de optimización de archivos estáticos, agregar:

```nginx
# Rutas de Flux - deben ser manejadas por Laravel
location ^~ /flux/ {
    try_files $uri $uri/ /index.php?$query_string;
}
```

**Después de modificar la configuración de nginx, reiniciar el contenedor:**

```bash
# Desde el host (fuera del devcontainer)
docker compose -f .devcontainer/docker-compose.yml restart nginx
```

**⚠️ Importante:** Si instalas otros paquetes que usen rutas dinámicas similares (como `/livewire/`, `/telescope/`, etc.), necesitarás agregar excepciones similares en nginx.

### Otros problemas

Si el devcontainer no inicia por otras razones:

```bash
cd .devcontainer
docker-compose down -v
docker ps -a | grep -E "laravel|qr_showers" | awk '{print $1}' | xargs -r docker rm -f
docker-compose up -d
```
