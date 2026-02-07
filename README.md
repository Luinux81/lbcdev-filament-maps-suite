# 🗺️ LBCDev Filament Maps Suite

> Complete maps solution for FilamentPHP - A professional, modular package suite for working with maps in Filament applications.

[![PHP Version](https://img.shields.io/badge/PHP-8.1%2B-blue)](https://php.net)
[![Laravel](https://img.shields.io/badge/Laravel-10%20%7C%2011%20%7C%2012-red)](https://laravel.com)
[![Filament](https://img.shields.io/badge/Filament-v3%20%7C%20v4-orange)](https://filamentphp.com)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## 📦 Packages

This is a **monorepo** that contains multiple packages:

| Package | Description | Status |
|---------|-------------|--------|
| **[livewire-maps-core](packages/core)** | Base Livewire component for maps | 🚧 In Development |
| **[map-geometries](packages/geometries)** | Geometry classes (Markers, Polylines, etc.) | 🚧 In Development |
| **[filament-maps-fields](packages/fields)** | Form fields and Infolist entries | 🚧 In Development |
| **[filament-maps-widgets](packages/widgets)** | Dashboard widgets | 📋 Planned |

## 🚀 Quick Start

### For Development (This Monorepo)

```bash
# Clone with submodules
git clone --recursive https://github.com/Luinux81/lbcdev-filament-maps-suite.git

# Or if already cloned
git submodule update --init --recursive

# Open in VS Code with DevContainer
code lbcdev-filament-maps-suite.code-workspace
# Command Palette → "Dev Containers: Reopen in Container"
```

### For End Users

```bash
# Install the complete suite (when stable)
composer require lbcdev/filament-maps-suite

# Or install individual packages
composer require lbcdev/filament-maps-fields
composer require lbcdev/filament-maps-widgets
```

## 🏗️ Project Structure

```
lbcdev-filament-maps-suite/
├── .devcontainer/          # DevContainer configuration
├── docs/                   # Documentation (VitePress)
├── examples/               # Example Laravel applications
├── packages/               # Individual packages (git submodules)
│   ├── core/              # Livewire base component
│   ├── geometries/        # Geometry classes
│   ├── fields/            # Filament form fields
│   └── widgets/           # Filament widgets
├── tests/                  # Integration tests
└── composer.json           # Meta-package definition
```

## 🛠️ Development

### Prerequisites

- Docker + Docker Compose
- VS Code with Remote Containers extension
- Git

### Setup

1. **Open in DevContainer**:
   - Open this folder in VS Code
   - Command Palette: "Dev Containers: Reopen in Container"
   - Wait for the container to build and initialize

2. **Install Dependencies**:
   ```bash
   # Monorepo dependencies
   composer install

   # Individual packages
   cd packages/core && composer install
   cd ../geometries && composer install
   cd ../fields && composer install
   ```

3. **Run Tests**:
   ```bash
   # Test all packages
   composer test:packages

   # Test specific package
   cd packages/core && composer test
   ```

### Working with Submodules

```bash
# Update all submodules to latest
git submodule update --remote --merge

# Work in a specific package
cd packages/core
git checkout -b feature/my-feature
# ... make changes ...
git commit -m "feat: add my feature"
git push origin feature/my-feature

# Update monorepo reference
cd ../..
git add packages/core
git commit -m "chore: update core to feature branch"
```

## 📚 Documentation

- [Architecture Overview](docs/architecture.md)
- [Contributing Guide](CONTRIBUTING.md)
- [API Reference](docs/api/)

## 🧪 Testing

```bash
# Run all tests
composer test

# Run tests for all packages
composer test:packages

# Run specific package tests
cd packages/core && composer test
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📋 Roadmap

### Phase 1: Core Infrastructure (Current)
- [x] Setup monorepo structure
- [x] Configure DevContainer
- [ ] Refactor core Livewire component
- [ ] Create geometry classes
- [ ] Update fields package

### Phase 2: Essential Features
- [ ] Multi-marker support
- [ ] Action system
- [ ] Dashboard widgets
- [ ] Marker clustering

### Phase 3: Advanced Geometries
- [ ] Polylines
- [ ] Polygons
- [ ] Circles
- [ ] Custom shapes

### Phase 4: Advanced Features
- [ ] Geocoding integration
- [ ] Custom tile providers
- [ ] Distance measurement
- [ ] Heatmaps

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- Built with [Leaflet.js](https://leafletjs.com/)
- Powered by [Filament](https://filamentphp.com/)
- Inspired by [webbingbrasil/filament-maps](https://github.com/webbingbrasil/filament-maps)

## 👨‍💻 Author

**Luinux81**

- GitHub: [@Luinux81](https://github.com/Luinux81)

---

**Status**: 🚧 In Active Development

This project is currently in early development. APIs may change. Not recommended for production use yet.