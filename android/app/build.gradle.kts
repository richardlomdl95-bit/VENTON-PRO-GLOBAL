plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ventonpro.app"
    compileSdk = 34
    ndkVersion = "27.0.12077973"

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
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
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

flutter {
    source = "../.."
}
