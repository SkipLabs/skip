plugins {
  id("org.jetbrains.kotlin.jvm")
  id("com.diffplug.spotless") version "7.0.0"
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

  // coroutines
  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.1")

  implementation(project(":core"))
}

application {
  mainClass.set("io.skiplabs.skdb.server.ServiceKt")
}

// The test sources in this project are for manual testing (see runMuxTest* tasks), not JUnit
tasks.withType<Test> { enabled = false }

task("runMuxTestServer", JavaExec::class) {
  mainClass.set("io.skiplabs.skdb.test.MuxTestServerKt")
  classpath = sourceSets["test"].runtimeClasspath
}

task("runMuxTestClient", JavaExec::class) {
  mainClass.set("io.skiplabs.skdb.test.MuxTestClientKt")
  classpath = sourceSets["test"].runtimeClasspath
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

spotless { kotlin { ktfmt("0.49") } }
