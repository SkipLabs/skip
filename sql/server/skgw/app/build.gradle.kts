plugins {
  id("org.jetbrains.kotlin.jvm") version "1.7.10"

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

  implementation("com.google.guava:guava:31.1-jre")

  // http/ws server
  implementation("io.undertow:undertow-core:2.3.2.Final")

  // json
  implementation("com.beust:klaxon:5.5")

  // aws
  implementation("software.amazon.awssdk:bom:2.20.3")
  implementation("software.amazon.awssdk:kms:2.20.3")
}

application {
  mainClass.set("io.skiplabs.skgw.AppKt")
}

tasks.named<Test>("test") {
  useJUnitPlatform()
}

spotless { kotlin { ktfmt("0.42") } }

task("runMuxTestServer", JavaExec::class) {
  mainClass.set("io.skiplabs.skgw.test.MuxTestServerKt")
  classpath = sourceSets["test"].runtimeClasspath
}
