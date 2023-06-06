package io.skiplabs.skgw

import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.util.PathTemplateMatch
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.io.BufferedOutputStream
import java.io.OutputStream
import java.nio.ByteBuffer
import java.security.SecureRandom
import java.util.Base64
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import kotlin.system.exitProcess

val SERVICE_MGMT_DB_NAME = "skdb_service_mgmt"

data class Credentials(
    val accessKey: String,
    val privateKey: ByteArray,
    val encryptedPrivateKey: ByteArray
) {
  fun b64privateKey(): String = Base64.getEncoder().encodeToString(privateKey)
  fun b64encryptedKey(): String = Base64.getEncoder().encodeToString(encryptedPrivateKey)
  fun clear(): Unit {
    privateKey.fill(0)
    encryptedPrivateKey.fill(0)
  }
  fun toProtoCredentials(): ProtoCredentials {
    return ProtoCredentials(accessKey, ByteBuffer.wrap(privateKey))
  }
  override fun toString(): String {
    return "Credentials(accessKey=${accessKey}, privateKey=**redacted**)"
  }
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

fun createDb(dbName: String, encryption: EncryptionTransform): Credentials {
  val creds = genCredentials("root", encryption)
  createSkdb(dbName, creds.b64encryptedKey())
  return creds
}

sealed interface StreamHandler {

  fun handleMessage(request: ProtoMessage, stream: Stream): StreamHandler
  fun handleMessage(message: ByteBuffer, stream: Stream) =
      handleMessage(decodeProtoMsg(message), stream)

  fun close() {}
}

class ProcessPipe(val proc: Process) : StreamHandler {

  private val stdin: OutputStream

  init {
    val stdin = proc.outputStream
    if (stdin == null) {
      throw RuntimeException("creating a pipe to a process that does not accept input")
    }
    this.stdin = BufferedOutputStream(stdin)
  }

  override fun handleMessage(request: ProtoMessage, stream: Stream): StreamHandler {
    when (request) {
      is ProtoData -> {
        val data = request.data
        stdin.write(data.array(), data.arrayOffset() + data.position(), data.remaining())
        if (request.finFlagSet) {
          stdin.flush()
        }
      }
      else -> {
        close()
        stream.error(2001u, "unexpected request on established connection")
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
              QueryResponseFormat.CSV -> OutputFormat.CSV
              QueryResponseFormat.JSON -> OutputFormat.JSON
              QueryResponseFormat.RAW -> OutputFormat.RAW
            }
        val result = skdb.sql(request.query, format)
        if (result.exitSuccessfully()) {
          val payload = encodeProtoMsg(ProtoData(ByteBuffer.wrap(result.output), finFlagSet = true))
          stream.send(payload)
          stream.close()
        } else {
          stream.error(2000u, result.decode())
        }
      }
      is ProtoSchemaQuery -> {
        val result =
            when (request.scope) {
              SchemaScope.ALL -> skdb.dumpSchema()
              SchemaScope.TABLE -> skdb.dumpTable(request.name!!)
              SchemaScope.VIEW -> skdb.dumpView(request.name!!)
            }
        if (result.exitSuccessfully()) {
          val payload = encodeProtoMsg(ProtoData(ByteBuffer.wrap(result.output), finFlagSet = true))
          stream.send(payload)
          stream.close()
        } else {
          stream.error(2000u, result.decode())
        }
      }
      is ProtoCreateDb -> {
        // this side effect is only authorized if you're connected as a service mgmt db user
        if (skdb.name != SERVICE_MGMT_DB_NAME) {
          stream.error(2002u, "Authorization error")
          return this
        }
        val creds = createDb(request.name, encryption)
        val payload = encodeProtoMsg(creds.toProtoCredentials())
        creds.clear()
        stream.send(payload)
        stream.close()
      }
      is ProtoCreateUser -> {
        val creds = genCredentials(genAccessKey(), encryption)
        skdb.createUser(creds.accessKey, creds.b64encryptedKey())
        val payload = encodeProtoMsg(creds.toProtoCredentials())
        creds.clear()
        stream.send(payload)
        stream.close()
      }
      is ProtoRequestTail -> {
        val proc =
            skdb.tail(
                accessKey,
                request.table,
                request.since,
                request.filterExpr,
                replicationId,
                { data, shouldFlush -> stream.send(encodeProtoMsg(ProtoData(data, shouldFlush))) },
                { stream.error(2000u, "Unexpected EOF") },
            )
        return ProcessPipe(proc)
      }
      is ProtoPushPromise -> {
        val proc =
            skdb.writeCsv(
                accessKey,
                request.table,
                replicationId,
                { data, shouldFlush -> stream.send(encodeProtoMsg(ProtoData(data, shouldFlush))) },
                { stream.error(2000u, "Unexpected EOF") })
        return ProcessPipe(proc)
      }
      is ProtoData -> {
        stream.error(2001u, "unexpected data on non-established connection")
      }
      else -> stream.error(2001u, "unexpected message")
    }
    return this
  }
}

data class RevealableException(val code: UInt, val msg: String) : RuntimeException(msg)

fun connectionHandler(
    policy: ServerPolicy,
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

              if (db == null || !policy.shouldAcceptConnection(db)) {
                val socket =
                    MuxedSocket(
                        socket = channel,
                        taskPool = taskPool,
                        onStream = { _, _ -> },
                        onClose = {},
                        onError = { _, _, _ -> },
                        getDecryptedKey = { _ -> ByteArray(0) },
                    )
                socket.errorSocket(2000u, "Service unavailable")
                return socket
              }

              val skdb = openSkdb(db)

              var replicationId: String? = null
              var accessKey: String? = null

              val socket =
                  MuxedSocket(
                      socket = channel,
                      taskPool = taskPool,
                      onStream = { _, stream ->
                        var handler: StreamHandler =
                            RequestHandler(
                                skdb!!,
                                accessKey!!,
                                encryption,
                                replicationId!!,
                            )
                        stream.onData = { data ->
                          try {
                            handler = handler.handleMessage(data, stream)
                          } catch (ex: RevealableException) {
                            System.err.println("Exception occurred: ${ex}")
                            stream.error(ex.code, ex.msg)
                          } catch (ex: Exception) {
                            System.err.println("Exception occurred: ${ex}")
                            stream.error(2000u, "Internal error")
                          }
                        }
                        stream.onClose = {
                          handler.close()
                          stream.close()
                        }
                        stream.onError = { _, _ -> handler.close() }
                      },
                      onClose = { socket -> socket.closeSocket() },
                      onError = { _, _, _ -> },
                      getDecryptedKey = { authMsg ->
                        accessKey = authMsg.accessKey
                        replicationId =
                            skdb?.replicationId(authMsg.deviceUuid)?.decodeOrThrow()?.trim()
                        val encryptedPrivateKey = skdb?.privateKeyAsStored(authMsg.accessKey)
                        encryption.decrypt(encryptedPrivateKey!!)
                      },
                  )

              if (skdb == null) {
                socket.errorSocket(1004u, "Could not open database")
              }

              policy.notifySocketCreated(socket, db)

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
          .decodeOrThrow()
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
    System.err.println(
        "{\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.b64privateKey()}\"}}")
    return
  }

  if (!envIsSane()) {
    System.err.println("Environment checks failed. Use --init for a cold start.")
    exitProcess(1)
  }

  val taskPool = Executors.newSingleThreadScheduledExecutor()

  val policy = NullServerPolicy()
  val connHandler = connectionHandler(policy, taskPool, encryption)

  val server = createHttpServer(connHandler)
  server.start()
}
