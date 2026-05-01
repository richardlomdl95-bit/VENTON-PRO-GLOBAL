# 🚀 VENTON PRO v3.0 - INSTRUCCIONES DE MONTAJE

## ✅ LO QUE TIENES EN ESTE PAQUETE

1. **`main.dart`** → el código completo de la app (un solo archivo, 2.913 líneas)
2. **`pubspec.yaml`** → la lista de dependencias (paquetes que la app necesita)
3. Este archivo de instrucciones

---

## 📱 PASOS PARA MONTAR EN FLUTLAB / GITHUB

### PASO 1: Pegar el código en GitHub

1. Entra a tu repositorio de GitHub donde tienes el proyecto
2. Si NO existe la carpeta `lib`, créala (clic en "+" → "Create new file" → escribe `lib/main.dart`)
3. Reemplaza TODO el contenido de `lib/main.dart` con el contenido del archivo `main.dart` que te entregué
4. Guarda los cambios (Commit changes)

### PASO 2: Reemplazar el `pubspec.yaml`

1. En la raíz del proyecto en GitHub, abre `pubspec.yaml`
2. Reemplaza TODO el contenido con el `pubspec.yaml` que te entregué
3. Guarda los cambios

### PASO 3: Configurar Firebase (10 minutos, gratis)

1. Entra a https://console.firebase.google.com
2. Crea proyecto nuevo: nombre `venton-pro` (o `ventonpro-app`)
3. Registra app Android:
   - Nombre del paquete: `com.ventonpro.app` (debe coincidir EXACTO con el del `build.gradle`)
   - Descarga el archivo `google-services.json`
   - Súbelo a tu repo en `android/app/google-services.json`
4. Activa estos servicios en Firebase Console:
   - **Authentication** → habilita "Email/Contraseña"
   - **Firestore Database** → crea base de datos en modo "Producción"
   - **Storage** → crea bucket por defecto

### PASO 4: Configurar Gradle (lo que ChatGPT te indicó está bien)

En `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

En `android/app/build.gradle` (al final del archivo):
```gradle
apply plugin: 'com.google.gms.google-services'
```

Y arriba, en el mismo archivo, asegúrate que el `applicationId` sea:
```gradle
applicationId "com.ventonpro.app"
```

### PASO 5: Permisos Android

En `android/app/src/main/AndroidManifest.xml` agrega DENTRO del tag `<manifest>` y antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### PASO 6: Compilar en FlutLab

1. Abre FlutLab y carga tu proyecto desde GitHub
2. Espera que descargue todas las dependencias (1-3 minutos)
3. Pulsa "Build APK" o "Run"
4. Si todo está bien, FlutLab genera el APK

---

## 🛡️ REGLAS DE SEGURIDAD DE FIREBASE (importantes)

En **Firebase Console → Firestore → Rules** pega esto:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cualquiera puede LEER el feed
    match /feed/{doc} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if false;
    }
    // Vendedores: solo crear, no leer
    match /vendedores/{doc} {
      allow create: if true;
      allow read, update, delete: if false;
    }
    // Resto: solo crear (logs)
    match /{collection}/{doc} {
      allow create: if true;
      allow read, update, delete: if false;
    }
  }
}
```

En **Firebase Console → Storage → Rules** pega esto:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /fotos/{file} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.resource.size < 1 * 1024 * 1024;
    }
    match /videos/{file} {
      allow read: if true;
      allow write: if request.auth != null
                   && request.resource.size < 15 * 1024 * 1024;
    }
  }
}
```

---

## ⚠️ COSAS QUE EVITAN QUE GOOGLE PLAY RECHACE LA APP

✅ Política de privacidad (incluida en la app, en sección "Más")
✅ Términos de uso (incluidos en la app)
✅ Botón de reportar contenido en cada publicación
✅ Login obligatorio para subir contenido
✅ Ruleta sin cobro (no es apuesta)
✅ Disclaimer claro: "No es juego de azar con dinero real"
✅ Permisos solicitados solo cuando se necesitan
✅ Compresión de imágenes para no abusar del tráfico

---

## 🎯 LO QUE CONTIENE LA APP (RESUMEN)

### 5 PESTAÑAS PRINCIPALES:
1. **🏠 Inicio** - Hero de Santa Rosa + accesos rápidos + feed
2. **🏔️ Turismo** - Lugares precargados + reservas por WhatsApp
3. **📢 Publicidad** - 3 planes (Básico, Premium, Top) + 50 gratis + internacional
4. **☕ Café** - 3 niveles (Altura, Especial, Micro-lote) + libra/kilo + suscripción
5. **📋 Más** - Vendedores, químicos, ruleta, política, términos

### FUNCIONES CLAVE:
- Subir fotos y videos (instantáneo, con compresión)
- Registro de vendedores mundial (5 datos solamente)
- Botón WhatsApp en todo
- Botón "Cómo llegar" (Google Maps externo, GRATIS)
- Búsqueda global
- Geolocalización automática
- Multi-idioma automático (es/en/pt/fr)
- Sistema de reportes
- Tracking de eventos en Firestore

### ESPACIOS RESERVADOS (para activar después):
- AdMob (cuando tengas tráfico)
- Google Maps API (cuando estés listo a pagar)
- Pasarela de pago automática (Stripe + Wompi)
- Panel admin web
- Pagos automáticos a vendedores

---

## 💰 COSTO PARA LANZAR HOY

- Google Play Console: **YA PAGADO** ($25 de por vida)
- Firebase: **GRATIS** (plan Spark)
- FlutLab: **GRATIS**
- GitHub: **GRATIS**
- WhatsApp Business: **GRATIS**

**TOTAL: $0 pesos colombianos para lanzar.**

---

## 📞 SI ALGO FALLA

Cualquier error de compilación en FlutLab, copia el mensaje completo y pásamelo. Lo arreglamos juntos.

¡Vamos socio! 🚀☕🏔️
