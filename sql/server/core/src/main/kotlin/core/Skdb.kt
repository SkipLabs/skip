package io.skiplabs.skgw

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import com.squareup.moshi.adapter
import java.io.File
import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.Base64

val DB_ROOT_USER = "root"

enum class OutputFormat(val flag: String) {
  RAW("--format=sql"),
  JSON("--format=json"),
  CSV("--format=csv"),
}

// represents the complete output of a process run.
data class ProcessOutput(val output: ByteArray, val exitCode: Int) {
  fun exitSuccessfully(): Boolean {
    return exitCode == 0
  }

  fun getOrThrow(): ByteArray {
    if (exitCode != 0) {
      throw RuntimeException("Process exited unsuccessfully: ${exitCode}")
    }
    return output
  }

  fun decode(): String {
    return String(output, StandardCharsets.UTF_8)
  }

  fun decodeOrThrow(): String {
    return String(getOrThrow(), StandardCharsets.UTF_8)
  }
}

// super dumb, mostly synchronous, process facade
class Skdb(val name: String, private val dbPath: String) {

  private fun blockingRun(pb: ProcessBuilder, input: String? = null): ProcessOutput {
    // capture error output too. if you'are authenticated to run the
    // command you should also be able to see any issues.
    pb.redirectErrorStream(true)

    val proc = pb.start()

    if (input != null) {
      val writer = proc.outputStream.bufferedWriter()
      writer.write(input)
      writer.close()
    }

    val output = proc.inputStream.readAllBytes()

    // TODO: should have a timeout
    val exitCode = proc.waitFor()

    return ProcessOutput(output, exitCode)
  }

  fun init() {
    blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "--init", dbPath))
  }

  fun sql(stmts: String, format: OutputFormat): ProcessOutput {
    return blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "--data", dbPath, format.flag), stmts)
  }

  fun sql(stmts: String, params: Map<String, Any?>, format: OutputFormat): ProcessOutput {
    val buf = StringBuilder()
    val moshi = Moshi.Builder().build()
    val adapter: JsonAdapter<Map<String, Any?>> =
        moshi.adapter(
            Types.newParameterizedType(Map::class.java, String::class.java, Object::class.java))
    buf.append(adapter.toJson(params))
    buf.append("\n")
    buf.append(stmts)
    return blockingRun(
        ProcessBuilder(
            USER_CONFIG.skdb_path, "--data", dbPath, format.flag, "--expect-query-params"),
        buf.toString())
  }

  fun sqlStream(format: OutputFormat): Process {
    val pb = ProcessBuilder(USER_CONFIG.skdb_path, "--data", dbPath, format.flag)

    // TODO: for hacky debug
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)

    val proc = pb.start()
    return proc
  }

  fun replicationId(deviceUuid: String): ProcessOutput {
    return blockingRun(
        ProcessBuilder(USER_CONFIG.skdb_path, "replication-id", deviceUuid, "--data", dbPath))
  }

  fun dumpTable(table: String): ProcessOutput {
    return blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "dump-table", table, "--data", dbPath))
  }

  fun dumpView(view: String): ProcessOutput {
    return blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "dump-view", view, "--data", dbPath))
  }

  fun dumpSchema(): ProcessOutput {
    val tables = blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "dump-tables", "--data", dbPath))
    if (!tables.exitSuccessfully()) return tables
    val views = blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "dump-views", "--data", dbPath))
    return ProcessOutput(tables.output + views.output, views.exitCode)
  }

  fun writeCsv(
      user: String,
      table: String,
      replicationId: String,
      callback: (ByteBuffer, shouldFlush: Boolean) -> Unit,
      closed: () -> Unit,
  ): Process {
    val pb =
        ProcessBuilder(
            USER_CONFIG.skdb_path,
            "write-csv",
            table,
            "--data",
            dbPath,
            "--user",
            user,
            "--source",
            replicationId)

    // TODO: for hacky debug
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)

    val proc = pb.start()

    // we work with text lines as it is convenient. there's a trivial
    // amount of work going on to decode and re-encode here - just
    // checkpoints
    val output = proc.inputStream.bufferedReader()

    val t =
        Thread({
          val encoder = StandardCharsets.UTF_8.newEncoder()
          output.forEachLine { callback(encoder.encode(CharBuffer.wrap(it)), true) }
          closed()
        })
    t.start()

    return proc
  }

  fun tail(
      user: String,
      table: String,
      since: ULong,
      filter: String?,
      replicationId: String,
      callback: (ByteBuffer, shouldFlush: Boolean) -> Unit,
      closed: () -> Unit,
  ): Process {
    // TODO: check for existing
    val connection =
        blockingRun(
                ProcessBuilder(
                    USER_CONFIG.skdb_path,
                    "subscribe",
                    table,
                    "--connect",
                    "--data",
                    dbPath,
                    "--ignore-source",
                    replicationId))
            .decode()
    val pb =
        ProcessBuilder(
            USER_CONFIG.skdb_path,
            "tail",
            "--data",
            dbPath,
            "--format=csv",
            connection.trim(),
            "--follow",
            "--user",
            user,
            "--since",
            (if (since < 0u) 0 else since).toString())

    if (filter != null && !filter.isEmpty()) {
      pb.command().add(filter)
    }

    // TODO: for hacky debug
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)
    val proc = pb.start()

    // TODO: working with text currently to detect checkpoint flush
    // markers. this should change as it is expensive. I particularly
    // don't like having to allocate 4x here.
    val output = proc.inputStream.bufferedReader()

    val t =
        Thread({
          output.forEachLine {
            val encoder = StandardCharsets.UTF_8.newEncoder()
            val buf = ByteBuffer.allocate(it.length * 4 + 1)
            var res = encoder.encode(CharBuffer.wrap(it), buf, true)
            if (!res.isUnderflow()) {
              res.throwException()
            }
            res = encoder.flush(buf)
            if (!res.isUnderflow()) {
              res.throwException()
            }
            buf.put(0x0A) // add back newline
            callback(buf.flip(), it.startsWith(":"))
          }
          closed()
        })
    t.start()

    return proc
  }

  fun notify(
      table: String,
      callback: () -> Unit,
  ) {
    val notifyFile = File.createTempFile("notify", table)
    // TODO: notifyFile.deleteOnExit() -- need to unsubscribe first

    val connection =
        blockingRun(
            ProcessBuilder(
                USER_CONFIG.skdb_path,
                "subscribe",
                table,
                "--data",
                dbPath,
                "--notify",
                notifyFile.path))

    if (!connection.exitSuccessfully()) {
      throw RuntimeException("Notify failed")
    }

    var tick = ""
    // super dumb right now. just poll the file.
    val t =
        Thread({
          while (true) {
            val now = Files.readString(notifyFile.toPath())
            if (now != tick) {
              tick = now
              callback()
            }
            Thread.sleep(1000)
          }
        })
    t.start()
  }

  fun privateKeyAsStored(user: String): ByteArray {
    val key =
        sql(
                "SELECT privateKey FROM skdb_users WHERE username = @user;",
                mapOf("user" to user),
                OutputFormat.RAW)
            .decode()
            .trim()

    if (key.isEmpty()) {
      throw IllegalArgumentException("User ${user} could not be found.")
    }

    return Base64.getDecoder().decode(key)
  }

  fun createDb(encryptedRootPrivateKey: String): Skdb {
    if (File(dbPath).exists()) {
      throw RuntimeException("db ${dbPath} already exists")
    }
    val initScript = Files.readString(Path.of(USER_CONFIG.skdb_init_path), Charsets.UTF_8)
    blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "--init", dbPath))
    blockingRun(ProcessBuilder(USER_CONFIG.skdb_path, "--data", dbPath), initScript)
    sql(
        "INSERT INTO skdb_users VALUES (0, '${DB_ROOT_USER}', @key)",
        mapOf("key" to encryptedRootPrivateKey),
        OutputFormat.RAW)
    return this
  }

  fun createUser(accessKey: String, encryptedPrivateKey: String): ProcessOutput {
    return sql(
        "INSERT INTO skdb_users VALUES (id(), @accessKey, @privateKey)",
        mapOf("accessKey" to accessKey, "privateKey" to encryptedPrivateKey),
        OutputFormat.RAW)
  }
}

fun openSkdb(db: String?): Skdb? {
  if (db == null) {
    return null
  }

  val dbPath = USER_CONFIG.resolveDbPath(db)
  if (!File(dbPath).exists()) return null

  return Skdb(db, dbPath)
}

fun createSkdb(db: String, encryptedRootPrivateKey: String): Skdb {
  return Skdb(db, USER_CONFIG.resolveDbPath(db)).createDb(encryptedRootPrivateKey)
}
