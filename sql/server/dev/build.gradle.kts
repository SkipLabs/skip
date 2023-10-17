plugins {
  id("org.jetbrains.kotlin.jvm")

  application
  java
}

repositories {
  mavenCentral()
}

dependencies {
  testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
  testImplementation("org.junit.jupiter:junit-jupiter-engine:5.9.1")

  // http/ws server
  implementation("io.undertow:undertow-core:2.3.9.Final")

  implementation(project(":core"))
}

application {
  mainClass.set("io.skiplabs.skdb.server.ServiceKt")
}

tasks.named<Test>("test") {
  useJUnitPlatform()
}

tasks.jar {
    dependsOn(":core:jar")
    manifest.attributes["Main-Class"] = "io.skiplabs.skdb.server.ServiceKt"
    val dependencies = configurations
        .runtimeClasspath
        .get()
        .map(::zipTree)
    from(dependencies)
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}
