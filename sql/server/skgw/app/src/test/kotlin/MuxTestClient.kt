package io.skiplabs.skgw.test

import io.skiplabs.skgw.Credentials
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
          onError = { _, _, _ -> },
          creds =
              Credentials(
                  "ABCDEFGHIJKLMNOPQRST",
                  "test".toByteArray(),
                  ByteArray(0),
                  "af72eac9-3611-496c-9894-82f93f61832d"))
  socket.openStream()!!.error(1u, "foo")
  socket.closeSocket()
}
