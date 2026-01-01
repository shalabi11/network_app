allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Only override build directory for root project to prevent conflicts with Flutter plugins
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Skip build directory override for Flutter plugin projects
    if (!project.name.startsWith("flutter_")) {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
    
    // Disable Kotlin incremental compilation to fix path conflict errors
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        incremental = false
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
