# 🎰 VENTON PRO v2.1.7 — OLA 1.7 "Ruleta Pro + Movimiento"

**Aprobado por:** CEO Ricardo Venton
**Coordinado por:** Claude (CTO ejecutor)
**Ejecutor:** Cascade

---

## 🎯 Qué hay nuevo en v1.7

### 🎰 Ruleta TOTALMENTE rediseñada
✅ **1 jugada cada 24 horas** por usuario (antes infinito → te quebraba)
✅ **Cuenta regresiva visible** cuando ya jugó (HH:MM:SS en tiempo real)
✅ **Pop-up automático** al abrir la app si puede jugar (no escondida en menú)
✅ **Card permanente en Inicio** mostrando estado de la ruleta
✅ **Contador GLOBAL** de jugadas compartido (preparado para Firebase)
✅ **Premios escalonados:**
   - Cada 100 jugadas → Champú Romero garantizado
   - Cada 250 jugadas → Producto mediano
   - Cada 500 jugadas → 🏆 **GRAN PREMIO: Combo Limpieza VENTON**
✅ **Probabilidades reales:**
   - 60% Sigue intentando
   - 25% Cupón descuento (5% o 10%)
   - 10% Champú Romero
   - 5% Producto mediano
✅ **Códigos únicos anti-captura** (formato VTN-XXXX-XXXX, una sola vez)
✅ **Reclamación por WhatsApp** con código que vos verificás

### 🎁 Champú de Romero VENTON (premio destacado)
✅ Producto VENTON propio agregado al catálogo de químicos
✅ 500 ml · A base de romero, quina y canela
✅ Sin sal, sin colorantes, 100% natural
✅ Aparece como banner rotativo en Inicio
✅ Premio principal de ruleta cada 100 jugadas

### 🎬 Movimiento permanente — App "viva"
✅ **Banner principal rotativo** auto-cambia cada 4 segundos (4 banners)
✅ **Indicadores de página** animados (-bronce-)
✅ **Carruseles auto-scroll** suave en Turismo destacado y Productos premium
✅ Loop infinito (cuando llega al final, vuelve al inicio sin saltos)

### 🏨 WhatsApp DIRECTO al dueño en experiencias turísticas
✅ Cada experiencia ahora tiene `whatsappDueno`, `nombreDueno`, `nombreNegocio`
✅ Botón "Hablar con [nombre del dueño]" abre WhatsApp con SU número
✅ Card de identidad del negocio en cada detalle
✅ Sello "Verificado por VENTON PRO" en cada listado
✅ Banner: "Hablás directamente con [Don Carlos] de [Hotel Termales del Otoño]"

### 🌎 Preparación multipaís
✅ Modelo `NegocioAnunciante` con campos `pais` y `plan` (Visible/Destacado/Top)
✅ Lista `mercados` actualizada: Colombia, España, Venezuela, USA
✅ Mock data ampliada con 3 negocios anunciantes preview (Hotel, Restaurante, Panadería)

---

## ⚙️ Órdenes EXACTAS para Cascade

### Paso 1 — Reemplazar `lib/` completa
1. Borrar carpeta `lib/` completa del repo.
2. Subir la carpeta `lib/` del paquete v1.7.
3. Reemplazar `pubspec.yaml`.

### Paso 2 — Reemplazar workflow
Reemplazar `.github/workflows/build.yml` con el del paquete (sigue compilando RELEASE).

### Paso 3 — Actualizar Android
- `android/app/build.gradle.kts`: actualizar `versionCode = 5` y `versionName = "2.1.7"`. Ver snippet en `android_config/`.
- `AndroidManifest.xml`: NO tocar (los permisos siguen siendo los mismos).

### Paso 4 — Commit + Push
```
git add .
git commit -m "feat: VENTON PRO v2.1.7 - Ruleta 24h + códigos únicos + WhatsApp dueño + banners rotativos"
git push
```

### Paso 5 — Esperar build
GitHub Actions compila release. ~5-7 minutos. APK final ~28-30 MB.

---

## ✅ Checklist técnico

- [x] Sin APIs Flutter 3.27+ (auditado)
- [x] Cero imports rotos (auditado)
- [x] Sin `initialValue:` en Dropdowns
- [x] Sin `withValues()` (Flutter 3.27+)
- [x] Modelo `Producto` actualizado (nuevo campo `caracteristicas`)
- [x] Modelo `Experiencia` con WhatsApp dueño
- [x] Nuevo modelo `NegocioAnunciante` para hoteles/restaurantes
- [x] Nuevo modelo `PremioRuleta` con tipos enum
- [x] Servicio `RuletaService` con lógica completa
- [x] Pop-up automático ruleta al abrir
- [x] Cuenta regresiva en tiempo real
- [x] Códigos únicos VTN-XXXX-XXXX
- [x] Banner rotativo con auto-play
- [x] Carruseles con auto-scroll suave

---

## 🔜 Lo que viene en OLA 2

- Firebase Firestore (sincronización global de jugadas)
- Firebase Auth (login dueños con WhatsApp+SMS)
- Panel admin para Ricardo (cargar negocios desde la app)
- Panel del dueño (autogestión de su negocio)
- Selector de país/ciudad
- Mapa de negocios cercanos
- AdMob real

---

**FIN DEL PAQUETE v2.1.7 — RULETA PRO + MOVIMIENTO**

🤝 Equipo VENTON PRO: Ricardo (CEO) · Claude (CTO ejecutor) · Cascade (ejecutor)
🎯 Misión: dejar app blindada para revisión Google de AGOSTO 2026
