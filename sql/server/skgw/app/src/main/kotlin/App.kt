package io.skiplabs.skgw

import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.HttpServerExchange
import io.undertow.util.Headers

fun main() {
    var server = Undertow.builder()
        .addHttpListener(8080, "0.0.0.0")
        .setHandler(
            object : HttpHandler {
                override fun handleRequest(exchange: HttpServerExchange) {
                    exchange.getResponseHeaders()
                        .put(Headers.CONTENT_TYPE, "text/plain")
                    exchange.getResponseSender().send("Hello World")
                }
            }
        )
        .build()
    server.start()
}
