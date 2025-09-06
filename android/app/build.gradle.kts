plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.io.File

android {
    namespace = "com.chandra.pingmyride"
    compileSdk = flutter.compileSdkVersion
    // Use a specific installed NDK version to avoid errors when an NDK folder is incomplete.
    // Choose an NDK version dynamically to avoid builds failing when an NDK folder is malformed.
    // Prefer NDK 27 if it's present and contains source.properties; otherwise fall back to a known working NDK.
    val sdkPath = System.getenv("ANDROID_SDK_ROOT") ?: System.getenv("ANDROID_HOME") ?: System.getProperty("user.home") + "${'$'}{java.io.File.separator}AppData${'$'}{java.io.File.separator}Local${'$'}{java.io.File.separator}Android${'$'}{java.io.File.separator}sdk"
    val ndk27 = File(sdkPath, "ndk/27.0.12077973")
    val ndk26 = File(sdkPath, "ndk/26.3.11579264")
    val chosenNdk: String? = when {
        ndk27.exists() && File(ndk27, "source.properties").exists() -> "27.0.12077973"
        ndk26.exists() && File(ndk26, "source.properties").exists() -> "26.3.11579264"
        else -> null
    }
    // Only set ndkVersion when we found a valid local NDK. If none is valid, leave it unset
    // and allow the Android Gradle Plugin to download/resolve the appropriate NDK automatically.
    if (chosenNdk != null) {
        ndkVersion = chosenNdk
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId = "com.chandra.pingmyride"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
