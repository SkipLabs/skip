package io.skiplabs.skgw.test

import io.skiplabs.skgw.MuxedSocket
import io.skiplabs.skgw.MuxedSocketEndpoint
import io.skiplabs.skgw.MuxedSocketFactory
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.nio.charset.StandardCharsets

fun createHttpServer(): Undertow {
  val muxHandler =
      Handlers.websocket(
          MuxedSocketEndpoint(
              object : MuxedSocketFactory {
                override fun onConnect(
                    exchange: WebSocketHttpExchange,
                    channel: WebSocketChannel
                ): MuxedSocket {
                  return MuxedSocket(
                      onStream = { stream -> println("Got a stream: ${stream}") },
                      onClose = { println("Closing socket") },
                      onError = { code, msg -> println("Socket errored [${code}]: ${msg}") },
                      socket = channel,
                      getDecryptedKey = { "test".toByteArray(StandardCharsets.UTF_8) })
                }
              }))

  var pathHandler = PathTemplateHandler().add("/", muxHandler)

  return Undertow.builder().addHttpListener(8080, "0.0.0.0").setHandler(pathHandler).build()
}

fun main() {
  val server = createHttpServer()
  server.start()
}
