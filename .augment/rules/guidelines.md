---
type: "always_apply"
---

# Guidelines de Interacción y Desarrollo

## Principios Generales de Comportamiento
- **Verbocidad Mínima:** Respuestas extremadamente concisas. Ve al grano.
- **Sin creación automática:** No crear scripts, documentación, tests ni diagramas a menos que el usuario lo pida explícitamente.
- **Confirmación Obligatoria:** Si consideras que un archivo nuevo sería beneficioso, pregunta antes de actuar.
- **Control de Decisiones:** No asumas soluciones (ej. cambiar un ServiceProvider vs cambiar un Namespace). Ante una ambigüedad o error detectado, reporta y pregunta la dirección a tomar.

## Protocolo de Ejecución Paso a Paso (Obligatorio)
Cuando una petición implique un plan de varias acciones, detente tras cada fase siguiendo este flujo:

1. **Presentación del Plan:** Explicación muy breve del plan completo (una frase por acción). Preguntar: "¿Proceder con el paso 1?".
2. **Ejecución y Testeo:**
   - Ejecutar el paso actual.
   - Pedir confirmación para crear tests específicos para este paso.
   - Pedir confirmación para ejecutar los tests. Explicar brevemente la salida esperada.
3. **Validación:** Si los tests pasan, pedir confirmación explícita para pasar al siguiente paso.
4. **Continuación:** Explicar el siguiente paso (máximo 1-2 párrafos) y repetir el ciclo de ejecución/test/confirmación. El test debe cubrir el paso actual y asegurar que no hay regresiones en los anteriores.

## Gestión de Documentación del Proyecto (Directorio /docs)
- **Contexto:** Mantener siempre en contexto los archivos de `/docs`.
- **Índice Central:** `/docs/00-ESTADO_ACTUAL.md` es el resumen ejecutivo e índice. Solo se actualiza si hay nuevos repositorios, paquetes o archivos de documentación.
- **Flujo de Trabajo:** `/docs/01-ARQUITECTURA_PROPUESTA.md` y `/docs/03-CHECKLIST_PROGRESO.md` son trabajos en curso.
  - No asumas que todo lo que hay en ellos es válido; pide confirmación sobre la información extraída.
  - Actualiza el Checklist al completar tareas (Completados), decidir futuras funciones (Por hacer) o iniciar una tarea (En progreso).
- **Regla de Oro de Docs:** Siempre pedir confirmación detallando qué se va a añadir, cambiar o eliminar antes de modificar cualquier archivo en `/docs`.