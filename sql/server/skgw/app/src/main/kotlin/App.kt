package io.skiplabs.skgw

import com.beust.klaxon.Klaxon
import com.beust.klaxon.TypeAdapter
import com.beust.klaxon.TypeFor
import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.util.PathTemplateMatch
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.WebSockets
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets
import java.security.SecureRandom
import java.util.Base64
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import kotlin.io.bufferedWriter
import kotlin.reflect.KClass
import kotlin.system.exitProcess

val SERVICE_MGMT_DB_NAME = "skdb_service_mgmt"

class ProtoTypeAdapter : TypeAdapter<ProtoMessage> {
  override fun classFor(type: Any): KClass<out ProtoMessage> =
      when (type as String) {
        "auth" -> ProtoAuth::class
        "query" -> ProtoQuery::class
        "tail" -> ProtoTail::class
        "schema" -> ProtoSchemaQuery::class
        "write" -> ProtoWrite::class
        "pipe" -> ProtoData::class
        "createDatabase" -> ProtoCreateDb::class
        "credentials" -> ProtoCredentials::class
        "createUser" -> ProtoCreateUser::class
        else -> throw IllegalArgumentException("Unknown request type: $type")
      }
}

@TypeFor(field = "request", adapter = ProtoTypeAdapter::class)
sealed class ProtoMessage(val request: String)

data class ProtoAuth(
    val accessKey: String,
    val date: String,
    val nonce: String,
    val signature: String,
    val deviceUuid: String,
) : ProtoMessage("auth")

data class ProtoQuery(val query: String, val format: String = "csv") : ProtoMessage("query")

data class ProtoTail(
    val table: String,
    val since: Int = 0,
) : ProtoMessage("tail")

data class ProtoSchemaQuery(
    val table: String? = null,
    val view: String? = null,
    val suffix: String = ""
) : ProtoMessage("schema")

data class ProtoWrite(val table: String) : ProtoMessage("write")

data class ProtoCreateDb(val name: String) : ProtoMessage("createDatabase")

class ProtoCreateUser() : ProtoMessage("createUser")

data class ProtoData(val data: String) : ProtoMessage("pipe")

data class ProtoError(val code: String, val msg: String, val retryable: Boolean) :
    ProtoMessage("error")

data class ProtoCredentials(val accessKey: String, val privateKey: String) :
    ProtoMessage("credentials") {

  override fun toString(): String {
    return "ProtoCredentials(accessKey=${accessKey}, privateKey=**redacted**)"
  }
}

data class Credentials(
    val accessKey: String,
    val privateKey: ByteArray,
    val encryptedPrivateKey: ByteArray
) {
  fun b64plaintextKey(): String = Base64.getEncoder().encodeToString(privateKey)
  fun b64encryptedKey(): String = Base64.getEncoder().encodeToString(encryptedPrivateKey)
  fun clear(): Unit {
    privateKey.fill(0)
    encryptedPrivateKey.fill(0)
  }
  fun toProtoCredentials(): ProtoCredentials {
    return ProtoCredentials(accessKey, b64plaintextKey())
  }
  override fun toString(): String {
    return "Credentials(accessKey=${accessKey}, privateKey=**redacted**)"
  }
}

fun parse(data: ByteBuffer): ProtoMessage {
  val msg = Klaxon().parse<ProtoMessage>(StandardCharsets.UTF_8.decode(data).toString())
  if (msg == null) {
    throw RuntimeException("could not parse message")
  }
  return msg
}

fun serialise(msg: ProtoMessage): ByteBuffer {
  val jsonStr = Klaxon().toJsonString(msg)
  val buf = ByteBuffer.allocate(16 + jsonStr.length * 3)
  val encoder = StandardCharsets.UTF_8.newEncoder()
  var res = encoder.encode(CharBuffer.wrap(jsonStr), buf, true)
  if (!res.isUnderflow()) {
    res.throwException()
  }
  res = encoder.flush(buf)
  if (!res.isUnderflow()) {
    res.throwException()
  }
  return buf.flip()
}

fun genAccessKey(): String {
  val csrng = SecureRandom()
  val keyLength = 20
  // build a string of keyLength chars: 0-9a-zA-Z, which is 62 symbols
  val ints = csrng.ints(keyLength.toLong(), 0, 62)
  val codePoints =
      ints
          .map({
            when {
              it < 10 -> it + 48 // offset for 0-9
              it < 10 + 26 -> (it - 10) + 65 // offset for A-Z
              else -> (it - 10 - 26) + 97 // offset for a-z
            }
          })
          .toArray()
  return String(codePoints, 0, keyLength)
}

fun genCredentials(accessKey: String, encryption: EncryptionTransform): Credentials {
  val csrng = SecureRandom()

  // generate a 256 bit random key for the root user
  val plaintextRootKey = ByteArray(32)
  csrng.nextBytes(plaintextRootKey)
  val encryptedRootKey = encryption.encrypt(plaintextRootKey)
  val creds = Credentials(accessKey, plaintextRootKey, encryptedRootKey)

  return creds
}

fun createDb(dbName: String, encryption: EncryptionTransform): ProtoCredentials {
  val creds = genCredentials("root", encryption)
  createSkdb(dbName, creds.b64encryptedKey())
  val protoCreds = creds.toProtoCredentials()
  creds.clear()
  return protoCreds
}

sealed interface StreamHandler {

  fun handleMessage(request: ProtoMessage, stream: Stream): StreamHandler
  fun handleMessage(message: ByteBuffer, stream: Stream) = handleMessage(parse(message), stream)

  fun close() {}
}

class ProcessPipe(val proc: Process) : StreamHandler {

  override fun handleMessage(request: ProtoMessage, stream: Stream): StreamHandler {
    when (request) {
      is ProtoData -> {
        val stdin = proc.outputStream
        if (stdin == null) {
          throw RuntimeException("data received on a connection without a process setup")
        }
        // stream data to the process attached to this channel
        val writer = stdin.bufferedWriter()
        writer.write(request.data)
        writer.flush()
      }
      else -> {
        close()
        stream.error(10u, "unexpected request on established connection")
      }
    }

    return this
  }

  override fun close() {
    proc.outputStream?.close()
  }
}

class RequestHandler(
    val skdb: Skdb,
    val accessKey: String,
    val encryption: EncryptionTransform,
    val replicationId: String,
) : StreamHandler {

  override fun handleMessage(request: ProtoMessage, stream: Stream): StreamHandler {
    when (request) {
      is ProtoQuery -> {
        val format =
            when (request.format) {
              "csv" -> OutputFormat.CSV
              "json" -> OutputFormat.JSON
              "raw" -> OutputFormat.RAW
              else -> OutputFormat.CSV
            }
        val result = skdb.sql(request.query, format)
        val payload =
            if (result.exitSuccessfully()) {
              serialise(ProtoData(result.output))
            } else {
              serialise(ProtoError("query", result.output, true))
            }
        stream.send(payload)
        stream.close()
      }
      is ProtoSchemaQuery -> {
        val result =
            if (request.table != null) {
              skdb.dumpTable(request.table, request.suffix)
            } else if (request.view != null) {
              skdb.dumpView(request.view)
            } else {
              skdb.dumpSchema()
            }
        val payload =
            if (result.exitSuccessfully()) {
              serialise(ProtoData(result.output))
            } else {
              serialise(ProtoError("query", result.output, true))
            }
        stream.send(payload)
        stream.close()
      }
      is ProtoCreateDb -> {
        // this side effect is only authorized if you're connected as a service mgmt db user
        if (skdb.name != SERVICE_MGMT_DB_NAME) {
          stream.error(1u, "error")
          // deliberately unhelpful error
          return this
        }
        val creds = createDb(request.name, encryption)
        val payload = serialise(creds)
        stream.send(payload)
        stream.close()
      }
      is ProtoCreateUser -> {
        val creds = genCredentials(genAccessKey(), encryption)
        skdb.createUser(creds.accessKey, creds.b64encryptedKey())
        val payload = serialise(creds.toProtoCredentials())
        creds.clear()
        stream.send(payload)
        stream.close()
      }
      is ProtoTail -> {
        val proc =
            skdb.tail(
                accessKey,
                request.table,
                request.since,
                replicationId,
                {
                  val payload = serialise(ProtoData(it))
                  stream.send(payload)
                },
                { stream.error(12u, "Unexpected EOF") },
            )
        return ProcessPipe(proc)
      }
      is ProtoWrite -> {
        val proc =
            skdb.writeCsv(
                accessKey,
                request.table,
                replicationId,
                {
                  val payload = serialise(ProtoData(it))
                  stream.send(payload)
                },
                { stream.error(13u, "Unexpected EOF") })
        return ProcessPipe(proc)
      }
      is ProtoAuth -> {
        stream.error(10u, "unexpected re-auth on established connection")
      }
      is ProtoData -> {
        stream.error(10u, "unexpected data on non-established connection")
      }
      else -> stream.error(10u, "unexpected message")
    }
    return this
  }
}

fun connectionHandler(
    taskPool: ScheduledExecutorService,
    encryption: EncryptionTransform,
): HttpHandler {
  return Handlers.websocket(
      MuxedSocketEndpoint(
          object : MuxedSocketFactory {
            override fun onConnect(
                exchange: WebSocketHttpExchange,
                channel: WebSocketChannel
            ): MuxedSocket {
              val pathParams =
                  exchange.getAttachment(PathTemplateMatch.ATTACHMENT_KEY).getParameters()
              val db = pathParams["database"]
              val skdb = openSkdb(db)

              if (skdb == null) {
                // 1011 is internal error
                val msg = "Could not open database"
                WebSockets.sendTextBlocking(serialise(ProtoError("resource", msg, false)), channel)
                WebSockets.sendCloseBlocking(1011, msg, channel)
                channel.close()
                throw RuntimeException(msg)
              }

              var socket: MuxedSocket? = null

              // TODO: should this be pushed down? we probably want keep alives to prevent this too
              val timeout = taskPool.schedule({ socket?.closeSocket() }, 10, TimeUnit.MINUTES)

              val replicationId = skdb.uid().getOrThrow().trim()

              // TODO: this logic needs to be pushed down in to the mux socket
              // val maxConnectionDuration: Duration = Duration.ofMinutes(10)
              // val now = Instant.now()
              // if (Duration.between(authenticatedAt, now).abs().compareTo(maxConnectionDuration) >
              // 0) {
              //   stream.error(11u, "session timeout")
              // }
              var accessKey: String? = null

              socket =
                  MuxedSocket(
                      onStream = { _, stream ->
                        var handler: StreamHandler =
                            RequestHandler(
                                skdb,
                                accessKey!!,
                                encryption,
                                replicationId,
                            )
                        stream.onData = { data ->
                          try {
                            handler = handler.handleMessage(data, stream)
                          } catch (ex: Exception) {
                            System.err.println("Exception occurred: ${ex}")
                            stream.error(14u, "Internal error")
                          }
                        }
                        stream.onClose = { handler.close() }
                        stream.onError = { code, msg ->
                          System.err.println("Stream errored: ${code} - ${msg}")
                          handler.close()
                        }
                      },
                      onClose = { timeout.cancel(false) },
                      onError = { _, code, msg ->
                        System.err.println("Socket errored: ${code} - ${msg}")
                        timeout.cancel(false)
                      },
                      socket = channel,
                      getDecryptedKey = { key ->
                        accessKey = key
                        val encryptedPrivateKey = skdb.privateKeyAsStored(key)
                        encryption.decrypt(encryptedPrivateKey)
                      },
                  )

              return socket
            }
          }))
}

fun createHttpServer(connectionHandler: HttpHandler): Undertow {
  var pathHandler = PathTemplateHandler().add("/dbs/{database}/connection", connectionHandler)

  return Undertow.builder().addHttpListener(8080, "0.0.0.0").setHandler(pathHandler).build()
}

fun envIsSane(): Boolean {
  val svcSkdb = openSkdb(SERVICE_MGMT_DB_NAME)

  if (svcSkdb == null) {
    System.err.println("FAIL: Could not open service management database.")
    return false
  }

  val successfullyRead =
      svcSkdb
          .sql("SELECT COUNT(*) FROM skdb_users WHERE username = 'root';", OutputFormat.RAW)
          .getOrThrow()
          .trim() == "1"

  if (!successfullyRead) {
    System.err.println("FAIL: Could not read from service management database.")
  }

  return successfullyRead
}

fun main(args: Array<String>) {
  val arglist = args.toList()

  var encryption = ec2KmsEncryptionTransform()

  if (arglist.contains("--DANGEROUS-no-encryption")) {
    encryption = NoEncryptionTransform()
  }

  if (arglist.contains("--init")) {
    val creds = createDb(SERVICE_MGMT_DB_NAME, encryption)
    System.err.println("{\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.privateKey}\"}}")
    return
  }

  if (!envIsSane()) {
    System.err.println("Environment checks failed. Use --init for a cold start.")
    exitProcess(1)
  }

  val taskPool = Executors.newSingleThreadScheduledExecutor()
  val connHandler = connectionHandler(taskPool, encryption)
  val server = createHttpServer(connHandler)
  server.start()
}
