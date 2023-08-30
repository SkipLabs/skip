plugins {
  id("org.jetbrains.kotlin.jvm")

  // for lint and formatting
  id("com.diffplug.spotless") version "6.12.1"

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
  implementation("io.undertow:undertow-core:2.3.2.Final")

  // aws
  implementation("software.amazon.awssdk:bom:2.20.3")
  implementation("software.amazon.awssdk:kms:2.20.3")

  // ws client
  implementation("org.java-websocket:Java-WebSocket:1.5.3")

  // coroutines
  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.1")

  // log4j2 slf4j binding
  implementation("org.apache.logging.log4j:log4j-slf4j-impl:2.20.0")

  implementation(project(":core"))
}

application {
  mainClass.set("io.skiplabs.skdb.AppKt")
}

tasks.named<Test>("test") {
  useJUnitPlatform()
}

spotless { kotlin { ktfmt("0.42") } }

task("runMuxTestServer", JavaExec::class) {
  mainClass.set("io.skiplabs.skdb.test.MuxTestServerKt")
  classpath = sourceSets["test"].runtimeClasspath
}

task("runMuxTestClient", JavaExec::class) {
  mainClass.set("io.skiplabs.skdb.test.MuxTestClientKt")
  classpath = sourceSets["test"].runtimeClasspath
}

task("runCli", JavaExec::class) {
  mainClass.set("io.skiplabs.skdb.cli.CliKt")
  classpath = sourceSets["test"].runtimeClasspath
}

tasks.jar {
    dependsOn(":core:jar")
    manifest.attributes["Main-Class"] = "io.skiplabs.skdb.AppKt"
    val dependencies = configurations
        .runtimeClasspath
        .get()
        .map(::zipTree)
    from(dependencies)
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}
