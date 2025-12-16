// E:\Zoom\android\build.gradle.kts

plugins {
    // 1. Android Application Plugin
    id("com.android.application") version "8.9.1" apply false

    // 2. Kotlin Android Plugin
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false

    // 3. Google Services Plugin
    id("com.google.gms.google-services") version "4.4.4" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
