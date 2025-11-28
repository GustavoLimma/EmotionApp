buildscript {
    extra.apply {
        set("kotlin_version", "1.8.22")  // ✅ Atualize para versão compatível
    }

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.4")  // ✅ Versão estável
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")  // ✅ Diretamente
        classpath("com.google.gms:google-services:4.4.2")  // ✅ Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ REMOVA estas linhas se estiverem causando problemas:
// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)

// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}