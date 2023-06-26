package io.skiplabs.skgw.cli

import io.skiplabs.skgw.Credentials
import io.skiplabs.skgw.NoEncryptionTransform
import io.skiplabs.skgw.OutputFormat
import io.skiplabs.skgw.client.SkdbConnection
import io.skiplabs.skgw.createSkdb
import io.skiplabs.skgw.genCredentials
import io.skiplabs.skgw.openSkdb
import java.net.URI
import java.util.Base64
import java.util.UUID
import java.util.concurrent.Executors
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
  skdb.sql("CREATE TABLE IF NOT EXISTS test (x INTEGER PRIMARY KEY, y STRING);", OutputFormat.RAW)

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
      )

  conn.open()

  val work = launch {
    launch {
      val create = conn.sqlRaw("CREATE TABLE IF NOT EXISTS test (x INTEGER PRIMARY KEY, y STRING);")
      println(": [ggyxt] create: ${create}")

      launch {
        val result = conn.sqlRaw("SELECT * FROM test")
        println(": [xcvtf] result: ${result}")
      }

      launch { conn.establishServerTail("test") }
      conn.establishLocalTail("test")
    }

    launch {
      val schema = conn.schema()
      println(": [hsexs] schema: ${schema}")
    }
  }

  work.join()
  conn.close()
}
