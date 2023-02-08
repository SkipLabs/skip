package io.skiplabs.skgw

import java.io.BufferedReader

enum class OutputFormat(val flag: String) {
  JSON("--format=json"),
  CSV("--format=csv"),
}

// super dumb, mostly synchronous, process facade
class Skdb(val dbPath: String) {

  val SKDB_PROC = "/skfs/build/skdb"

  private fun blockingRun(pb: ProcessBuilder, input: String? = null): String {
    // TODO: hack for quick debug - should go somewhere useful
    pb.redirectError(ProcessBuilder.Redirect.INHERIT)

    val proc = pb.start()

    if (input != null) {
      val writer = proc.outputStream.bufferedWriter()
      writer.write(input)
      writer.close()
    }

    val output = proc.inputStream.bufferedReader().use(BufferedReader::readText)

    // TODO: should have a timeout
    val exitCode = proc.waitFor()

    if (exitCode != 0) {
      throw RuntimeException("SKDB exited with ${exitCode}")
    }

    return output
  }

  fun init() {
    blockingRun(ProcessBuilder(SKDB_PROC, "--init", dbPath))
  }

  fun sql(stmts: String, format: OutputFormat): String {
    return blockingRun(ProcessBuilder(SKDB_PROC, "--data", dbPath, format.flag), stmts)
  }

  fun dumpTable(table: String, suffix: String): String {
    return blockingRun(
        ProcessBuilder(SKDB_PROC, "dump-table", table, "--data", dbPath, "--table-suffix", suffix))
  }

  fun writeCsv(
      user: String,
      table: String,
      callback: (String) -> Unit,
      closed: () -> Unit,
  ): Process {
    val pb = ProcessBuilder(SKDB_PROC, "write-csv", table, "--data", dbPath, "--user", user)

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
}
