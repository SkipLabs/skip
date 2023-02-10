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
import java.time.Duration
import java.time.Instant
import java.util.Base64
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
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

val maxConnectionDuration: Duration = Duration.ofMinutes(10)

sealed interface Conn {

  fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn
  fun handleMessage(message: String, channel: WebSocketChannel) =
      handleMessage(parse(message), channel)

  fun close(): Conn
}

class EstablishedConn(val proc: Process, val authenticatedAt: Instant) : Conn {

  private fun unexpectedMsg(channel: WebSocketChannel): Conn {
    if (channel.isOpen()) {
      WebSockets.sendCloseBlocking(1002, "unexpected request on established connection", channel)
      channel.close()
    }

    return ErroredConn()
  }

  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    val now = Instant.now()
    if (Duration.between(authenticatedAt, now).abs().compareTo(maxConnectionDuration) > 0) {
      WebSockets.sendCloseBlocking(1011, "session timeout", channel)
      channel.close()
      return ErroredConn()
    }

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

class AuthenticatedConn(val skdb: Skdb, val accessKey: String, val authenticatedAt: Instant) :
    Conn {

  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    val now = Instant.now()
    if (Duration.between(authenticatedAt, now).abs().compareTo(maxConnectionDuration) > 0) {
      WebSockets.sendCloseBlocking(1011, "session timeout", channel)
      channel.close()
      return ErroredConn()
    }

    when (request) {
      is ProtoQuery -> {
        val format =
            when (request.format) {
              "csv" -> OutputFormat.CSV
              "json" -> OutputFormat.JSON
              else -> OutputFormat.CSV
            }
        val result = skdb.sql(request.query, format)
        val payload = serialise(ProtoData(result))
        WebSockets.sendTextBlocking(payload, channel)
        channel.sendClose()
        channel.close()
        return ClosedConn()
      }
      is ProtoDumpTable -> {
        val result = skdb.dumpTable(request.table, request.suffix)
        val payload = serialise(ProtoData(result))
        WebSockets.sendTextBlocking(payload, channel)
        channel.sendClose()
        channel.close()
        return ClosedConn()
      }
      is ProtoTail -> {
        val proc =
            skdb.tail(
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
        return EstablishedConn(proc, authenticatedAt)
      }
      is ProtoWrite -> {
        val proc =
            skdb.writeCsv(
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
        return EstablishedConn(proc, authenticatedAt)
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

class UnauthenticatedConn(val skdb: Skdb) : Conn {

  private fun unexpectedMsg(channel: WebSocketChannel): Conn {
    if (channel.isOpen()) {
      WebSockets.sendCloseBlocking(1002, "connection not yet authenticated", channel)
      channel.close()
    }

    return ErroredConn()
  }

  private fun verify(request: ProtoAuth): Boolean {
    val algo = "HmacSHA256"

    val now = Instant.now()
    val d = Instant.parse(request.date)
    // delta represents physical timeline time, regardless of calendars and clock shifts
    val delta = Duration.between(d, now)

    // do not allow requests that were not recent. the margin is for clock skew.
    if (delta.abs().compareTo(Duration.ofMinutes(10)) > 0) {
      return false
    }

    val content: String = request.request + request.accessKey + request.date
    val contentBytes = content.toByteArray(Charsets.UTF_8)

    val mac = Mac.getInstance(algo)
    val privateKey = skdb.privateKeyAsStored(request.accessKey)
    mac.init(SecretKeySpec(privateKey, algo))
    val ourSig = mac.doFinal(contentBytes)
    // at least try to keep the private key in memory for as little time as possible
    privateKey.fill(0)

    val b64sig = Base64.getEncoder().encodeToString(ourSig)

    return b64sig == request.signature
  }

  override fun handleMessage(request: ProtoMessage, channel: WebSocketChannel): Conn {
    when (request) {
      is ProtoQuery -> return unexpectedMsg(channel)
      is ProtoDumpTable -> return unexpectedMsg(channel)
      is ProtoTail -> return unexpectedMsg(channel)
      is ProtoWrite -> return unexpectedMsg(channel)
      is ProtoData -> return unexpectedMsg(channel)
      is ProtoAuth -> {
        if (!verify(request)) {
          if (channel.isOpen()) {
            WebSockets.sendCloseBlocking(1002, "authentication failed", channel)
            channel.close()
          }

          return ErroredConn()
        }

        return AuthenticatedConn(skdb, request.accessKey, Instant.now())
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

  val taskPool = Executors.newSingleThreadScheduledExecutor()

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

                      val skdb = Skdb(dbPath)

                      var conn: Conn = UnauthenticatedConn(skdb)

                      val timeout = taskPool.schedule({
                          conn.close()
                          channel.close()
                      }, 10, TimeUnit.MINUTES)

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
                              timeout.cancel(false)
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
