# Auditoría de arquitectura Flutter

## Objetivo

Aplicar la skill `flutter-apply-architecture-best-practices` al código actual sin reemplazar Riverpod 2.x, preservando la arquitectura feature-first del proyecto.

## Hallazgos corregidos

- [x] El dominio de quiz dependía de la fila `Country` generada por Drift.
- [x] `QuizScreen` construía infraestructura, repositorios y servicios dentro del archivo de presentación.
- [x] `main.dart` inicializaba Google Mobile Ads fuera de `AdMobService` y antes del flujo de consentimiento UMP.
- [x] `HomeScreen` conocía paths de GoRouter en lugar de recibir callbacks de navegación.

## Integración y QA

- [x] Crear una entidad `Country` pura e inmutable y mapear Drift → dominio en el repositorio.
- [x] Mover los providers de infraestructura a `lib/app/providers.dart`.
- [x] Mantener la inicialización de anuncios encapsulada y consent-gated en `AdMobService`.
- [x] Añadir tests de navegación, composition root y límites de la capa de dominio.
- [x] Ejecutar `dart run build_runner build`.
- [x] Validar `flutter analyze` sin issues.
- [x] Validar la suite completa: 20 tests aprobados.
