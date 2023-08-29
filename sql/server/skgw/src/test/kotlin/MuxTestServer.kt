package io.skiplabs.skdb.test

import io.skiplabs.skdb.MuxedSocket
import io.skiplabs.skdb.MuxedSocketEndpoint
import io.skiplabs.skdb.MuxedSocketFactory
import io.skiplabs.skdb.Stream
import io.skiplabs.skdb.WebSocket
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets
import java.util.concurrent.Executors

val streams: List<Stream> = listOf()

fun setupStream(sock: MuxedSocket, s: Stream) {
  s.onData = { data ->
    val type = data.getInt()
    when (type) {
      // close from this side
      0 -> {
        s.close()
      }
      // echo
      1 -> {
        val n = data.getInt()
        val buf = ByteBuffer.allocate(4)
        buf.putInt(n)
        buf.flip()
        s.send(buf)
      }
      // send n messages
      2 -> {
        val n = data.getInt()
        for (i in 0..n) {
          val buf = ByteBuffer.allocate(4)
          buf.putInt(i)
          buf.flip()
          s.send(buf)
        }
      }
      // open a stream
      3 -> {
        val newStream = sock.openStream()
        if (newStream == null) {} else {
          setupStream(sock, newStream)
        }
        val buf = ByteBuffer.allocate(4)
        buf.putInt(0xABCDEF12u.toInt())
        buf.flip()
        newStream?.send(buf)
      }
      // error from this side
      4 -> {
        s.error(5u, "server errored stream")
      }
      // send a bunch of data concurrently on different streams
      5 -> {
        val threads = ArrayList<Thread>()

        for (streamIdx in 0..5) {
          val newStream = sock.openStream()
          newStream!!

          val t =
              Thread({
                for (i in 0..10000) {
                  val buf = ByteBuffer.allocate(4)
                  buf.putInt(i)
                  buf.flip()
                  newStream.send(buf)
                }
                newStream.close()
              })

          threads.add(t)
          t.start()
        }
      }
      else -> throw RuntimeException("oops")
    }
  }
  s.onClose = { s.close() }
  s.onError = { _, _ -> }
}

fun createHttpServer(port: Int): Undertow {
  val muxHandler =
      Handlers.websocket(
          MuxedSocketEndpoint(
              object : MuxedSocketFactory {
                override fun onConnect(
                    exchange: WebSocketHttpExchange,
                    channel: WebSocket
                ): MuxedSocket {
                  val socket =
                      MuxedSocket(
                          channel = channel,
                          taskPool = Executors.newSingleThreadScheduledExecutor(),
                          onStream = ::setupStream,
                          onClose = {},
                          onError = { _, _, _ -> },
                          getDecryptedKey = {
                            when (it.accessKey) {
                              "ABCDEFGHIJKLMNOPQRST" -> "test".toByteArray(StandardCharsets.UTF_8)
                              "root" -> "very_secure".toByteArray(StandardCharsets.UTF_8)
                              else -> throw RuntimeException("illegal!")
                            }
                          })
                  return socket
                }
              }))

  var pathHandler = PathTemplateHandler().add("/", muxHandler)

  return Undertow.builder().addHttpListener(port, "0.0.0.0").setHandler(pathHandler).build()
}

fun main(args: Array<String>) {
  var port = 8080
  if (args.size > 0) {
    port = Integer.parseInt(args[0])
  }
  val server = createHttpServer(port)
  server.start()
}
