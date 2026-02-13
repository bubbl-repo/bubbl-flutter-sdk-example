plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val googleServicesFile = file("google-services.json")
check(googleServicesFile.exists()) {
    "Missing android/app/google-services.json for applicationId tech.bubbl.flutter. " +
        "Download it from Firebase Console and place it at " +
        "android/app/google-services.json."
}

val googleMapsApiKey =
    (project.findProperty("GOOGLE_MAPS_API_KEY") as String?)
        ?: System.getenv("GOOGLE_MAPS_API_KEY")
        ?: "REPLACE_WITH_GOOGLE_MAPS_API_KEY"

android {
    namespace = "tech.bubbl.flutter"
    compileSdk = maxOf(flutter.compileSdkVersion, 31)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "tech.bubbl.flutter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 27
        targetSdk = maxOf(flutter.targetSdkVersion, 31)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
