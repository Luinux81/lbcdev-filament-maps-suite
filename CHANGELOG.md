# Changelog

Todos los cambios notables del monorepo `lbcdev-filament-maps-suite`.

## [Unreleased]

### Infraestructura

- ✅ DevContainer con PHP 8.3, Composer, Node.js
- ✅ Xdebug en modo trigger
- ✅ VS Code Workspace multi-repositorio
- ✅ Monorepo con 4 paquetes como git submodules

### Paquetes

#### Core (`livewire-maps-core`) - ✅ COMPLETO

**Added**:

- `LivewireMapsServiceProvider` con auto-discovery
- Componente `LivewireMap` (243 líneas)
  - Soporte single marker (`Marker`)
  - Soporte multi-marker (`MarkerCollection`)
  - Modo legacy retrocompatible (lat/lng)
  - Métodos: `addMarker()`, `removeMarker()`, `clearMarkers()`
  - Propiedades computadas: `markersData`, `hasCoordinates`
  - Validación de coordenadas
  - Eventos Livewire: `map-coordinates-updated`, `fly-to-coordinates`
- Vista Blade con Alpine.js (205 líneas)
  - Integración completa con Leaflet.js
  - Modo interactivo/solo lectura
  - Renderizado single/multi marker
  - Eventos JS bidireccionales
- Archivo de configuración `config/livewire-maps.php`
  - Coordenadas por defecto configurables
  - Configuración tile layer (OpenStreetMap)
  - Comportamiento por defecto de componentes
- README completo (525 líneas)
  - Guía de instalación y configuración
  - Ejemplos de uso: básico, avanzado, formularios
  - API completa documentada
  - Eventos y personalización
- Tests unitarios completos (13 tests, 265 líneas)
  - Mount con diferentes modos
  - Gestión de colecciones
  - Validación de inputs
  - Emisión de eventos

#### Geometries (`map-geometries`) - ✅ COMPLETO

**Added**:

- Interfaces base:
  - `GeometryInterface` - Contrato para geometrías
  - `HasCoordinates` - Contrato para coordenadas
  - `Renderable` - Contrato para renderizado
- Clase `Marker` (227 líneas)
  - Implementa `Wireable` para serialización Livewire
  - API fluent: `label()`, `tooltip()`, `icon()`, `iconColor()`, `options()`, `metadata()`
  - Métodos: `toArray()`, `toJson()`, `render()`, `toLivewire()`, `fromLivewire()`
  - Tests completos (19 tests, 156 líneas)
- Clase `MarkerCollection` (227 líneas)
  - Implementa `Countable`, `Iterator`, `ArrayAccess`, `Wireable`
  - Métodos: `add()`, `get()`, `remove()`, `clear()`, `all()`, `isEmpty()`
  - Métodos: `toArray()`, `toJson()`, `render()`
  - Tests completos (17 tests, 227 líneas)

#### Fields (`filament-maps-fields`) - ✅ COMPLETO

**Added**:

- `FilamentMapsFieldsServiceProvider` con auto-discovery
- Estructura de directorios: `Forms/Components`, `Infolists/Entries`
- Componente `MapField` para Forms
  - Modo JSON (recomendado): guarda coordenadas como `{latitude: X, longitude: Y}`
  - Modo legacy: campos separados para compatibilidad
  - Validación integrada con Filament
  - Soporte para notación de punto (dot notation)
  - Integración con `LivewireMap` del Core
  - Click para seleccionar ubicación
  - Pegar coordenadas desde portapapeles
  - Modo solo lectura
- Componente `MapBoundsField` para Forms
  - Gestión de bounds del mapa (northEast, southWest)
  - Modos JSON y legacy
  - Validación completa
  - Integración con LivewireMap
- Componente `MapEntry` para Infolists
  - Visualización de ubicaciones en infolists
  - Modo solo lectura
  - Soporte para modos JSON y legacy
- Componente `MapBoundsEntry` para Infolists
  - Visualización de bounds en infolists
  - Modo solo lectura
- Tests completos (11 archivos de tests)
  - `MapFieldTest.php` - Tests básicos del campo
  - `MapFieldJsonModeTest.php` - Tests modo JSON
  - `MapFieldJsonNotationTest.php` - Tests notación de punto
  - `MapFieldRequiredValidationTest.php` - Tests validación required
  - `MapFieldBackwardCompatibilityTest.php` - Tests compatibilidad
  - `MapBoundsFieldTest.php` - Tests básicos bounds
  - `MapBoundsFieldJsonModeTest.php` - Tests modo JSON bounds
  - `MapBoundsFieldJsonNotationTest.php` - Tests notación punto bounds
  - `MapBoundsFieldRequiredValidationTest.php` - Tests validación bounds
  - `MapEntryTest.php` - Tests entry de mapa
  - `MapBoundsEntryTest.php` - Tests entry de bounds
- README completo (683 líneas)
  - Instalación y configuración
  - Ejemplos de uso (Forms e Infolists)
  - API completa documentada
  - Guía de migración y troubleshooting
- Archivos adicionales de documentación
  - `EXAMPLES.md` - Ejemplos de uso
  - `TROUBLESHOOTING.md` - Solución de problemas

#### Widgets (`filament-maps-widgets`) - 🚧 FASE 1 COMPLETA

**Added**:

- Repositorio inicializado
- `FilamentMapsWidgetsServiceProvider` con auto-discovery
  - Usa `spatie/laravel-package-tools` para configuración simplificada
  - Carga vistas automáticamente
  - Publica configuración
  - Preparado para assets futuros
- Archivo de configuración `config/filament-maps-widgets.php`
  - Centro del mapa por defecto (configurable vía env)
  - Zoom por defecto
  - Altura de widgets
  - Opciones del mapa (Leaflet): scrollWheelZoom, dragging, etc.
  - Posición de acciones
- Estructura de directorios preparada
  - `src/Widgets/` (para Fase 2)
  - `src/Actions/` (para Fase 3)
  - `src/Contracts/` (para Fase 2)
  - `src/Concerns/` (para Fase 2)
  - `resources/views/` (para Fase 2)
- `tests/TestCase.php` configurado
  - Hereda de `Orchestra\Testbench\TestCase`
  - Carga todos los ServiceProviders necesarios (Livewire, Filament, Core, Widgets)
  - Configura entorno de testing
- `composer.json` actualizado
  - Metadata completa (keywords, homepage, license, authors)
  - Scripts útiles: `test`, `test-coverage`
  - Dependencias de desarrollo (PHPUnit, Orchestra Testbench)
  - Repositorios locales para desarrollo
- `phpunit.xml` configurado
  - PHPUnit 10+ compatible
  - Coverage reports
  - Variables de entorno para testing
- `.gitignore` configurado
- README inicial con ejemplos básicos
- Documentación de planificación
  - `packages/widgets/docs/FASE_1_COMPLETADA.md` - Resumen Fase 1
  - `packages/widgets/docs/MIGRACION_PAQUETE_WIDGETS.md` - Plan de migración completo

---

## Formato

Este changelog sigue [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).

### Tipos de cambios

- **Added** - Nuevas funcionalidades
- **Changed** - Cambios en funcionalidades existentes
- **Deprecated** - Funcionalidades obsoletas (próximas a eliminar)
- **Removed** - Funcionalidades eliminadas
- **Fixed** - Corrección de bugs
- **Security** - Vulnerabilidades corregidas
