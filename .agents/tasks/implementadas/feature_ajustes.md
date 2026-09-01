Markdown

# [FEAT]: Pantalla de ajustes

## 1. Descripción y Requerimientos de Negocio

- **Objetivo:** Crear una pantalla de ajustes para el botón Ajustes del inicio.
- **Criterios de Aceptación:**
  - [x] Al abrir el menú de ajustes se puede bajar o desactivar el volumen.
  - [x] Al abrir el menú de ajustes se puede elegir idioma (por ahora solo español).
  - [x] Al abrir el menú de ajustes se puede cambiar entre modo sistema, claro u oscuro.
  

## 2. Asignación de Tareas por Agente

- **[AGY vía hcom]** (Datos y Assets):
  - [x] Persistencia local con Hive, DTO, datasource y repositorio tolerante a datos corruptos.
- **[LUNA]** (Lógica de Dominio y Estado):
  - [x] Modelos Freezed, StateNotifier de Riverpod y tests de lógica/widget.
- **[TERRA]** (UI, Microinteracciones y Rutas):
  - [x] UI de ajustes, sistema visual atlas compartido y unificación Home/Quiz.

## 3. Checklist de Integración (Codex)

- [x] Despachar tareas concurrentes a AGY, Luna y Terra.
- [x] Ejecutar `dart run build_runner build --delete-conflicting-outputs` por los modelos Freezed.
- [x] Conectar dependencias y validar `flutter analyze` sin issues.
- [x] Ejecutar tests de unidad y widget (42 tests).

## 4. Git-Ops

- **Commit:** `feat(settings): add persistent preferences and atlas UI`
