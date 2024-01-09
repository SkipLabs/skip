package io.skiplabs.skdb.cli

import io.skiplabs.skdb.Credentials
import io.skiplabs.skdb.NoEncryptionTransform
import io.skiplabs.skdb.OutputFormat
import io.skiplabs.skdb.ProtoData
import io.skiplabs.skdb.client.SkdbConnection
import io.skiplabs.skdb.createSkdb
import io.skiplabs.skdb.genCredentials
import io.skiplabs.skdb.openSkdb
import java.net.URI
import java.nio.charset.StandardCharsets
import java.util.Base64
import java.util.UUID
import java.util.concurrent.Executors
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
  val pool = Executors.newSingleThreadScheduledExecutor()

  val localDbName = "client"
  val localUser = "root"
  val skdb =
      openSkdb(localDbName)
          ?: createSkdb(
              localDbName, genCredentials(localUser, NoEncryptionTransform()).b64encryptedKey())
  skdb.sql("CREATE TABLE IF NOT EXISTS test (x INTEGER PRIMARY KEY, y TEXT);", OutputFormat.RAW)

  val endpoint = "ws://localhost:8080"
  val db = "foo"
  val remoteUser = "root"
  val remotePrivateKey = Base64.getDecoder().decode("kNqxI8l+1Y1rS2i3M9dOONBTdUQXYsttby7bxD3rhpo=")

  val conn =
      SkdbConnection(
          endpoint = URI("${endpoint}/dbs/${db}/connection"),
          creds =
              Credentials(
                  accessKey = remoteUser,
                  privateKey = remotePrivateKey,
                  encryptedPrivateKey = ByteArray(0),
                  deviceUuid = UUID.randomUUID().toString(),
              ),
          local = skdb,
          taskPool = pool,
          replicationId = 123u,
      )

  conn.open()

  val work = launch {
    launch {
      val create = conn.sqlRaw("CREATE TABLE IF NOT EXISTS test (x INTEGER PRIMARY KEY, y TEXT);")
      println(": [ggyxt] create: ${create}")

      launch {
        val result = conn.sqlRaw("SELECT * FROM test")
        println(": [xcvtf] result: ${result}")
      }

      val localWriteMonitor = Channel<ProtoData>()
      launch { conn.runRemoteTail("test", localWriteMonitor) }
      launch {
        for (msg in localWriteMonitor) {
          val out = StandardCharsets.UTF_8.decode(msg.data).toString()
          println(": [vvpcc] local write: ${out}")
        }
      }
      val remoteWriteMonitor = Channel<ProtoData>()
      launch { conn.runLocalTail("test", remoteWriteMonitor) }
      launch {
        for (msg in remoteWriteMonitor) {
          val out = StandardCharsets.UTF_8.decode(msg.data).toString()
          println(": [vvpcc] remote write: ${out}")
        }
      }
    }

    launch {
      val schema = conn.schema()
      println(": [hsexs] schema: ${schema}")
    }
  }

  work.join()
  conn.close()
}
