import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.cogniwave.cartan"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.cogniwave.cartan"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            ndk {
                debugSymbolLevel = "FULL"
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions.add("env")

    productFlavors {
        create("production") {
            dimension = "env"
            versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
            versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0"
            resValue("string", "app_name", "Cartan")
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