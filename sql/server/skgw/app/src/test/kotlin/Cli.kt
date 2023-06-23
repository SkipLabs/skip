package io.skiplabs.skgw.cli

import io.skiplabs.skgw.Credentials
import io.skiplabs.skgw.client.SkdbConnection
import io.skiplabs.skgw.openSkdb
import java.net.URI
import java.util.Base64
import java.util.UUID
import java.util.concurrent.Executors
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
  val pool = Executors.newSingleThreadScheduledExecutor()

  val skdb = openSkdb("client")

  val endpoint = "ws://localhost:8080"
  val db = "foo"
  val accessKey = "root"
  val privateKey = Base64.getDecoder().decode("kNqxI8l+1Y1rS2i3M9dOONBTdUQXYsttby7bxD3rhpo=")

  val conn =
      SkdbConnection(
          endpoint = URI("${endpoint}/dbs/${db}/connection"),
          creds =
              Credentials(
                  accessKey = accessKey,
                  privateKey = privateKey,
                  encryptedPrivateKey = ByteArray(0),
                  deviceUuid = UUID.randomUUID().toString(),
              ),
          local = skdb!!,
          taskPool = pool,
      )

  conn.open()

  val work = launch {
    launch {
      val create = conn.sqlRaw("CREATE TABLE IF NOT EXISTS test (x INTEGER PRIMARY KEY, y STRING);")
      println(": [ggyxt] create: ${create}")
      val result = conn.sqlRaw("SELECT * FROM test")
      println(": [xcvtf] result: ${result}")
    }

    launch {
      val schema = conn.schema()
      println(": [hsexs] schema: ${schema}")
    }
  }

  work.join()
  conn.close()
}
