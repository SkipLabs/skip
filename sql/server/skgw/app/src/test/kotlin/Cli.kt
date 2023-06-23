package io.skiplabs.skgw.cli

import kotlinx.coroutines.runBlocking
import io.skiplabs.skgw.client.SkdbConnection
import io.skiplabs.skgw.Credentials
import io.skiplabs.skgw.openSkdb
import java.net.URI
import java.util.UUID
import java.util.concurrent.Executors
import java.util.Base64

fun main() = runBlocking {
  val pool = Executors.newSingleThreadScheduledExecutor()

  val skdb = openSkdb("client")

  val endpoint = "ws://localhost:8080"
  val db = "foo"
  val accessKey = "root"
  val privateKey = Base64.getDecoder().decode("kNqxI8l+1Y1rS2i3M9dOONBTdUQXYsttby7bxD3rhpo=")

  val conn = SkdbConnection(
    endpoint = URI("${endpoint}/dbs/${db}/connection"),
    creds = Credentials(
      accessKey = accessKey,
      privateKey = privateKey,
      encryptedPrivateKey = ByteArray(0),
      deviceUuid = UUID.randomUUID().toString(),
    ),
    local = skdb!!,
    taskPool = pool,
  )

  conn.open()
  val schema = conn.schema()
  println(": [hsexs] schema: ${schema}")
}
