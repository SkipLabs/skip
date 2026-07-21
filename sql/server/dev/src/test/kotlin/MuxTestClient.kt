package io.skiplabs.skdb.test

import io.skiplabs.skdb.Credentials
import io.skiplabs.skdb.connectMux
import java.net.URI
import java.nio.ByteBuffer
import java.util.concurrent.Executors
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
  val taskPool = Executors.newSingleThreadScheduledExecutor()
  val socket =
      connectMux(
          URI("ws://localhost:8080/"),
          taskPool = taskPool,
          onStream = { _, _ -> println("> stream opened [dmfbj]") },
          onClose = { println("> close [inpep]") },
          onError = { _, code, reason -> println("error ${code} ${reason}") },
          creds =
              Credentials(
                  "ABCDEFGHIJKLMNOPQRST",
                  "test".toByteArray(),
                  ByteArray(0),
                  "af72eac9-3611-496c-9894-82f93f61832d"))
  val stream = socket.openStream()

  val buf = ByteBuffer.allocate(8)
  buf.putInt(0x1)
  buf.putInt(0x42)

  stream!!.onData = { d -> println(": [wnbts] buf: ${d.getInt()}") }
  stream.send(buf.flip())
  stream.close()
  socket.closeSocket()
}
