# 💎 VENTON PRO v2.1.6 — OLA 1.6 "Pulido Pro"

**Aprobado por:** CEO Ricardo Venton
**Coordinado por:** Claude (CTO ejecutor)
**Ejecutor:** Cascade

---

## 🎯 Qué hay nuevo respecto a v2.1.5

### 🔴 Críticos arreglados
✅ FAB de WhatsApp ya NO tapa precios ni contenido (eliminado de pantallas internas)
✅ Banner principal sin texto cortado
✅ Header de Inicio reducido a 110px (antes 180px) — más espacio para contenido
✅ Acceso rápido "Contacto" en azul marino (antes verde, se confundía con FAB)

### 🟢 Funcionalidades nuevas
✅ **Pantalla de detalle de producto** (foto grande, descripción larga, precio antes/después, descuento, info de envío)
✅ **Pantalla de detalle de experiencia turística** (qué incluye, duración, ubicación)
✅ **Buscador global** (productos + turismo) con sugerencias y resultados en vivo
✅ **Sistema de favoritos** (corazoncito, pantalla "Mis favoritos")
✅ **Sección "Ofertas del momento"** con productos en descuento (carrusel con badge -%)
✅ **Más productos mock** (6 químicos, 4 cafés, 5 turismos)
✅ **Vendedores con WhatsApp propio** — cada vendedor con su número, biografía y botón directo
✅ **Botón "Pedir" visible en cada producto** (verde WhatsApp en card)
✅ **Descuentos visibles** con precio anterior tachado y badge -%

---

## ⚙️ Órdenes EXACTAS para Cascade

### Paso 1 — Reemplazar `lib/` completa
1. Borrar la carpeta `lib/` completa del repo.
2. Subir la carpeta `lib/` del paquete v1.6.
3. Reemplazar `pubspec.yaml`.

### Paso 2 — Reemplazar workflow
Reemplazar `.github/workflows/build.yml` con el del paquete (sigue compilando RELEASE).

### Paso 3 — Verificar Android (sin cambios respecto a v1.5)
- `android/app/src/main/AndroidManifest.xml` ya tiene los permisos de cámara (no tocar si ya está configurado).
- `android/app/build.gradle.kts` debe tener `versionCode = 4` y `versionName = "2.1.6"`. Ver snippet en `android_config/`.

### Paso 4 — Commit + Push
```
git add .
git commit -m "feat: VENTON PRO v2.1.6 - Detalle producto, búsqueda, favoritos, ofertas, fixes UX"
git push
```

### Paso 5 — Esperar build
GitHub Actions compila release. ~5-7 minutos. APK final ~28 MB.

---

## ✅ Checklist final

- [x] Sin APIs Flutter 3.27+ (auditado)
- [x] Cero imports rotos (auditado)
- [x] Sin `initialValue:` en Dropdowns (auditado)
- [x] FAB de WhatsApp removido de pantallas internas
- [x] Header de Inicio compacto
- [x] Banners con texto sin cortar
- [x] Pantalla detalle producto + experiencia
- [x] Buscador funcional
- [x] Favoritos persistentes
- [x] Ofertas con descuentos visibles
- [x] Vendedores con WhatsApp propio

---

## 🔜 Lo que viene en OLA 2

- Firebase Firestore + Storage (videos comunidad)
- AdMob real
- Login con email/Google
- Push notifications

**FIN DEL PAQUETE v2.1.6 — PULIDO PRO**

🤝 Equipo VENTON PRO: Ricardo (CEO) · Claude (CTO ejecutor) · Cascade (ejecutor)
