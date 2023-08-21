package io.skiplabs.skgw

import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.util.PathTemplateMatch
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.io.BufferedOutputStream
import java.io.File
import java.io.OutputStream
import java.nio.ByteBuffer
import java.security.SecureRandom
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import kotlin.system.exitProcess

val DB_ROOT_USER = "root"
val SERVICE_MGMT_DB_NAME = "skdb_service_mgmt"

fun Credentials.toProtoCredentials(): ProtoCredentials {
  return ProtoCredentials(accessKey, ByteBuffer.wrap(privateKey))
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
  val creds = genCredentials(DB_ROOT_USER, encryption)
  createSkdb(dbName, creds.b64encryptedKey())
  return creds
}

sealed interface StreamHandler {

  fun handleMessage(request: ProtoMessage, stream: OrchestrationStream): StreamHandler
  fun handleMessage(message: ByteBuffer, stream: OrchestrationStream) =
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

  override fun handleMessage(request: ProtoMessage, stream: OrchestrationStream): StreamHandler {
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

  override fun handleMessage(request: ProtoMessage, stream: OrchestrationStream): StreamHandler {
    when (request) {
      is ProtoQuery -> {
        // only db root may run queries on the server - queries are
        // always run as root. privacy is applied at replication time
        if (accessKey != DB_ROOT_USER) {
          stream.error(2002u, "Authorization error")
          return this
        }
        val format =
            when (request.format) {
              QueryResponseFormat.CSV -> OutputFormat.CSV
              QueryResponseFormat.JSON -> OutputFormat.JSON
              QueryResponseFormat.RAW -> OutputFormat.RAW
            }
        val result = skdb.sql(request.query, format)
        if (result.exitSuccessfully()) {
          stream.send(ProtoData(ByteBuffer.wrap(result.output), finFlagSet = true))
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
          stream.send(ProtoData(ByteBuffer.wrap(result.output), finFlagSet = true))
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
        val payload = creds.toProtoCredentials()
        stream.send(payload)
        creds.clear()
        stream.close()
      }
      is ProtoCreateUser -> {
        // only db root may create users
        if (accessKey != DB_ROOT_USER) {
          stream.error(2002u, "Authorization error")
          return this
        }
        val creds = genCredentials(genAccessKey(), encryption)
        skdb.createUser(creds.accessKey, creds.b64encryptedKey())
        val payload = creds.toProtoCredentials()
        stream.send(payload)
        creds.clear()
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
                { data, shouldFlush -> stream.send(ProtoData(data, shouldFlush)) },
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
                { data, shouldFlush -> stream.send(ProtoData(data, shouldFlush)) },
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

class PolicyLinkedOrchestrationStream(
    val policy: ServerPolicy,
    val db: String,
    override val stream: Stream
) : OrchestrationStream {

  override fun close() {
    stream.close()
  }

  override fun error(errorCode: UInt, msg: String) {
    stream.error(errorCode, msg)
  }

  override fun send(msg: ProtoMessage) {
    if (policy.shouldEmitMessage(msg, this, db)) {
      stream.send(encodeProtoMsg(msg))
    }
  }
}

class PolicyLinkedHandler(val policy: ServerPolicy, val db: String, var decorated: StreamHandler) :
    StreamHandler {

  override fun handleMessage(request: ProtoMessage, stream: OrchestrationStream): StreamHandler {
    if (policy.shouldDeliverMessage(request, stream, db)) {
      decorated = decorated.handleMessage(request, stream)
    }
    return this
  }

  override fun close() {
    decorated.close()
  }
}

data class RevealableException(val code: UInt, val msg: String) : RuntimeException(msg)

fun connectionHandler(
    policy: ServerPolicy,
    taskPool: ScheduledExecutorService,
    encryption: EncryptionTransform,
    logger: Logger,
): HttpHandler {
  return Handlers.websocket(
      MuxedSocketEndpoint(
          object : MuxedSocketFactory {
            override fun onConnect(
                exchange: WebSocketHttpExchange,
                channel: WebSocket
            ): MuxedSocket {
              val pathParams =
                  exchange.getAttachment(PathTemplateMatch.ATTACHMENT_KEY).getParameters()
              val db = pathParams["database"]

              if (db == null || !policy.shouldAcceptConnection(db)) {
                val socket =
                    MuxedSocket(
                        channel = channel,
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
                      channel = channel,
                      taskPool = taskPool,
                      onStream = { _, stream ->
                        var handler: StreamHandler =
                            PolicyLinkedHandler(
                                policy,
                                db,
                                RequestHandler(
                                    skdb!!,
                                    accessKey!!,
                                    encryption,
                                    replicationId!!,
                                ))
                        var orchestrationStream =
                            PolicyLinkedOrchestrationStream(policy, db, stream)

                        // use observation rather than callbacks so
                        // that we also close the handler if _we_
                        // close the stream
                        stream.observeLifecycle { state ->
                          when (state) {
                            Stream.State.CLOSED -> handler.close()
                            else -> Unit
                          }
                        }

                        stream.onData = { data ->
                          try {
                            handler = handler.handleMessage(data, orchestrationStream)
                          } catch (ex: RevealableException) {
                            System.err.println("Exception occurred: ${ex}")
                            stream.error(ex.code, ex.msg)
                          } catch (ex: Exception) {
                            System.err.println("Exception occurred: ${ex}")
                            stream.error(2000u, "Internal error")
                          }
                        }
                        stream.onClose = { stream.close() }
                        stream.onError = { _, _ -> }
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
                      log = { event, user, metadata -> logger.log(db, event, user, metadata) })

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
  try {
    val svcSkdb = openSkdb(SERVICE_MGMT_DB_NAME)

    if (svcSkdb == null) {
      System.err.println("FAIL: Could not open service management database.")
      return false
    }

    val successfullyRead =
        svcSkdb
            .sql(
                "SELECT COUNT(*) FROM skdb_users WHERE username = '${DB_ROOT_USER}';",
                OutputFormat.RAW)
            .decodeOrThrow()
            .trim() == "1"

    if (!successfullyRead) {
      System.err.println("FAIL: Could not read from service management database.")
    }

    return successfullyRead
  } catch (ex: Exception) {
    System.err.println("Caught ${ex} while checking env")
    return false
  }
}

private fun createServiceMgmtDb(encryption: EncryptionTransform) {
  val creds = createDb(SERVICE_MGMT_DB_NAME, encryption)
  System.err.println(
      "{\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.b64privateKey()}\"}}")
}

private fun devColdStart(encryption: EncryptionTransform) {
  System.err.println("Environment checks failed, cold starting the system because of dev flag")
  val path = resolveDbPath(SERVICE_MGMT_DB_NAME)
  val removed = File(path).delete()
  if (removed) {
    System.err.println("Removed ${path}")
  }
  val creds = createDb(SERVICE_MGMT_DB_NAME, encryption)
  System.err.println(
      "{\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.b64privateKey()}\"}}")
  val command =
      listOf(
          "/bin/bash",
          "-c",
          "cd /skfs/sql/js && npx skdb-cli --add-cred --host ws://localhost:8080" +
              " --db ${SERVICE_MGMT_DB_NAME} --access-key ${creds.accessKey}" +
              " <<< \"${creds.b64privateKey()}\"")
  val proc = ProcessBuilder().inheritIO().command(command).start()
  val status = proc.waitFor()
  if (status != 0) {
    System.err.println("add-cred failed")
    exitProcess(status)
  }
}

fun main(args: Array<String>) {
  val arglist = args.toList()

  var encryption = ec2KmsEncryptionTransform()

  if (arglist.contains("--DANGEROUS-no-encryption")) {
    encryption = NoEncryptionTransform()
  }

  if (arglist.contains("--init")) {
    createServiceMgmtDb(encryption)
    return
  }

  if (!envIsSane()) {
    if (!arglist.contains("--dev")) {
      System.err.println("Environment checks failed. Use --init for a cold start.")
      exitProcess(1)
    }

    devColdStart(encryption)
  }

  val taskPool = Executors.newSingleThreadScheduledExecutor()

  val config = Config()
  val logger = SkdbBackedLogger()
  val policy =
      EventAccountant(logger) then
          RejectUnsupportedClients(
              logger,
              config.getString("min_js_client", "0.0.41"),
              config.getString("min_kt_client", "0.0.1")) then
          ThrottleDataTransferPerConnection(
              logger, config.getInt("max_conn_byte_rate", 100 * 1024 * 1024), taskPool) then
          RateLimitRequestsPerConnection(
              logger,
              config.getDouble("max_conn_qps", 20.0),
              config.getInt("max_conn_req_spike", 50)) then
          LimitConnectionsPerUser(logger, config.getInt("user_conns", 5)) then
          LimitConnectionsPerDb(logger, config.getInt("db_conns", 10)) then
          LimitGlobalConnections(logger, config.getInt("global_conns", 10_000))

  val connHandler = connectionHandler(policy, taskPool, encryption, logger)

  val server = createHttpServer(connHandler)
  server.start()
}
