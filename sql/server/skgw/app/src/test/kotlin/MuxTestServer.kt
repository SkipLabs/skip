package io.skiplabs.skgw.test

import io.skiplabs.skgw.MuxedSocket
import io.skiplabs.skgw.MuxedSocketEndpoint
import io.skiplabs.skgw.MuxedSocketFactory
import io.skiplabs.skgw.Stream
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets

val streams: List<Stream> = listOf()
var lastSocket: MuxedSocket? = null

fun setupStream(sock: MuxedSocket, s: Stream) {
  lastSocket = sock

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
      else -> throw RuntimeException("oops")
    }
  }
  s.onClose = { s.close() }
  s.onError = { code, reason -> }
}

fun createHttpServer(): Undertow {
  val muxHandler =
      Handlers.websocket(
          MuxedSocketEndpoint(
              object : MuxedSocketFactory {
                override fun onConnect(
                    exchange: WebSocketHttpExchange,
                    channel: WebSocketChannel
                ): MuxedSocket {
                  val socket =
                      MuxedSocket(
                          onStream = ::setupStream,
                          onClose = {},
                          onError = { socket, code, msg -> },
                          socket = channel,
                          getDecryptedKey = { "test".toByteArray(StandardCharsets.UTF_8) })
                  return socket
                }
              }))

  var pathHandler = PathTemplateHandler().add("/", muxHandler)

  return Undertow.builder().addHttpListener(8080, "0.0.0.0").setHandler(pathHandler).build()
}

fun main() {
  val server = createHttpServer()
  server.start()
}
