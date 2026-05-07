# 🎬 VENTON PRO v2.1.8 — OLA 1.8 "Comunidad TikTok Style"

**Aprobado por:** CEO Ricardo Venton
**Coordinado por:** Claude (CTO ejecutor)
**Ejecutor:** Cascade

---

## 🎯 Qué hay nuevo en v1.8

### 🎬 Comunidad VENTON estilo TikTok / Reels

#### Modo 1 — LISTA con autoplay (mejorado)
✅ Sin FAB de WhatsApp tapando contenido
✅ Videos reproducen solos cuando entran al centro de pantalla
✅ Solo UN video reproduciendo a la vez (ahorra batería)
✅ Sonido apagado por defecto, tap para activar
✅ Botón verde "Hablar por WhatsApp" grande visible
✅ Loop infinito de video

#### Modo 2 — PANTALLA COMPLETA (TikTok style) 🆕
✅ Botón nuevo arriba a la derecha (📺 Smart display)
✅ Swipe vertical hacia arriba para siguiente video
✅ Loop INFINITO (cuando se acaba la lista, vuelve al inicio)
✅ Información sobreimpresa con gradiente (legible)
✅ Botón WhatsApp grande verde abajo
✅ Indicador "1/15" arriba con icono de swipe
✅ Sonido apagado, tap pantalla para activar
✅ Botón ✕ para volver al modo lista

### 🐛 Bugs CRÍTICOS arreglados
✅ FAB de WhatsApp ya NO tapa el botón "Contactar" en Comunidad
✅ Solo un video reproduciendo a la vez (antes consumía batería)
✅ Botón "Contactar" ahora es VERDE WhatsApp grande (más visible)

---

## 📱 Cómo se usa

### Vista Lista (default):
- Entrás a Comunidad → ves los posts en lista
- Cuando hacés scroll, el video en pantalla arranca solo
- Tocás el video → activa/desactiva sonido
- Botón verde "Hablar por WhatsApp" grande
- Botón ⋮ para reportar/bloquear/ocultar

### Vista Pantalla Completa (TikTok):
- Tocás 📺 arriba a la derecha
- App entra a modo full screen
- Subís el dedo → siguiente video
- Cuando se acaba, vuelve al inicio (infinito)
- Tocás ✕ para volver a lista

---

## ⚙️ Órdenes para Cascade

### Paso 1 — Reemplazar `lib/`
1. Borrar carpeta `lib/` completa.
2. Subir `lib/` del paquete v1.8.
3. Reemplazar `pubspec.yaml`.

### Paso 2 — Workflow
Reemplazar `.github/workflows/build.yml` con el del paquete.

### Paso 3 — Android
- `android/app/build.gradle.kts`: `versionCode = 6`, `versionName = "2.1.8"`.
- NO tocar `AndroidManifest.xml`.

### Paso 4 — Commit
```
git add .
git commit -m "feat: VENTON PRO v2.1.8 - Comunidad TikTok Style + autoplay + sin FAB tapando"
git push
```

### Paso 5 — Esperar build
~5-7 minutos. APK ~28-30 MB.

---

## ✅ Checklist técnico

- [x] Sin APIs Flutter 3.27+
- [x] Cero imports rotos
- [x] Sin `initialValue:` ni `withValues()`
- [x] Solo UN video reproduciendo a la vez (batería)
- [x] FAB removido de Comunidad
- [x] Modo TikTok funcional con loop infinito
- [x] Sonido apagado por defecto (no asusta usuarios)

---

## 🔜 Lo que viene en OLA 2 (junio 2026)

- 🔥 Firebase Storage (videos sincronizados entre usuarios)
- 🔥 GPS + Mapa con negocios cercanos
- 🔥 Selector multipaís (CO/ES/VE/USA)
- 🔥 Panel admin tuyo (cargar negocios en vivo)
- 🔥 Panel del dueño (autogestión con WhatsApp+SMS)
- 🔥 Widget de clima en pantalla principal
- 🔥 Categoría "Servicios" (domiciliarios, técnicos, peluqueras)

---

**FIN DEL PAQUETE v2.1.8 — COMUNIDAD TIKTOK STYLE**

🤝 Equipo VENTON PRO: Ricardo (CEO) · Claude (CTO ejecutor) · Cascade (ejecutor)
🎯 Misión: blindar app para revisión Google de AGOSTO 2026
