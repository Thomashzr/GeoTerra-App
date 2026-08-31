# Política de Privacidad / Privacy Policy

*Última actualización: [FECHA_DE_ACTUALIZACION - ej. 31 de Agosto de 2026]*

Esta Política de Privacidad describe cómo **[NOMBRE_DEL_DESARROLLADOR_O_EMPRESA]** ("nosotros", "nuestro") recopila, utiliza y protege la información cuando utilizas la aplicación móvil **GeoQuiz** (la "Aplicación").

---

## 1. Resumen de Privacidad y Arquitectura Offline-First

**GeoQuiz** está diseñada con una arquitectura centrada en la privacidad del usuario:
- **No recopilamos ni almacenamos datos personales directamente:** La aplicación no requiere registro de cuenta, correo electrónico, nombre, número de teléfono ni acceso a contactos, ubicación GPS o cámara.
- **Base de datos local:** Todo el progreso del juego, historial de puntuaciones y catálogo de países se procesa y almacena localmente en tu dispositivo.

---

## 2. Servicios de Terceros y Publicidad (Google AdMob)

Para mantener la aplicación gratuita, integramos servicios publicitarios proporcionados por **Google Mobile Ads (AdMob)** y **Google Play Services**.

### 2.1 Datos Recopilados Automáticamente por Terceros
Al interactuar con la aplicación, los SDKs de Google pueden recopilar y procesar de forma automatizada:
- **Identificador de Publicidad (Advertising ID / Google Advertising ID `AD_ID`):** Utilizado para servir anuncios relevantes, limitar la frecuencia de visualización y combatir el fraude publicitario.
- **Información del Dispositivo y Diagnóstico:** Modelo de hardware, versión del sistema operativo, resolución de pantalla, dirección IP (utilizada para inferir ubicación a nivel general/país) y registros de rendimiento o fallos (crash logs).

### 2.2 Enlaces a Políticas de Privacidad de Terceros
- **Google Play Services:** [https://policies.google.com/privacy](https://policies.google.com/privacy)
- **Google AdMob:** [https://support.google.com/admob/answer/6128543](https://support.google.com/admob/answer/6128543)
- **Tecnologías y Publicidad de Google:** [https://policies.google.com/technologies/ads](https://policies.google.com/technologies/ads)

---

## 3. Control del Usuario y Opciones de Anuncios

Tienes el control total sobre el uso de tu identificador publicitario:
- **En Android (versiones 12 o superiores):** Ve a `Ajustes` -> `Privacidad` -> `Anuncios` y selecciona *Eliminar ID de publicidad* o *Restablecer ID de publicidad*.
- **En Android (versiones anteriores):** Ve a `Ajustes` -> `Google` -> `Anuncios` y activa la opción *Inhabilitar personalización de anuncios*.

---

## 4. Privacidad Infantil y Audiencia Objetivo

GeoQuiz no solicita la edad del usuario ni recopila a sabiendas información personal directamente de niños. Antes de publicar, el desarrollador debe declarar con precisión la audiencia objetivo en Google Play Console y configurar Google Mobile Ads para el tratamiento correspondiente a menores cuando resulte aplicable. Esta plantilla no debe utilizarse para afirmar cumplimiento con COPPA, GDPR-K o las políticas de Familias sin completar esa configuración y una revisión legal apropiada.

---

## 5. Derechos de los Usuarios (GDPR / CCPA / LGPD)

Si resides en el Espacio Económico Europeo (EEE), California (EE. UU.), Brasil u otras regiones con leyes de protección de datos:
- Tienes derecho a acceder, rectificar o solicitar la limitación del tratamiento de tus datos procesados por los proveedores de publicidad.
- Para ejercer estos derechos o revocar el consentimiento de anuncios personalizados, puedes utilizar los controles de tu sistema operativo o ponerte en contacto con nosotros.

---

## 6. Cambios a esta Política de Privacidad

Podemos actualizar nuestra Política de Privacidad periódicamente. Te recomendamos revisar esta página regularmente para comprobar cualquier cambio. Las modificaciones entrarán en vigor inmediatamente después de su publicación.

---

## 7. Información de Contacto

Si tienes preguntas, dudas o sugerencias sobre esta Política de Privacidad, puedes ponerte en contacto con nosotros en:

- **Desarrollador / Organización:** `[NOMBRE_DEL_DESARROLLADOR_O_EMPRESA]`
- **Correo Electrónico de Soporte:** `[CORREO_ELECTRONICO_DE_SOPORTE - ej. soporte@tudominio.com]`
- **Sitio Web / Repositorio:** `[URL_DEL_SITIO_O_REPOSITORIO]`

---

> ### 📝 Instrucciones para el Desarrollador antes de Publicar en Google Play:
> 1. Reemplaza todos los textos entre corchetes `[PLACEHOLDER]` con tus datos reales de contacto.
> 2. Aloja este archivo en una URL pública accesible (por ejemplo, GitHub Pages, Notion público o tu sitio web oficial).
> 3. Pega el enlace resultante en el campo **Política de Privacidad** dentro de Google Play Console (sección *Contenido de la aplicación*).
> 4. Configura un mensaje de regulaciones europeas en AdMob Privacy & Messaging. La app consulta UMP antes de solicitar anuncios, pero el mensaje y sus proveedores deben configurarse en la consola.
> 5. Declara Advertising ID, datos compartidos/recopilados por AdMob y la audiencia objetivo en las secciones correspondientes de Google Play Console.
> 6. Reemplaza el App ID y los ad unit IDs de prueba mediante `ADMOB_APP_ID` y los `--dart-define` documentados antes de un build de producción.
