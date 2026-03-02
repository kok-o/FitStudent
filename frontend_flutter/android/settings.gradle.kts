pluginManagement {
    val flutterSdkPath = run {
        val env = System.getenv("FLUTTER_ROOT")
        if (env != null && java.io.File(env).exists()) {
            env
        } else {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val prop = properties.getProperty("flutter.sdk")
            require(prop != null) { "flutter.sdk not set in local.properties and FLUTTER_ROOT not defined" }
            prop
        }
    }

    includeBuild("${flutterSdkPath.replace('\\', '/')}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
