# 🔧 HOTFIX OLA 1 — VENTON PRO v2.1

**Causa del fallo:** 2 archivos usaban `initialValue:` (API Flutter 3.27+) cuando GitHub Actions corre Flutter 3.24. Cambio de palabra: `initialValue:` → `value:`.

---

## ⚙️ Órdenes para Cascade

### Paso 1 — Reemplazar 2 archivos en el repo

Reemplazar EXACTAMENTE estos 2 archivos del repo `VENTON-PRO-GLOBAL`:

1. `lib/pages/vendedor_registro_page.dart` ← reemplazar con el del HOTFIX
2. `lib/pages/subir_contenido_page.dart` ← reemplazar con el del HOTFIX

Los demás archivos del proyecto NO se tocan.

### Paso 2 — Arreglar warning de NDK de Android

Editar `android/app/build.gradle.kts` y dentro del bloque `android { ... }` agregar (o reemplazar la línea de ndkVersion existente):

```kotlin
android {
    ndkVersion = "27.0.12077973"
    // ... el resto del bloque queda igual
}
```

Si el archivo es `android/app/build.gradle` (sin el .kts), la sintaxis es:

```groovy
android {
    ndkVersion "27.0.12077973"
    // ... el resto queda igual
}
```

### Paso 3 — Commit y push

```
git add .
git commit -m "fix: corregir DropdownButtonFormField y NDK version para Flutter 3.24"
git push
```

### Paso 4 — Disparar workflow de nuevo

GitHub Actions debería arrancar solo al hacer push. Si no, dispararlo manualmente.

### Paso 5 — Validar

Esperar 3 minutos. El build debe terminar **VERDE** ✅.

---

## ✅ Resultado esperado

- Build verde
- APK descargable desde Actions → Artifacts
- Sin errores de compilación
- Solo queda 1 advertencia menor sobre Node.js 20 (no afecta el APK, se ignora)

**FIN DEL HOTFIX**
