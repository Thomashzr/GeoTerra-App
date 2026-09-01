# Etapa 4: Monetización y Release

## Skills Requeridas

- `[Skill: Flutter-Architecture-Riverpod]` -> Servicios, providers y flujo de reactivación.
- `[Skill: Android-Release-Compliance]` -> AdMob, ProGuard, firma y privacidad.
- `[Skill: Git-Ops-Autopilot]` -> Commit, tag y publicación de la versión.

## Tareas

- [x] Implementar `IAdService` y `AdMobService` con anuncios recompensados, intersticiales cada 3 partidas y banners precargables.
- [x] Integrar `ReviveModal` con Riverpod para continuar la partida con una vida tras completar un anuncio recompensado.
- [x] Inicializar Google Mobile Ads antes de `runApp` y registrar el servicio mediante provider.
- [x] Configurar Android para Advertising ID, App ID de AdMob, ProGuard y firma release mediante `key.properties`.
- [x] Añadir la política de privacidad y solicitar consentimiento UMP antes de cargar anuncios.
- [x] Validar con `flutter analyze` y `flutter test`; intentar el APK local y documentar cualquier bloqueo del SDK externo.
