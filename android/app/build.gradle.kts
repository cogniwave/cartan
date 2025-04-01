plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cartan"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.cartan"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions.add("env")

    productFlavors {
        create("production") {
            dimension = "env"
            versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
            versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0"
            resValue("string", "app_name", "Flavor")
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
            versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0"
            resValue("string", "app_name", "Flavor Staging")
        }
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
            versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0"
            resValue("string", "app_name", "Flavor Dev")
        }
    }
}

flutter {
    source = "../.."
}