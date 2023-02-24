package io.skiplabs.skgw

import java.io.BufferedReader
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.util.Base64

enum class OutputFormat(val flag: String) {
  RAW("--format=sql"),
  JSON("--format=json"),
  CSV("--format=csv"),
}

// represents the complete output of a process run.
data class ProcessOutput(val output: String, val exitCode: Int) {
  fun exitSuccessfully(): Boolean {
    return exitCode == 0
  }

  fun getOrThrow(): String {
    if (exitCode != 0) {
      throw RuntimeException("Process exited unsuccessfully: ${exitCode}")
    }
    return output
  }
}

// super dumb, mostly synchronous, process facade
class Skdb(val name: String, private val dbPath: String) {
  val SKDB_PROC = "/skfs/build/skdb"
  val SKDB_SETUP = "/skfs/build/init.sql"

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

    val output = proc.inputStream.bufferedReader().use(BufferedReader::readText)

    // TODO: should have a timeout
    val exitCode = proc.waitFor()

    return ProcessOutput(output, exitCode)
  }

  fun init() {
    blockingRun(ProcessBuilder(SKDB_PROC, "--init", dbPath))
  }

  fun sql(stmts: String, format: OutputFormat): ProcessOutput {
    return blockingRun(ProcessBuilder(SKDB_PROC, "--data", dbPath, format.flag), stmts)
  }

  fun dumpTable(table: String, suffix: String): ProcessOutput {
    return blockingRun(
        ProcessBuilder(SKDB_PROC, "dump-table", table, "--data", dbPath, "--table-suffix", suffix))
  }

  fun dumpView(view: String): ProcessOutput {
    return blockingRun(ProcessBuilder(SKDB_PROC, "dump-view", view, "--data", dbPath))
  }

  fun dumpSchema(): ProcessOutput {
    val tables = blockingRun(ProcessBuilder(SKDB_PROC, "dump-tables", "--data", dbPath))
    if (!tables.exitSuccessfully()) return tables
    val views = blockingRun(ProcessBuilder(SKDB_PROC, "dump-views", "--data", dbPath))
    return ProcessOutput(tables.output + views.output, views.exitCode)
  }

  fun writeCsv(
      user: String,
      table: String,
      callback: (String) -> Unit,
      closed: () -> Unit,
  ): Process {
    val pb = ProcessBuilder(SKDB_PROC, "write-csv", table, "--data", dbPath, "--user", user)

    // TODO: for hacky debug
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)

    val proc = pb.start()

    val output = proc.inputStream.bufferedReader()

    val t =
        Thread({
          output.forEachLine { callback(it) }
          closed()
        })
    t.start()

    return proc
  }

  fun tail(
      user: String,
      table: String,
      since: Int,
      callback: (String) -> Unit,
      closed: () -> Unit,
  ): Process {
    // TODO: check for existing
    val connection =
        blockingRun(
                ProcessBuilder(
                    SKDB_PROC, "subscribe", table, "--connect", "--data", dbPath, "--user", user))
            .getOrThrow()
    val pb =
        ProcessBuilder(
            SKDB_PROC,
            "tail",
            "--data",
            dbPath,
            "--format=csv",
            connection.trim(),
            "--follow",
            "--since",
            (if (since < 0) 0 else since).toString())

    // TODO: for hacky debug
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)
    val proc = pb.start()

    val output = proc.inputStream.bufferedReader()

    val t =
        Thread({
          output.forEachLine { callback(it) }
          closed()
        })
    t.start()

    return proc
  }

  fun privateKeyAsStored(user: String): ByteArray {
    val key =
        sql("SELECT privateKey FROM skdb_users WHERE username = '${user}';", OutputFormat.RAW)
            .getOrThrow()
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
    val initScript = Files.readString(Path.of(SKDB_SETUP), Charsets.UTF_8)
    blockingRun(ProcessBuilder(SKDB_PROC, "--init", dbPath))
    blockingRun(ProcessBuilder(SKDB_PROC, "--data", dbPath), initScript)
    sql("INSERT INTO skdb_users VALUES (0, 'root', '${encryptedRootPrivateKey}')", OutputFormat.RAW)
    return this
  }

  fun createUser(accessKey: String, encryptedPrivateKey: String): ProcessOutput {
    return sql(
        "INSERT INTO skdb_users VALUES (id(), '${accessKey}', '${encryptedPrivateKey}')",
        OutputFormat.RAW)
  }
}

private fun resolveDbPath(db: String): String {
  return "/var/db/${db}.db"
}

fun openSkdb(db: String?): Skdb? {
  if (db == null) {
    return null
  }

  val dbPath = resolveDbPath(db)
  if (!File(dbPath).exists()) return null

  return Skdb(db, dbPath)
}

fun createSkdb(db: String, encryptedRootPrivateKey: String): Skdb {
  return Skdb(db, resolveDbPath(db)).createDb(encryptedRootPrivateKey)
}
