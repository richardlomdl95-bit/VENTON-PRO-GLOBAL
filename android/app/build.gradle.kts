plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ventonpro.app"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    // signingConfigs {
    //     create("release") {
    //         def keystorePropertiesFile = rootProject.file("key.properties")
    //         def keystoreProperties = new Properties()
    //         if (keystorePropertiesFile.exists()) {
    //             keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    //         }
    //         // keyAlias keystoreProperties['keyAlias']
    //         // keyPassword keystoreProperties['keyPassword']
    //         // storeFile file(keystoreProperties['storeFile'])
    //         // storePassword keystoreProperties['storePassword']
    //     }
    // }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ventonpro.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Sin configuración de firma para debug
        }
    }
}

flutter {
    source = "../.."
}

// Firebase plugin
apply(plugin = "com.google.gms.google-services")
