package io.skiplabs.skgw.test

import io.skiplabs.skgw.connect
import java.net.URI

fun main() {
  val client = connect(URI("ws://localhost:8080/"))
}
