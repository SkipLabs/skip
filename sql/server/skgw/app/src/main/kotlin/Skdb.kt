package io.skiplabs.skgw

import java.io.BufferedReader
import java.io.OutputStream

enum class OutputFormat(val flag: String) {
    JSON("--json"),
    CSV("--csv"),
}

// super dumb, mostly synchronous, process facade
class Skdb(val dbPath: String) {

    val SKDB_PROC = "/skfs_build/build/skdb"

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
            ProcessBuilder(
                SKDB_PROC,
                "--data",
                dbPath,
                "--dump-table",
                table,
                "--table-suffix",
                suffix
            )
        )
    }

    fun writeCsv(user: String, password: String, table: String): OutputStream {
        val pb =
            ProcessBuilder(
                SKDB_PROC,
                "--data",
                dbPath,
                "--user",
                user,
                "--password",
                password,
                "--write-csv",
                table
            )

        pb.redirectError(ProcessBuilder.Redirect.INHERIT)

        val proc = pb.start()

        // TODO: interface sucks, no way to control and prevent leaking the proc
        return proc.outputStream
    }

    fun tail(user: String, password: String, table: String, callback: (String) -> Unit): Process {
        // TODO: check for existing
        val connection =
            blockingRun(
                ProcessBuilder(
                    SKDB_PROC,
                    "--data",
                    dbPath,
                    "--connect",
                    table,
                    "--user",
                    user,
                    "--password",
                    password
                )
            )
        val pb = ProcessBuilder(SKDB_PROC, "--data", dbPath, "--csv", "--tail", connection.trim())

        // TODO: for hacky debug
        pb.redirectError(ProcessBuilder.Redirect.INHERIT)
        val proc = pb.start()

        val output = proc.inputStream.bufferedReader()

        val t = Thread({ output.forEachLine { callback(it) } })
        t.start()

        return proc
        // TODO: return this so we can kill the proc. but we should
        // also be cleaning up the connection that was created.
    }
}
