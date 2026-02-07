#!/bin/bash

echo "🔄 Post-start commands..."

# Actualizar submodules (por si hay cambios remotos)
git submodule update --remote --merge

echo "✅ Container iniciado correctamente"