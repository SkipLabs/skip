package io.skiplabs.skgw.test

import io.skiplabs.skgw.MuxedSocket
import io.skiplabs.skgw.connect
import java.net.URI
import java.util.concurrent.Executors

fun main() {
  val ws = connect(URI("ws://localhost:8080/"))
  val taskPool = Executors.newSingleThreadScheduledExecutor()
  val socket =
      MuxedSocket(
          channel = ws,
          taskPool = taskPool,
          onStream = { _, _ -> },
          onClose = {},
          onError = { _, _, _ -> },
      )
  socket.openStream()!!.error(1u, "foo")
  socket.closeSocket()
}
