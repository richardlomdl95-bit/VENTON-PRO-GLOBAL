# 📦 VENTON PRO v2.1 — OLA 1

**Paquete de instrucciones para Cascade**
**Aprobado por:** CEO (Ricardo Venton)
**Coordinado por:** Claude (CEO ejecutor)
**Ejecutor:** Cascade

---

## 🎯 Objetivo de OLA 1

Compilar APK funcional en GitHub Actions **sin Firebase, sin Google Maps, sin AdMob**.
App 100% operativa con datos mock locales y todos los formularios enviando por WhatsApp.

---

## 📂 Estructura del paquete

```
venton_pro/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── core/
    │   ├── home_shell.dart
    │   ├── theme.dart
    │   ├── venton_config.dart
    │   ├── venton_helpers.dart
    │   └── widgets/
    │       ├── acceso_rapido.dart
    │       ├── banner_publicidad.dart
    │       ├── boton_whatsapp.dart
    │       ├── feed_reciente.dart
    │       └── tarjeta_vendedor.dart
    └── pages/
        ├── cafe_page.dart
        ├── inicio_page.dart
        ├── mas_page.dart
        ├── negocios_page.dart
        ├── politica_page.dart
        ├── quimicos_page.dart
        ├── ruleta_page.dart
        ├── subir_contenido_page.dart
        ├── terminos_page.dart
        ├── turismo_page.dart
        ├── vendedor_registro_page.dart
        ├── vendedores_page.dart
        └── widgets/
            └── _grilla_productos.dart
```

---

## ⚙️ Órdenes de ejecución para Cascade

### Paso 1 — Reemplazar archivos en el repo
Repo: `github.com/richardlomdl95-bit/VENTON-PRO-GLOBAL`

1. Reemplazar `pubspec.yaml` con el incluido en este paquete.
2. Reemplazar `lib/main.dart` con el incluido.
3. Subir TODA la carpeta `lib/core/` (4 archivos + carpeta `widgets/` con 5 archivos).
4. Subir TODA la carpeta `lib/pages/` (12 archivos + carpeta `widgets/` con 1 archivo).

**Total: 23 archivos Dart + 1 pubspec.yaml.**

### Paso 2 — Configurar Android

En `android/app/build.gradle` confirmar:
```gradle
applicationId "com.ventonpro.app"
minSdkVersion 21
targetSdkVersion 34
```

En `android/app/src/main/AndroidManifest.xml` agregar dentro de `<manifest>` (antes de `<application>`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
    </intent>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="tel" />
    </intent>
</queries>
```
Esto es necesario para que `url_launcher` funcione en Android 11+.

### Paso 3 — Compilar en GitHub Actions

Disparar el workflow de build APK. Si el workflow no existe, crear `.github/workflows/build.yml` con un build estándar Flutter.

### Paso 4 — Validar
- APK descargable desde Actions.
- Instalar en un dispositivo Android.
- Probar: navegación 5 tabs, todos los botones de WhatsApp, ruleta gira, formularios validan.

---

## ✅ Checklist de calidad del código

- [x] Null-safe (sdk: '>=3.3.0')
- [x] Material 3 (`useMaterial3: true`)
- [x] Manejo de errores en todas las llamadas async (`url_launcher`)
- [x] Imágenes con `cached_network_image` + placeholder + errorWidget
- [x] Sin dependencias de servicios externos (Firebase, Maps, AdMob)
- [x] Solo 3 dependencias externas: `url_launcher`, `shared_preferences`, `cached_network_image`
- [x] Todas las strings en español (mercado CO/US/VE)
- [x] Página de eliminación de cuenta (requisito Play Store 2024+)
- [x] Política de privacidad y Términos (requisito Play Store)
- [x] Ruleta presentada como mecánica promocional sin valor monetario directo

---

## 🚫 Lo que NO incluye OLA 1 (queda para OLA 2)

- Firebase (Auth, Firestore, Storage)
- Google Maps
- AdMob
- Login de usuario
- Sincronización de ruleta entre dispositivos
- Push notifications

---

## 🟢 Próximos pasos tras validar APK

1. Ricardo prueba la app en su teléfono.
2. Si todo funciona → arrancamos OLA 2 (Firebase + Maps + AdMob).
3. Si algo falla → reportar al CEO ejecutor (Claude) con captura del error.

---

**FIN DEL PAQUETE OLA 1**
