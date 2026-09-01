
```markdown
# ✨ [FEAT]: Pantalla de inicio

## 1. Descripción y Requerimientos de Negocio
- **Objetivo:** Crear una pantalla de inicio antes de la pantalla de juego.
- **Criterios de Aceptación:**
  - 1. Al abrir la aplicación se muestra el menú de inicio.
  - 2. El menú permite acceder a Jugar y Ajustes; Reto diario permanece visible pero deshabilitado.
  

## 2. Asignación de Tareas por Agente
- **[AGY vía hcom]** (Datos y Assets):
  - Tarea: Revisar assets y contratos existentes; no se requieren cambios de datos para esta feature.
- **[LUNA]** (Lógica de Dominio y Estado):
  - Tarea: Implementar HomeScreen y el placeholder de Ajustes sin acoplarlo al motor del quiz.
- **[TERRA]** (UI, Microinteracciones y Rutas):
  - Tarea: Configurar GoRouter para iniciar en `/`, conservar `/quiz` y añadir `/settings`.

## 3. Checklist de Integración (Codex)
- [x] Despachar tareas concurrentes a AGY, Luna y Terra.
- [x] Verificar que no hubo cambios en modelos/Drift; no fue necesario ejecutar build_runner.
- [x] Conectar dependencias y validar `flutter analyze`.
- [x] Ejecutar tests de unidad y widget: 17 tests aprobados.

## 4. Git-Ops
- **Commit:** `feat(home): implement start screen`
