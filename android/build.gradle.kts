allprojects {
    repositories {
        mavenLocal()
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/bubbl-repo/bubbl-android-sdk")
            credentials {
                username =
                    (findProperty("BUBBL_MAVEN_USER") as String?)
                        ?: System.getenv("BUBBL_MAVEN_USER")
                        ?: ""
                password =
                    (findProperty("BUBBL_MAVEN_TOKEN") as String?)
                        ?: System.getenv("BUBBL_MAVEN_TOKEN")
                        ?: ""
            }
        }
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
