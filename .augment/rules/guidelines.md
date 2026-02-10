---
type: "always_apply"
---

# Generales

- No crear archivos de script si no se piden explícitamente por el usuario.
- No crear archivos de documentación si no se piden explicitamente.
- No crear archivos de test si no se piden explicitamente.
- No crear diagramas si no se piden explicitamente.
- En caso que consideres que crear un archivo de script, documentación o tests sería importante, beneficioso o interesante para el usuario , siempre pedir confirmación al usuario primero antes de crearlos.
- Quiero que tus respuestas tengan de poca a minima verbosidad.
- Cuando se realice un plan de acciones para resolver una petición del usuario, y este plan implica varias acciones, la forma de trabajar es la siguiente (el usuario se refiere a esto cuando dice "paso a paso" o "progresivamente" )
    - 1. Explicacion muy breve del plan, lista de acciones con una explicacion muy breve, si es posible con un sola frase, mejor. Se pregunta al usuario si proceder con el paso 1.
    - 2. Ejecutar el paso actual del plan y pide confirmación al usuario para crear tests del paso actual.
    - 3. Pide confirmación de nuevo para ejecutar los tests y se explica al usuario la salida esperada de los tests.  
    - 4. Si todo es correcto, pide confirmación al usuario para pasar al siguiente paso.
    - 5. Explica brevemente el paso actual, a ser posible 1 o 2 parrafos como máximo y repite el proceso anterior (explicar, pedir confirmacion, ejecutar paso, pedir confirmación para crear y de nuevo para ejecutar los test, que deben probar el paso actual y los anteriores pasos).
    - 6. Continuar repitiendo el mismo sistema para todos los pasos hasta completar el plan.

# Particulares de este proyecto

- Consulta y manten en tu contexto los archivos del directorio /docs
- El archivo /docs/00-ESTADO_ACTUAL.md contiene un resumen ejecutivo del estado actual del proyecto y hace las funciones de índice.
- Los archivos de arquitectura propuesta y checklist progreso son un work in progress, y deben ir siendo pulidos poco a poco.
- Los archivos del directorio /docs deben ser actualizados con los cambios realizados y deben mantenerse actualizados, pero siempre debes pedir confirmación primero explicando que vas a añadir, cambiar o eliminar.
- El archivo de estado actual se actualiza si hay nuevos repos, paquetes o archivos de documentacion
- El archivo de checklist progreso se actualiza cuando se cumple una nueva tarea (seccion completados), cuando se decide una funcionalidad que se implementará en el futuro (seccion por hacer o proximo paso) o cuando se decide trabajar en una funcionalidad (en progreso, proximo paso).
- Siempre pedir confirmacion para modificar cualquiera de los archivos de docs 00-ESTADO_ACTUAL.md, 01-ARQUITECTURA_PROPUESTA.md, 03-CHECKLIST_PROGRESO.md