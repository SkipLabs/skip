package io.skiplabs.skgw

import com.beust.klaxon.Klaxon
import com.beust.klaxon.TypeAdapter
import com.beust.klaxon.TypeFor
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.server.handlers.resource.FileResourceManager
import io.undertow.util.PathTemplateMatch
import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.WebSockets
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.io.File
import java.nio.channels.Channel
import kotlin.io.bufferedWriter
import kotlin.reflect.KClass
import org.xnio.ChannelListener

class ProtoTypeAdapter : TypeAdapter<ProtoMessage> {
  override fun classFor(type: Any): KClass<out ProtoMessage> =
      when (type as String) {
        "auth" -> ProtoAuth::class
        "query" -> ProtoQuery::class
        "tail" -> ProtoTail::class
        "dumpTable" -> ProtoDumpTable::class
        "write" -> ProtoWrite::class
        "pipe" -> ProtoData::class
        else -> throw IllegalArgumentException("Unknown request type: $type")
      }
}

@TypeFor(field = "request", adapter = ProtoTypeAdapter::class)
sealed class ProtoMessage(val request: String)

data class ProtoAuth(val accessKey: String, val date: String, val signature: String) :
    ProtoMessage("auth")

data class ProtoQuery(val query: String, val format: String = "csv") : ProtoMessage("query")

data class ProtoTail(
    val table: String,
    val since: Int = 0,
) : ProtoMessage("tail")

data class ProtoDumpTable(val table: String, val suffix: String = "") : ProtoMessage("dumpTable")

data class ProtoWrite(val table: String) : ProtoMessage("write")

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

sealed interface Conn {
  fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn
  fun handleMessage(message: String, channel: WebSocketChannel) =
      handleMessage(parse(message), channel)

  fun close(): Conn
}

class EstablishedConn(val dbPath: String, val proc: Process, val authenticatedAt: Long) : Conn {
  private fun unexpectedMsg(channel: WebSocketChannel): Conn {
    if (channel.isOpen()) {
      WebSockets.sendCloseBlocking(1002, "unexpected request on established connection", channel)
      channel.close()
    }

    return ErroredConn()
  }

  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    when (request) {
      is ProtoAuth -> return unexpectedMsg(channel)
      is ProtoQuery -> return unexpectedMsg(channel)
      is ProtoDumpTable -> return unexpectedMsg(channel)
      is ProtoTail -> return unexpectedMsg(channel)
      is ProtoWrite -> return unexpectedMsg(channel)
      is ProtoData -> {
        val stdin = proc.outputStream
        if (stdin == null) {
          throw RuntimeException("data received on a connection without a process setup")
        }
        // stream data to the process attached to this channel
        val writer = stdin.bufferedWriter()
        writer.write(request.data)
        writer.flush()
        return this
      }
    }
  }

  override fun close(): Conn {
    this.proc.outputStream?.close()
    return ClosedConn()
  }
}

class AuthenticatedConn(val dbPath: String, val accessKey: String, val authenticatedAt: Long) :
    Conn {
  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    when (request) {
      is ProtoQuery -> {
        val format =
            when (request.format) {
              "csv" -> OutputFormat.CSV
              "json" -> OutputFormat.JSON
              else -> OutputFormat.CSV
            }
        val result = Skdb(dbPath).sql(request.query, format)
        val payload = serialise(ProtoData(result))
        WebSockets.sendTextBlocking(payload, channel)
        channel.sendClose()
        channel.close()
        return ClosedConn()
      }
      is ProtoDumpTable -> {
        val result = Skdb(dbPath).dumpTable(request.table, request.suffix)
        val payload = serialise(ProtoData(result))
        WebSockets.sendTextBlocking(payload, channel)
        channel.sendClose()
        channel.close()
        return ClosedConn()
      }
      is ProtoTail -> {
        val proc =
            Skdb(dbPath)
                .tail(
                    accessKey,
                    request.table,
                    request.since,
                    {
                      if (channel.isOpen()) {
                        val payload = serialise(ProtoData(it))
                        WebSockets.sendTextBlocking(payload, channel)
                      }
                    },
                    {
                      if (channel.isOpen()) {
                        WebSockets.sendCloseBlocking(1011, "unexpected eof", channel)
                        channel.close()
                      }
                    },
                )
        return EstablishedConn(dbPath, proc, authenticatedAt)
      }
      is ProtoWrite -> {
        val proc =
            Skdb(dbPath)
                .writeCsv(
                    accessKey,
                    request.table,
                    {
                      if (channel.isOpen()) {
                        val payload = serialise(ProtoData(it))
                        WebSockets.sendTextBlocking(payload, channel)
                      }
                    },
                    {
                      if (channel.isOpen()) {
                        WebSockets.sendCloseBlocking(1011, "unexpected eof", channel)
                        channel.close()
                      }
                    })
        return EstablishedConn(dbPath, proc, authenticatedAt)
      }
      is ProtoAuth -> {
        WebSockets.sendCloseBlocking(1002, "unexpected re-auth on established connection", channel)
        channel.close()
        return ErroredConn()
      }
      is ProtoData -> {
        WebSockets.sendCloseBlocking(1002, "unexpected request on established connection", channel)
        channel.close()
        return ErroredConn()
      }
    }
  }

  override fun close(): Conn {
    return ClosedConn()
  }
}

class UnauthenticatedConn(val dbPath: String) : Conn {
  private fun unexpectedMsg(channel: WebSocketChannel): Conn {
    if (channel.isOpen()) {
      WebSockets.sendCloseBlocking(1002, "connection not yet authenticated", channel)
      channel.close()
    }

    return ErroredConn()
  }

  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    when (request) {
      is ProtoQuery -> return unexpectedMsg(channel)
      is ProtoDumpTable -> return unexpectedMsg(channel)
      is ProtoTail -> return unexpectedMsg(channel)
      is ProtoWrite -> return unexpectedMsg(channel)
      is ProtoData -> return unexpectedMsg(channel)
      is ProtoAuth -> {
        return AuthenticatedConn(dbPath, request.accessKey, System.currentTimeMillis())
      }
    }
  }

  override fun close(): Conn {
    return this
  }
}

class ErroredConn() : Conn {
  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    return this
  }

  override fun close(): Conn {
    return this
  }
}

class ClosedConn() : Conn {
  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    return this
  }

  override fun close(): Conn {
    return this
  }
}

fun resolveDbPath(db: String?): String? {
  if (db == null) {
    return null
  }

  val path = "/var/db/${db}.db"
  return if (File(path).exists()) path else null
}

fun createHttpServer(): Undertow {
  val rootHandler =
      Handlers.path()
          .addPrefixPath("/", Handlers.resource(FileResourceManager(File("/skfs/build/"))))

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
                      val pathParams =
                          exchange.getAttachment(PathTemplateMatch.ATTACHMENT_KEY).getParameters()
                      val db = pathParams["database"]
                      val dbPath = resolveDbPath(db)

                      if (dbPath == null) {
                        // 1011 is internal error
                        WebSockets.sendCloseBlocking(1011, "resource not found", channel)
                        channel.close()
                        return
                      }

                      var conn: Conn = UnauthenticatedConn(dbPath)

                      channel.receiveSetter.set(
                          object : AbstractReceiveListener() {
                            override fun onFullTextMessage(
                                channel: WebSocketChannel,
                                message: BufferedTextMessage
                            ) {
                              try {
                                conn = conn.handleMessage(message.data, channel)
                              } catch (ex: Exception) {
                                // 1011 is internal error
                                WebSockets.sendCloseBlocking(1011, ex.message, channel)
                                channel.close()
                              }
                            }
                          })

                      channel.closeSetter.set(
                          object : ChannelListener<Channel> {
                            override fun handleEvent(channel: Channel): Unit {
                              conn = conn.close()
                              // TODO: wait and ensure the process ends, forcibly close on
                              // timeout
                            }
                          })

                      channel.resumeReceives()
                    }
                  }))

  var server = Undertow.builder().addHttpListener(8080, "0.0.0.0").setHandler(pathHandler).build()
  return server
}

fun main() {
  var server = createHttpServer()
  server.start()
}
