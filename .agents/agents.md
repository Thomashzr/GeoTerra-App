# Contexto del Proyecto: GeoQuiz App

Aplicación móvil de trivia geográfica (adivinar banderas, capitales, mapas y países) desarrollada en Flutter.
Diseñada con arquitectura offline-first, renderizado vectorial y monetización con Google AdMob.

## Tech Stack

- Framework: Flutter 3.x (Impeller habilitado)
- Gestión de Estado: flutter_riverpod + riverpod_annotation
- Base de Datos Local: drift (SQLite precompilado)
- Renderizado Gráfico: flutter_svg, flutter_animate, lottie
- Audio: audioplayers
- Monetización: google_mobile_ads

## Reglas de Arquitectura y Código (Estrictas)

1. Arquitectura Feature-First:
   - Todo código vive en `lib/features/<feature_name>/{data, domain, presentation}`.
   - Componentes transversales viven en `lib/core/`.
2. UI Pura:
   - No instanciar DAOs ni lógica de negocio dentro del método `build()` de los Widgets.
   - Todo estado temporal (timer, puntaje, vidas) debe residir en Providers de Riverpod.
3. Offline-First:
   - Los datos de países se leen de `assets/database/countries.db` precargado con Drift.
   - Cero dependencias de APIs HTTP externas durante el juego activo.
4. Servicios Desacoplados:
   - AdMob, Audio y Almacenamiento deben implementar interfaces abstractas (`IAdService`, `IAudioService`).

## Comandos de Verificación

- Generar código (Riverpod / Drift): `dart run build_runner build --delete-conflicting-outputs`
- Análisis estático: `flutter analyze`
- Tests unitarios: `flutter test`

# Directrices de Orquestación: Codex + hcom (AGY)

## 1. Rol de Codex

Eres el desarrollador líder del proyecto Flutter (GeoQuiz).
Tienes disponible la herramienta de CLI `hcom` para delegar tareas al agente `agy`.

## 2. Reglas de Delegación a AGY vía hcom

Delega a AGY mediante `hcom` cuando la tarea involucre:

1. **Curación y Procesamiento de Datos:**
   - Creación/descarga de datasets de países, capitales, continentes y mapas en JSON/SQLite.
   - Procesamiento o renombrado por lotes de assets SVG de banderas (códigos ISO 3166-1 alpha-2).
2. **Esquemas y Scripts Auxiliares:**
   - Generación de scripts en Python/Dart para sanitizar datos antes de meterlos a Drift.
   - Creación de archivos de políticas de privacidad o configuraciones extensas de Gradle/AdMob.

## 3. Formato de Invocación de hcom

Cuando necesites delegar, ejecuta el comando de hcom especificando inputs claros y la salida esperada:

```bash
hcom send --agent agy --task "DESCRIPCIÓN_CLARA_DE_LA_TAREA" --output-dir "RUTA_DESTINO"

## [Skill: Git-Ops-Autopilot]
Codex debe ejecutar commits automáticos siguiendo la convención de Conventional Commits cada vez que complete un hito o tarea atómica verificada.

### Reglas de Git:
1. **Verificación Previa Obligatoria:**
   Antes de committear, siempre ejecutar:
   - `flutter analyze` (debe pasar con 0 errores).
2. **Formato de Mensajes (Conventional Commits):**
   - `feat(scope): descripción` para nuevas funcionalidades.
   - `fix(scope): descripción` para correcciones.
   - `refactor(scope): descripción` para mejoras de código sin cambio de comportamiento.
   - `data(scope): descripción` para cambios en SQLite o assets de banderas.
3. **Flujo de Ejecución:**
   ```bash
   git add .
   git commit -m "feat(database): configure drift schema and country dao"
   git push origin main
