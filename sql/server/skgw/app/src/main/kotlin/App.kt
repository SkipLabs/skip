package io.skiplabs.skgw

import com.beust.klaxon.Klaxon
import com.beust.klaxon.TypeAdapter
import com.beust.klaxon.TypeFor
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.server.handlers.resource.FileResourceManager
import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.WebSockets
import io.undertow.websockets.spi.WebSocketHttpExchange
import io.undertow.util.AttachmentKey
import io.undertow.util.PathTemplateMatch
import java.io.File
import java.io.OutputStream
import java.util.concurrent.ConcurrentHashMap
import kotlin.io.bufferedWriter
import kotlin.reflect.KClass

class ProtoTypeAdapter : TypeAdapter<ProtoMessage> {
    override fun classFor(type: Any): KClass<out ProtoMessage> =
        when (type as String) {
            "query" -> ProtoQuery::class
            "tail" -> ProtoTail::class
            "dumpTable" -> ProtoDumpTable::class
            "write" -> ProtoWrite::class
            "pipe" -> ProtoData::class
            else -> throw IllegalArgumentException("Unknown request type: $type")
        }
}

// TODO: the protocol has no way of communicating errors
@TypeFor(field = "request", adapter = ProtoTypeAdapter::class)
sealed class ProtoMessage(val request: String)

data class ProtoQuery(val query: String, val format: String = "csv") : ProtoMessage("query")

data class ProtoTail(val table: String, val user: String, val password: String) :
    ProtoMessage("tail")

data class ProtoDumpTable(val table: String, val suffix: String = "") : ProtoMessage("dumpTable")

data class ProtoWrite(val table: String, val user: String, val password: String) :
    ProtoMessage("write")

data class ProtoData(val data: String) : ProtoMessage("pipe")

fun parse(data: String): ProtoMessage {
    val msg = Klaxon().parse<ProtoMessage>(data)
    if (msg == null) {
        throw RuntimeException("could not parse message")
    }
    return msg
}

fun serialise(msg: ProtoMessage): String {
    return Klaxon().toJsonString(msg)
}

fun handleRequest(message: String, channel: WebSocketChannel, state: ChannelState): Unit {
    val req = parse(message)

    when (req) {
        is ProtoQuery -> {
            val format =
                when (req.format) {
                    "csv" -> OutputFormat.CSV
                    "json" -> OutputFormat.JSON
                    else -> OutputFormat.CSV
                }
            val result = Skdb(state.dbPath).sql(req.query, format)
            val payload = serialise(ProtoData(result))
            WebSockets.sendTextBlocking(payload, channel)
            channel.close()
        }
        is ProtoDumpTable -> {
            val result = Skdb(state.dbPath).dumpTable(req.table, req.suffix)
            val payload = serialise(ProtoData(result))
            WebSockets.sendTextBlocking(payload, channel)
            channel.close()
        }
        is ProtoTail -> {
            // TODO: no way to shut this down, just leaking resources here.
            Skdb(state.dbPath)
                .tail(
                    req.user,
                    req.password,
                    req.table,
                    {
                        val payload = serialise(ProtoData(it))
                        WebSockets.sendTextBlocking(payload, channel)
                    }
                )
        }
        is ProtoWrite -> {
            val skdbStdin = Skdb(state.dbPath).writeCsv(req.user, req.password, req.table)
            state.procStdin = skdbStdin
        }
        is ProtoData -> {
            val stdin = state.procStdin
            if (stdin == null) {
                throw RuntimeException("data received on a connection without a process setup")
            }
            // stream data to the process attached to this channel
            val writer = stdin.bufferedWriter()
            writer.write(req.data)
            writer.flush()
        }
    }
}

data class ChannelState(var procStdin: OutputStream?, val dbPath: String)

fun resolveDbPath(db: String?): String? {
    if (db == null) {
        return null;
    }

    val path = "/var/db/${db}.db"
    return if (File(path).exists()) path else null
}

fun createHttpServer(): Undertow {
    // TODO: weak refs or gc
    val connections = ConcurrentHashMap<WebSocketChannel, ChannelState>()

    val rootHandler =
        Handlers.path()
            .addPrefixPath("/", Handlers.resource(FileResourceManager(File("/skfs_build/build/"))))

    var pathHandler =
        PathTemplateHandler(rootHandler)
            .add(
                "/dbs/{database}/connection",
                Handlers.websocket(
                    object : WebSocketConnectionCallback {
                        override fun onConnect(
                            exchange: WebSocketHttpExchange,
                            channel: WebSocketChannel
                        ) {
                            val pathParams = exchange.getAttachment(PathTemplateMatch.ATTACHMENT_KEY).getParameters()
                            val db = pathParams["database"]
                            val dbPath = resolveDbPath(db)

                            if (dbPath == null) {
                                // 1011 is internal error
                                WebSockets.sendCloseBlocking(1011, "resource not found", channel)
                                return
                            }

                            // TODO: should harvest the user/auth, and
                            // database here. these are
                            // connection-specific properties
                            connections.put(channel, ChannelState(procStdin = null, dbPath))

                            channel.receiveSetter.set(
                                object : AbstractReceiveListener() {
                                    override fun onFullTextMessage(
                                        channel: WebSocketChannel,
                                        message: BufferedTextMessage
                                    ) {
                                        try {
                                            var state = connections.get(channel)

                                            if (state == null) {
                                                throw RuntimeException("state not found for connection")
                                            }

                                            handleRequest(message.data, channel, state)
                                        } catch (ex: Exception) {
                                            // 1011 is internal error
                                            WebSockets.sendCloseBlocking(1011, ex.message, channel)
                                        }
                                    }
                                }
                            )
                            channel.resumeReceives()
                        }
                    }
                )
            )

    var server = Undertow.builder().addHttpListener(8080, "0.0.0.0").setHandler(pathHandler).build()
    return server
}

fun main() {
    var server = createHttpServer()
    server.start()
}
