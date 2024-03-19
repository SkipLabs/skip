plugins {
  id("org.jetbrains.kotlin.jvm") version "1.9.0"
  id("com.diffplug.spotless") version "6.12.1"
}

repositories { mavenCentral() }

spotless { kotlin { ktfmt("0.47") } }
