package io.skiplabs.skgw

import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.HttpServerExchange
import io.undertow.util.Headers
import io.undertow.Handlers
import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.spi.WebSocketHttpExchange
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.WebSocketFrameType
import io.undertow.websockets.core.WebSockets

fun createHttpServer(): Undertow {
    var server = Undertow.builder()
        .addHttpListener(8080, "0.0.0.0")
        .setHandler(Handlers.path()
            .addPrefixPath("/skgw", Handlers.websocket(
                object : WebSocketConnectionCallback {
                    override fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel) {
                        channel.receiveSetter.set(
                            object : AbstractReceiveListener() {
                                override fun onFullTextMessage(channel: WebSocketChannel, message: BufferedTextMessage) {
                                    WebSockets.sendText(message.data, channel, null)
                                }
                            })
                        channel.resumeReceives()
                    }
                }))
            .addPrefixPath("/",
                object : HttpHandler {
                    override fun handleRequest(exchange: HttpServerExchange) {
                        exchange.responseSender.send(
                            "<html><head><title>Test</title></head><body></body></html>")
                    }
                }
            ))
        .build()
    return server
}

fun main() {
    var server = createHttpServer()
    server.start()
}
