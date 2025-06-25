plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.latihanuas" // Pastikan namespace ini sudah benar
    compileSdk = flutter.compileSdkVersion // Gunakan ini, JANGAN hardcode 34 kecuali Anda tahu apa yang Anda lakukan
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Ini adalah ID aplikasi utama Anda. Pilih salah satu yang ingin Anda gunakan.
        // Contoh: Jika Anda ingin menggunakan "com.example.latihanuas_android"
        applicationId = "com.example.latihanuas_android" // Atau "com.example.latihanuas" jika itu yang Anda inginkan

        minSdk = flutter.minSdkVersion // Gunakan ini, JANGAN hardcode 21 kecuali diperlukan
        targetSdk = flutter.targetSdkVersion // Gunakan ini, JANGAN hardcode 34 kecuali diperlukan

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}