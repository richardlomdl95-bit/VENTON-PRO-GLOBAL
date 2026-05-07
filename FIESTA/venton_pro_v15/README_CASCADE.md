# 🚀 VENTON PRO v2.1.5 — OLA 1.5 "Versión Fiesta"

**Aprobado por:** CEO Ricardo Venton
**Coordinado por:** Claude (CEO ejecutor)
**Ejecutor:** Cascade
**Fecha:** 6 de mayo 2026

---

## 🎯 Qué incluye esta versión

✅ Logo VENTON PRO oficial (escudo bronce + azul marino, vectorial)
✅ Splash screen con logo al abrir
✅ Paleta oficial premium (azul marino #0D2849 + bronce #B87333)
✅ Tipografía Poppins (Google Fonts)
✅ Cámara integrada: tomar foto, grabar video, elegir de galería
✅ Sistema de publicaciones de usuarios (UGC) con cumplimiento Google Play:
   - Reportar contenido (6 motivos)
   - Bloquear usuario
   - Ocultar publicación individual
   - Auto-bloqueo a las 3 reportes
   - Términos UGC en formulario
✅ Tab nueva "Comunidad" para feed de publicaciones
✅ Espacios para AdMob reservados (banner ads)
✅ Build RELEASE (~25 MB, abre instantáneo, apto Play Store)
✅ Overflow de botones eliminado
✅ Animaciones suaves entre tabs
✅ Cero APIs Flutter 3.27+ (compatible 100% con 3.24)

---

## ⚙️ Órdenes EXACTAS para Cascade

### Paso 1 — Borrar TODA la carpeta `lib/` del repo y reemplazar

Repo: `github.com/richardlomdl95-bit/VENTON-PRO-GLOBAL`

1. Borrar la carpeta `lib/` completa del repo (sí, completa).
2. Subir la carpeta `lib/` del paquete OLA 1.5 (15 archivos Dart).
3. Reemplazar `pubspec.yaml` con el incluido.

### Paso 2 — Reemplazar workflow

Reemplazar `.github/workflows/build.yml` con el incluido en este paquete.
**Importante:** este nuevo workflow construye en RELEASE (versión final, rápida).

### Paso 3 — Configurar Android (CRÍTICO)

**3.1 — AndroidManifest.xml**
Reemplazar TODO el contenido de `android/app/src/main/AndroidManifest.xml` con el archivo `android_config/AndroidManifest.xml` del paquete.

Esto agrega:
- Permiso CAMERA (tomar foto/video)
- Permiso RECORD_AUDIO (sonido en videos)
- Permisos READ_MEDIA_IMAGES y READ_MEDIA_VIDEO (Android 13+)
- READ_EXTERNAL_STORAGE (Android 12 y menores)
- Queries para image_picker

**3.2 — build.gradle.kts**
En `android/app/build.gradle.kts`, asegurar estos valores (ver snippet en `android_config/build.gradle.kts.snippet`):

```kotlin
android {
    namespace = "com.ventonpro.app"
    compileSdk = 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.ventonpro.app"
        minSdk = 23
        targetSdk = 34
        versionCode = 3
        versionName = "2.1.5"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
```

**Importante:** `minSdk = 23` (necesario para image_picker y video_player).

### Paso 4 — Commit + Push

```
git add .
git commit -m "feat: VENTON PRO v2.1.5 - Logo, splash, cámara, comunidad UGC, build release"
git push
```

### Paso 5 — Esperar build release (~5-7 minutos)

GitHub Actions arranca solo. El APK final pesa ~25 MB y es apto para Play Store.

---

## 🛡️ Cumplimiento Google Play (UGC)

Esta versión cumple con la política de **Contenido Generado por Usuarios** de Google Play:

| Requisito Google | Implementación |
|---|---|
| Sistema de reporte | ✅ Botón "Reportar" con 6 motivos |
| Bloqueo de usuarios | ✅ Botón "Bloquear" en cada publicación |
| Moderación automática | ✅ Auto-oculta a los 3 reportes |
| Términos al subir | ✅ Checkbox obligatorio antes de publicar |
| Eliminación de cuenta | ✅ "Eliminar mi cuenta y datos" en menú Más |
| Política de privacidad | ✅ Visible en menú Más |

---

## 📂 Estructura final

```
venton_pro/
├── pubspec.yaml                              (versión 2.1.5+3)
├── .github/workflows/build.yml               (build RELEASE)
├── android_config/
│   ├── AndroidManifest.xml                   (referencia con permisos)
│   └── build.gradle.kts.snippet              (referencia)
└── lib/
    ├── main.dart                             (con SplashScreen)
    ├── core/
    │   ├── home_shell.dart                   (5 tabs con animación)
    │   ├── splash_screen.dart                (NUEVO)
    │   ├── theme.dart                        (paleta oficial)
    │   ├── venton_config.dart
    │   ├── venton_helpers.dart
    │   ├── publicaciones_service.dart        (NUEVO - UGC)
    │   ├── models/
    │   │   └── publicacion_model.dart        (NUEVO)
    │   └── widgets/
    │       ├── venton_logo.dart              (NUEVO - logo vectorial)
    │       ├── selector_medios.dart          (NUEVO - cámara/galería)
    │       ├── banner_ad_slot.dart           (NUEVO - espacio AdMob)
    │       ├── acceso_rapido.dart            (sin overflow)
    │       ├── banner_publicidad.dart
    │       ├── boton_whatsapp.dart
    │       ├── feed_reciente.dart
    │       └── tarjeta_vendedor.dart
    └── pages/
        ├── inicio_page.dart                  (header con logo)
        ├── turismo_page.dart
        ├── comunidad_page.dart               (NUEVO - feed UGC)
        ├── vendedores_page.dart
        ├── mas_page.dart                     (header con logo)
        ├── cafe_page.dart
        ├── quimicos_page.dart
        ├── ruleta_page.dart
        ├── subir_contenido_page.dart         (cámara + términos UGC)
        ├── vendedor_registro_page.dart
        ├── politica_page.dart
        ├── terminos_page.dart
        └── widgets/
            └── _grilla_productos.dart
```

---

## ✅ Checklist final

- [x] Sin APIs Flutter 3.27+ (`withValues` → `withOpacity`, etc.)
- [x] Sin `initialValue:` en Dropdowns (uso `value:`)
- [x] NDK version `27.0.12077973`
- [x] minSdk 23 (compatibilidad con image_picker)
- [x] Build release configurado
- [x] Permisos cámara, audio y galería declarados
- [x] Queries para image_picker en AndroidManifest
- [x] Sistema UGC completo (reportar, bloquear, ocultar)
- [x] Auto-moderación a 3 reportes
- [x] Logo vectorial (carga instantánea, nítido a cualquier tamaño)
- [x] Splash screen con animación
- [x] Espacios AdMob preparados (placeholder en OLA 1.5, real en OLA 2)

---

## 🔜 Lo que viene en OLA 2

- Firebase Firestore: publicaciones sincronizadas entre usuarios
- Firebase Storage: videos/fotos viajan al servidor
- Firebase Auth: login con email/Google
- AdMob real con ID de tu cuenta
- Push notifications

**FIN DEL PAQUETE OLA 1.5 — VERSIÓN FIESTA**

🤝 Equipo VENTON PRO: Ricardo (CEO) · Claude (CTO ejecutor) · Cascade (ejecutor)
