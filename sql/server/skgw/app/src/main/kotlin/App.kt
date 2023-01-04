package io.skiplabs.skgw

import io.undertow.Undertow
import io.undertow.server.handlers.resource.FileResourceManager
import io.undertow.Handlers
import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.spi.WebSocketHttpExchange
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.WebSockets
import java.io.File

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
            .addPrefixPath("/", Handlers.resource(FileResourceManager(File("/skfs_build/build/")))))
        .build()
    return server
}

fun main() {
    var server = createHttpServer()

    val skdb = Skdb("/tmp/test.db")

    println(skdb.sql("SELECT * FROM posts"))
    println(skdb.dumpTable("posts", "_remote"))

    skdb.writeCsv(user="gregs", password="passgregs", table="posts", "1\t26,\"here!\",141,68")
    println(skdb.sql("SELECT * FROM posts"))

    val proc = skdb.tail(user="gregs", password="passgregs", table="posts", {
        println("would ship: ${it}")
    })

    server.start()
    proc.destroy()
}
