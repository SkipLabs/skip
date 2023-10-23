package io.skiplabs.skdb

import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets

// the orchestration protocol

// 10MiB ought to be enough for anybody
val MAX_QUERY_LENGTH = 10 * 1024 * 1024

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
    val filterExpr: String?,
) : ProtoMessage()

enum class SchemaScope {
  ALL,
  TABLE,
  VIEW,
}

data class ProtoSchemaQuery(
    val name: String? = null,
    val scope: SchemaScope,
    val suffix: String? = null,
) : ProtoMessage()

class ProtoPushPromise() : ProtoMessage()

data class ProtoCreateDb(val name: String) : ProtoMessage()

class ProtoCreateUser() : ProtoMessage()

data class ProtoData(val data: ByteBuffer, val finFlagSet: Boolean) : ProtoMessage()

data class ProtoCredentials(val accessKey: String, val privateKey: ByteBuffer) : ProtoMessage() {

  override fun toString(): String {
    return "ProtoCredentials(accessKey=${accessKey}, privateKey=**redacted**)"
  }
}

data class RevealableException(val code: UInt, val msg: String) : RuntimeException(msg)

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
      if (queryLength > MAX_QUERY_LENGTH) {
        throw RevealableException(
            2003u, "Query exceeded max length, try reducing query size or using a mirrored table.")
      }
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
      if (!data.hasRemaining()) {
        ProtoRequestTail(
            table = String(tableNameBytes, StandardCharsets.UTF_8),
            since = since.toULong(),
            filterExpr = null)
      } else {
        val filterExprLength = data.getShort()
        val filterBytes = ByteArray(filterExprLength.toInt())
        data.get(filterBytes)
        ProtoRequestTail(
            String(tableNameBytes, StandardCharsets.UTF_8),
            since.toULong(),
            String(filterBytes, StandardCharsets.UTF_8))
      }
    }
    3u -> {
      ProtoPushPromise()
    }
    4u -> {
      val scope = SchemaScope.values()[(data.get().toUInt() and 0x0Fu).toInt()]
      val tableNameLength = data.getShort()
      if (tableNameLength < 1) {
        ProtoSchemaQuery(null, scope)
      } else {
        val tableNameBytes = ByteArray(tableNameLength.toInt())
        data.get(tableNameBytes)

        val suffixLength = data.getShort()
        val suffixBytes = ByteArray(suffixLength.toInt())
        data.get(suffixBytes)

        ProtoSchemaQuery(
            String(tableNameBytes, StandardCharsets.UTF_8),
            scope,
            String(suffixBytes, StandardCharsets.UTF_8))
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
    is ProtoSchemaQuery -> {
      val buf = ByteBuffer.allocate(4 + (msg.name?.length ?: 0) * 4)
      buf.put(0x04.toByte())
      buf.put(
          when (msg.scope) {
            SchemaScope.ALL -> 0x0
            SchemaScope.TABLE -> 0x1
            SchemaScope.VIEW -> 0x2
          })
      val pos = buf.position()
      buf.putShort(0x0)
      val encoder = StandardCharsets.UTF_8.newEncoder()
      var res = encoder.encode(CharBuffer.wrap(msg.name ?: ""), buf, true)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      res = encoder.flush(buf)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      buf.putShort(pos, (buf.position() - pos - 2).toShort())
      buf.flip()
    }
    is ProtoQuery -> {
      val buf = ByteBuffer.allocate(6 + msg.query.length * 4)
      buf.put(0x01.toByte())
      buf.put(
          when (msg.format) {
            QueryResponseFormat.JSON -> 0x0
            QueryResponseFormat.RAW -> 0x1
            QueryResponseFormat.CSV -> 0x2
          })
      val pos = buf.position()
      buf.putInt(0x0)
      val encoder = StandardCharsets.UTF_8.newEncoder()
      var res = encoder.encode(CharBuffer.wrap(msg.query), buf, true)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      res = encoder.flush(buf)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      buf.putInt(pos, (buf.position() - pos - 4))
      buf.flip()
    }
    is ProtoRequestTail -> {
      val buf = ByteBuffer.allocate(16 + msg.table.length * 4 + (msg.filterExpr?.length ?: 0) * 4)
      buf.putInt(0x0)
      buf.put(0, 0x02.toByte())
      buf.putLong(msg.since.toLong())

      var pos = buf.position()
      buf.putShort(0x0)
      val encoder = StandardCharsets.UTF_8.newEncoder()
      var res = encoder.encode(CharBuffer.wrap(msg.table), buf, true)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      res = encoder.flush(buf)
      if (!res.isUnderflow()) {
        res.throwException()
      }
      val tableLengthEncoded = (buf.position() - pos - 2).toShort()
      buf.putShort(pos, tableLengthEncoded)
      encoder.reset()

      if (msg.filterExpr != null) {
        pos = buf.position()
        buf.putShort(0x0)
        res = encoder.encode(CharBuffer.wrap(msg.filterExpr), buf, true)
        if (!res.isUnderflow()) {
          res.throwException()
        }
        res = encoder.flush(buf)
        if (!res.isUnderflow()) {
          res.throwException()
        }
        buf.putShort(pos, (buf.position() - pos - 2).toShort())
      }

      buf.flip()
    }
    is ProtoPushPromise -> {
      val buf = ByteBuffer.allocate(4)
      buf.putInt(0x0)
      buf.put(0, 0x03.toByte())
      buf.flip()
    }
    else -> throw RuntimeException("We don't support encoding ${msg}")
  }
}

// adapts the stream interface for this layer in the protocol stack
interface OrchestrationStream {
  val stream: Stream
  fun close()
  fun error(errorCode: UInt, msg: String)
  // raises the abstraction of this to messages rather than bytes
  fun send(msg: ProtoMessage)
}
