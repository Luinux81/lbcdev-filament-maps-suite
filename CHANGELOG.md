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

#### Fields (`filament-maps-fields`) - ⚠️ EN DESARROLLO

**Added**:

- `FilamentMapFieldsServiceProvider`
- Estructura de directorios: `Forms/Components`, `Infolists/Entries`

#### Widgets (`filament-maps-widgets`) - ⚠️ PENDIENTE

**Added**:

- Repositorio inicializado

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
