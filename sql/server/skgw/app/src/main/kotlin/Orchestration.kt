package io.skiplabs.skgw

import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets

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
  val type = data.get().toUInt()
  return when (type) {
    0u -> {
      val flags = data.get().toUInt()
      val finFlagSet = (flags and 0x01u) == 1u
      ProtoData(data.slice(), finFlagSet)
    }
    1u -> {
      val format = QueryResponseFormat.values()[(data.get().toUInt() and 0x0Fu).toInt()]
      val queryLength = data.getInt()
      val queryBytes = ByteArray(queryLength)
      data.get(queryBytes)
      ProtoQuery(String(queryBytes, StandardCharsets.UTF_8), format)
    }
    2u -> {
      data.position(data.position() + 3) // skip over reserved
      val since = data.getLong()
      val tableNameLength = data.getShort()
      val tableNameBytes = ByteArray(tableNameLength.toInt())
      data.get(tableNameBytes)
      ProtoRequestTail(String(tableNameBytes, StandardCharsets.UTF_8), since.toULong())
    }
    3u -> {
      data.position(data.position() + 3) // skip over reserved
      val tableNameLength = data.getShort()
      val tableNameBytes = ByteArray(tableNameLength.toInt())
      data.get(tableNameBytes)
      ProtoPushPromise(String(tableNameBytes, StandardCharsets.UTF_8))
    }
    4u -> {
      val scope = SchemaScope.values()[(data.get().toUInt() and 0x0Fu).toInt()]
      val tableNameLength = data.getShort()
      if (tableNameLength < 1) {
        ProtoSchemaQuery(null, scope)
      } else {
        val tableNameBytes = ByteArray(tableNameLength.toInt())
        data.get(tableNameBytes)
        ProtoSchemaQuery(String(tableNameBytes, StandardCharsets.UTF_8), scope)
      }
    }
    5u -> {
      val tableNameLength = data.getShort()
      val tableNameBytes = ByteArray(tableNameLength.toInt())
      data.get(tableNameBytes)
      ProtoCreateDb(String(tableNameBytes, StandardCharsets.UTF_8))
    }
    6u -> {
      ProtoCreateUser()
    }
    else -> throw RuntimeException("Could not decode orchestration msg")
  }
}

fun encodeProtoMsg(msg: ProtoMessage): ByteBuffer {
  return when (msg) {
    is ProtoData -> {
      val buf = ByteBuffer.allocate(2 + msg.data.remaining())
      buf.put(0x00.toByte())
      buf.put(if (msg.finFlagSet) 0x01.toByte() else 0x00.toByte())
      buf.put(msg.data)
      buf.flip()
    }
    is ProtoCredentials -> {
      val buf = ByteBuffer.allocate(53)
      buf.put(0x80.toByte())
      val encoder = StandardCharsets.US_ASCII.newEncoder()
      var res = encoder.encode(CharBuffer.wrap(msg.accessKey), buf, true)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      res = encoder.flush(buf)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      buf.position(21)
      buf.put(msg.privateKey)
      buf.flip()
    }
    else -> throw RuntimeException("We don't support encoding ${msg}")
  }
}
