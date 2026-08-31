# Etapa 1: Dataset, SQLite y Drift

## Skills Requeridas

- `[Skill: hcom-bridge / AGY Delegator]` -> Obtener dataset y SVGs.
- `[Skill: Drift-SQLite-Engineer]` -> Modelar esquemas y DAOs.
- `[Skill: Git-Ops-Autopilot]` -> Committear al finalizar.

## Tareas

- [x] Delegar a AGY vía hcom la creación del dataset SQLite (`assets/data/countries.db`) con 195 países (ISO2, capital, continente, dificultad).
- [x] Delegar a AGY la descarga y organización de los SVGs de banderas en `assets/flags/`.
- [x] Crear la tabla `Countries` en Drift (`lib/core/database/tables/countries_table.dart`).
- [x] Implementar `CountryDao` con el método para extraer 1 respuesta y 3 distractores del mismo continente.
- [x] Ejecutar `dart run build_runner build` y verificar que no haya errores.
