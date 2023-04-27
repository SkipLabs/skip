package io.skiplabs.skgw

import java.nio.ByteBuffer

// the orchestration protocol. App.kt implements the behaviour, this
// file factors out the encoding/decoding of messages to reduce noise

sealed class ProtoMessage()

enum class QueryResponseFormat {
  JSON,
  RAW,
  CSV,
}

data class ProtoQuery(val query: String, val format: QueryResponseFormat) : ProtoMessage()

data class ProtoRequestTail(
    val table: String,
    val since: ULong = 0u,
) : ProtoMessage()

enum class SchemaScope {
  ALL,
  TABLE,
  VIEW,
}

data class ProtoSchemaQuery(
    val name: String? = null,
    val scope: SchemaScope,
) : ProtoMessage()

data class ProtoPushPromise(val table: String) : ProtoMessage()

data class ProtoCreateDb(val name: String) : ProtoMessage()

class ProtoCreateUser() : ProtoMessage()

data class ProtoData(val data: ByteBuffer, val finFlagSet: Boolean) : ProtoMessage()

data class ProtoCredentials(val accessKey: String, val privateKey: ByteBuffer) : ProtoMessage() {

  override fun toString(): String {
    return "ProtoCredentials(accessKey=${accessKey}, privateKey=**redacted**)"
  }
}

fun decodeProtoMsg(data: ByteBuffer): ProtoMessage {
  return null
}

fun encodeProtoMsg(msg: ProtoMessage): ByteBuffer {
  val buf = ByteBuffer.allocate(16)
  return buf.flip()
}
