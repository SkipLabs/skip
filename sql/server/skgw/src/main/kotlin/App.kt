package io.skiplabs.skdb

import io.undertow.Handlers
import io.undertow.Undertow
import io.undertow.server.HttpHandler
import io.undertow.server.handlers.BlockingHandler
import io.undertow.server.handlers.PathTemplateHandler
import io.undertow.util.PathTemplateMatch
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.io.BufferedOutputStream
import java.io.File
import java.io.OutputStream
import java.nio.ByteBuffer
import java.security.SecureRandom
import java.util.Base64
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.atomic.AtomicReference
import kotlin.system.exitProcess

fun Credentials.toProtoCredentials(): ProtoCredentials {
  return ProtoCredentials(accessKey, ByteBuffer.wrap(privateKey))
}

fun genPrivateKey(encryption: EncryptionTransform): Pair<ByteArray, ByteArray> {
  val csrng = SecureRandom()

  // generate a 256 bit random key
  val plaintextPrivateKey = ByteArray(32)
  csrng.nextBytes(plaintextPrivateKey)
  val encryptedPrivateKey = encryption.encrypt(plaintextPrivateKey)

  return Pair(plaintextPrivateKey, encryptedPrivateKey)
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
    proc.destroy()
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
        val result = skdb.sql(request.query, format, true)
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
              SchemaScope.TABLE -> skdb.dumpTable(request.name!!, request.suffix!!)
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
        val privateKey = genPrivateKey(encryption)
        val b64encryptedKey = Base64.getEncoder().encodeToString(privateKey.second)
        val userID = skdb.createUser(b64encryptedKey)
        val creds = Credentials(userID, privateKey.first, privateKey.second)
        val payload = creds.toProtoCredentials()
        stream.send(payload)
        creds.clear()
        stream.close()
      }
      is ProtoRequestTail -> {
        val proc =
            skdb.tail(
                accessKey,
                replicationId,
                mapOf(
                    request.table to
                        TailSpec(
                            request.since.toInt(), request.filterExpr ?: "", request.filterParams)),
                { data, shouldFlush -> stream.send(ProtoData(data, shouldFlush)) },
                { stream.error(2000u, "Unexpected EOF") },
            )
        return ProcessPipe(proc)
      }
      is ProtoRequestTailBatch -> {
        val spec = HashMap<String, TailSpec>()
        for (tailreq in request.requests) {
          spec.put(
              tailreq.table,
              TailSpec(tailreq.since.toInt(), tailreq.filterExpr ?: "", tailreq.filterParams))
        }
        val proc =
            skdb.tail(
                accessKey,
                replicationId,
                spec,
                { data, shouldFlush -> stream.send(ProtoData(data, shouldFlush)) },
                { stream.error(2000u, "Unexpected EOF") },
            )
        return ProcessPipe(proc)
      }
      is ProtoPushPromise -> {
        val proc =
            skdb.writeCsv(
                accessKey,
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

fun connectionHandler(
    policy: ServerPolicy,
    workerPool: ExecutorService,
    taskPool: ScheduledExecutorService,
    encryption: EncryptionTransform,
    logger: Logger,
): HttpHandler {
  return BlockingHandler(
      Handlers.websocket(
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
                            var handler: AtomicReference<StreamHandler> =
                                AtomicReference(
                                    PolicyLinkedHandler(
                                        policy,
                                        db,
                                        RequestHandler(
                                            skdb!!,
                                            accessKey!!,
                                            encryption,
                                            replicationId!!,
                                        )))
                            var orchestrationStream =
                                PolicyLinkedOrchestrationStream(policy, db, stream)

                            // use observation rather than callbacks so
                            // that we also close the handler if _we_
                            // close the stream
                            stream.observeLifecycle { state ->
                              when (state) {
                                Stream.State.CLOSED -> handler.get().close()
                                else -> Unit
                              }
                            }

                            stream.onData = { data ->
                              workerPool.execute {
                                try {
                                  handler.set(
                                      handler.get().handleMessage(data, orchestrationStream))
                                } catch (ex: RevealableException) {
                                  System.err.println("Exception occurred: ${ex}")
                                  stream.error(ex.code, ex.msg)
                                } catch (ex: Exception) {
                                  System.err.println("Exception occurred: ${ex}")
                                  stream.error(2000u, "Internal error")
                                }
                              }
                            }
                            stream.onClose = {
                              // must happen on the sharded worker to ensure ordering
                              workerPool.execute { stream.close() }
                            }
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
              })))
}

fun createHttpServer(connectionHandler: HttpHandler): Undertow {
  var pathHandler = PathTemplateHandler().add("/dbs/{database}/connection", connectionHandler)
  return Undertow.builder().addHttpListener(ENV.port, "0.0.0.0").setHandler(pathHandler).build()
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
                "SELECT COUNT(*) FROM skdb_users WHERE userID = '${DB_ROOT_USER}';",
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
      "skdb.credentials={\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.b64privateKey()}\"}}")
}

private fun devColdStart(encryption: EncryptionTransform) {
  System.err.println("Environment checks failed, cold starting the system because of dev flag")
  val path = ENV.resolveDbPath(SERVICE_MGMT_DB_NAME)
  val removed = File(path).delete()
  if (removed) {
    System.err.println("Removed ${path}")
  }
  val creds = createDb(SERVICE_MGMT_DB_NAME, encryption)
  System.err.println(
      "skdb.credentials={\"${SERVICE_MGMT_DB_NAME}\": {\"${creds.accessKey}\": \"${creds.b64privateKey()}\"}}")

  val command =
      listOf(
          "/bin/bash",
          "-c",
          String.format(
              ENV.addCredFormat,
              ENV.port,
              SERVICE_MGMT_DB_NAME,
              creds.accessKey,
              creds.b64privateKey()))
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

  val configIdx = arglist.indexOf("--config")
  if (configIdx >= 0 && arglist.size > configIdx + 1) {
    val configFile = arglist.get(configIdx + 1)
    if (File(configFile).exists()) {
      ENV = UserConfig.fromFile(configFile)
    }
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

  // TODO: this should be a sharded service or better the whole
  // Mux/Stream api should be based around co-routines. currently this
  // is an unbounded pool and so there's ultimately no back-pressure.
  val workerPool = Executors.newSingleThreadExecutor()
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
          // RateLimitRequestsPerConnection(
          //     logger,
          //     config.getDouble("max_conn_qps", 20.0),
          //     config.getInt("max_conn_req_spike", 50)) then
          LimitConnectionsPerUser(logger, config.getInt("user_conns", 5)) then
          LimitConnectionsPerDb(logger, config.getInt("db_conns", 10)) then
          LimitGlobalConnections(logger, config.getInt("global_conns", 10_000))

  val connHandler = connectionHandler(policy, workerPool, taskPool, encryption, logger)

  val server = createHttpServer(connHandler)
  server.start()
}
