package io.skiplabs.skgw.test

import io.skiplabs.skgw.connect
import java.net.URI
import java.util.concurrent.Executors
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
  val taskPool = Executors.newSingleThreadScheduledExecutor()
  val socket =
      connect(
          URI("ws://localhost:8080/"),
          taskPool = taskPool,
          onStream = { _, _ -> },
          onClose = {},
          onError = { _, _, _ -> })
  socket.openStream()!!.error(1u, "foo")
  socket.closeSocket()
}
