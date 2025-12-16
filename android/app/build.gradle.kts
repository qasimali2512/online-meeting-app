// E:\Zoom\android\app\build.gradle.kts

plugins {
    // Flutter + Android + Firebase setup
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.zoom"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.zoom"
        minSdk = 24
        targetSdk = 29
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            // ✅ Kotlin DSL syntax for release config
            signingConfig = signingConfigs.getByName("debug")

            // ✅ Correct Kotlin DSL for ProGuard
            isMinifyEnabled = true
            isShrinkResources = true // optional: reduces APK size
            setProguardFiles(
                listOf(
                    getDefaultProguardFile("proguard-android.txt"),
                    file("proguard-rules.pro")
                )
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    // Correct path reference for the Flutter module
    source = "../../"
}

dependencies {
    // Firebase BoM — ensures version alignment
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))

    // Firebase modules
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Optional (recommended): multidex support
    implementation("androidx.multidex:multidex:2.0.1")
}
