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

data class ProtoTail(
    val table: String,
    val user: String,
    val password: String,
    val since: Int = 0,
) : ProtoMessage("tail")

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
      channel.sendClose()
      channel.close()
    }
    is ProtoDumpTable -> {
      val result = Skdb(state.dbPath).dumpTable(req.table, req.suffix)
      val payload = serialise(ProtoData(result))
      WebSockets.sendTextBlocking(payload, channel)
      channel.sendClose()
      channel.close()
    }
    is ProtoTail -> {
      val proc =
          Skdb(state.dbPath)
              .tail(
                  req.user,
                  req.password,
                  req.table,
                  req.since,
                  {
                    if (channel.isOpen()) {
                        val payload = serialise(ProtoData(it))
                        WebSockets.sendTextBlocking(payload, channel)
                    }
                  },
                  {
                    if (channel.isOpen()) {
                      WebSockets.sendCloseBlocking(1011, "unexpected eof", channel)
                    }
                  },
              )
      state.proc = proc
    }
    is ProtoWrite -> {
      val proc =
          Skdb(state.dbPath)
              .writeCsv(
                  req.user,
                  req.password,
                  req.table,
                  {
                    if (channel.isOpen()) {
                        val payload = serialise(ProtoData(it))
                        WebSockets.sendTextBlocking(payload, channel)
                    }
                  },
                  {
                    if (channel.isOpen()) {
                      WebSockets.sendCloseBlocking(1011, "unexpected eof", channel)
                    }
                  })
      state.proc = proc
    }
    is ProtoData -> {
      val stdin = state.proc?.outputStream
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

data class ChannelState(var proc: Process?, val dbPath: String)

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
                        return
                      }

                      // TODO: should harvest the user/auth, and
                      // database here. these are
                      // connection-specific properties

                      val state = ChannelState(proc = null, dbPath)

                      channel.receiveSetter.set(
                          object : AbstractReceiveListener() {
                            override fun onFullTextMessage(
                                channel: WebSocketChannel,
                                message: BufferedTextMessage
                            ) {
                              try {
                                handleRequest(message.data, channel, state)
                              } catch (ex: Exception) {
                                // 1011 is internal error
                                WebSockets.sendCloseBlocking(1011, ex.message, channel)
                              }
                            }
                          })

                      channel.closeSetter.set(
                          object : ChannelListener<Channel> {
                            override fun handleEvent(channel: Channel): Unit {
                              state.proc?.outputStream?.close()
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
