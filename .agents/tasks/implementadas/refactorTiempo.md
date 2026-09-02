# 🔄 Refactor: juego sin cuenta regresiva y avance automático

## 1. Objetivo

Eliminar la presión de tiempo durante la partida. El jugador podrá responder sin
cuenta regresiva y, al acertar, la siguiente pregunta se cargará automáticamente
sin depender de un botón ubicado al final del scroll.

## 2. Restricciones e invariantes

- No modificar la API pública de `CountryRepository` ni el contrato de
  `getNextQuestion({required int difficulty})`.
- Mantener vidas, racha, game over, revive y protección contra respuestas dobles.
- Mantener la puntuación equivalente a una respuesta con el tiempo completo:
  `150 puntos × multiplicador de racha`.
- Una respuesta incorrecta consume una vida y conserva el flujo explícito para
  continuar, de modo que el jugador pueda ver la respuesta correcta.
- Una respuesta correcta avanza automáticamente tras una pausa breve de feedback.
- No añadir dependencias.
- Conservar Riverpod 2.x y la arquitectura feature-first actual.

## 3. Tareas atómicas y responsables

### T1 — Contratos e invariantes (AGY vía hcom, solo auditoría)

- [x] Revisar el cambio contra `.agents/shared_contracts.md`.
- [x] Confirmar que repositorio, datos y esquema Drift no necesitan cambios.
- [x] Revisar riesgos para puntuación, concurrencia, revive y game over.
- [x] Entregar recomendaciones al orquestador; no editar presentación.

### T2 — Motor y estado del quiz (subagente Terra)

- [x] Eliminar la cuenta regresiva de `QuizNotifier` y su estado asociado.
- [x] Sustituir la puntuación dependiente del tiempo por la base fija equivalente.
- [x] Implementar avance automático seguro después de una respuesta correcta.
- [x] Evitar cargas duplicadas y callbacks posteriores a `dispose`.
- [x] Mantener el avance manual después de una respuesta incorrecta o revive.

Archivos asignados:

- `lib/features/quiz/presentation/controllers/quiz_controller.dart`
- `lib/features/quiz/domain/models/quiz_state.dart`
- `lib/features/quiz/domain/models/quiz_state.freezed.dart`

### T3 — Presentación sin temporizador (subagente Terra)

- [x] Quitar contador, barra de progreso y semántica de tiempo de `QuizTopBar`.
- [x] Eliminar sonidos de tick y props de tiempo desde `QuizScreen`.
- [x] Mostrar el botón “Siguiente pregunta” solo después de una respuesta
  incorrecta; nunca tras una respuesta correcta.
- [x] Mantener vidas y puntuación reactivas y accesibles.

Archivos asignados:

- `lib/features/quiz/presentation/screens/quiz_screen.dart`
- `lib/features/quiz/presentation/widgets/quiz_top_bar.dart`

### T4 — Cobertura de regresión (subagente Luna)

- [x] Reemplazar pruebas de timeout/cuenta regresiva por pruebas de ausencia de
  penalización temporal.
- [x] Probar avance automático solo al acertar.
- [x] Probar que una respuesta incorrecta no avanza automáticamente.
- [x] Confirmar puntuación fija, multiplicador, vidas, revive y doble submit.
- [x] Evaluar cobertura de widget para ausencia del timer y del botón tras acertar,
  solo si puede hacerse sin tocar archivos de producción.

Archivos asignados:

- `test/features/quiz/quiz_controller_test.dart`
- `test/features/quiz/quiz_screen_test.dart` (nuevo, si aporta valor)

## 4. Orden de integración

1. Recibir auditoría de AGY.
2. Integrar T2 y T3 de Terra.
3. Integrar/adaptar T4 de Luna al contrato final.
4. Ejecutar generación de Freezed si corresponde.
5. Ejecutar `dart format`, `flutter analyze` y `flutter test`.
6. Marcar esta tarea completa y moverla a `.agents/tasks/implementadas/`.

## 5. Criterios de aceptación

- [x] No existe cuenta regresiva visible ni penalización por esperar.
- [x] La respuesta correcta suma `150 × multiplicador` y carga la siguiente
  pregunta automáticamente una sola vez.
- [x] La respuesta incorrecta descuenta una sola vida y permite revisar feedback.
- [x] Game over y revive mantienen su comportamiento actual.
- [x] No cambió `CountryRepository` ni el esquema de datos.
- [x] `flutter analyze` finaliza sin issues.
- [x] `flutter test` pasa al 100 %.

## 6. Git-Ops

- Commit sugerido: `refactor(quiz): remove countdown and auto-advance answers`
