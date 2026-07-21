package io.skiplabs.skdb.pg

import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets
import org.postgresql.core.Oid

// https://www.postgresql.org/docs/12/protocol-logicalrep-message-formats.html
sealed class PgMsg

data class PgBegin(
    val txnFinalLsn: ULong,
    val rawTimestamp: ULong,
    val xid: UInt,
) : PgMsg()

data class PgCommit(
    val commitLsn: ULong,
    val txnEndLsn: ULong,
    val rawTimestamp: ULong,
) : PgMsg()

data class PgOrigin(
    val originLsn: ULong,
    val orign: String,
) : PgMsg()

enum class PgGeneralisedDataType {
  BOOL,
  INT,
  FLOAT,
  TEXT,
  UNSUPPORTED
}

data class PgColumn(
    val isKey: Boolean,
    val name: String,
    val dataType: PgGeneralisedDataType,
    val typeModifier: UInt,
)

data class PgRelation(
    val id: UInt,
    val namespace: String,
    val relation: String,
    val replicaIdentitySetting: UByte,
    val cols: List<PgColumn>,
) : PgMsg()

data class PgType(
    val id: UInt,
    val namespace: String,
    val name: String,
) : PgMsg()

sealed class PgTupleData

class PgTupleNull : PgTupleData()

class PgTupleUnchangedToast : PgTupleData()

data class PgTupleText(val data: String) : PgTupleData()

sealed class PgTuple()

data class PgTupleNew(val cols: List<PgTupleData>) : PgTuple()

data class PgTupleFull(val cols: List<PgTupleData>) : PgTuple()

data class PgTupleKey(val cols: List<PgTupleData>) : PgTuple()

data class PgInsert(
    val relationId: UInt,
    val new: PgTuple,
) : PgMsg()

data class PgUpdate(
    val relationId: UInt,
    val old: PgTuple?,
    val new: PgTuple,
) : PgMsg()

data class PgDelete(
    val relationId: UInt,
    val old: PgTuple,
) : PgMsg()

data class PgTruncate(
    val options: UByte,
    val relations: List<UInt>,
) : PgMsg()

private fun extractNulTerminatedString(b: ByteBuffer): String {
  val slice = b.slice()
  var idx = 0
  while (b.hasRemaining() && b.get() != 0x00.toByte()) idx++
  slice.limit(idx)
  return StandardCharsets.UTF_8.decode(slice).toString()
}

private fun lookupType(oid: Int): PgGeneralisedDataType {
  return when (oid) {
    Oid.BOOL -> PgGeneralisedDataType.BOOL
    Oid.INT2,
    Oid.INT4,
    Oid.INT8 -> PgGeneralisedDataType.INT
    Oid.FLOAT4,
    Oid.FLOAT8 -> PgGeneralisedDataType.FLOAT
    Oid.VARCHAR,
    Oid.TEXT,
    Oid.CHAR -> PgGeneralisedDataType.TEXT
    else -> PgGeneralisedDataType.UNSUPPORTED
  }
}

private fun extractTuple(b: ByteBuffer): PgTuple {
  val type = b.get()
  val ncols = b.getShort().toInt()
  val cols = ArrayList<PgTupleData>(ncols)

  for (i in 0..<ncols) {
    val dt = b.get()
    cols.add(
        when (dt) {
          'n'.code.toByte() -> {
            PgTupleNull()
          }
          'u'.code.toByte() -> {
            PgTupleUnchangedToast()
          }
          't'.code.toByte() -> {
            val len = b.getInt()
            val slice = b.slice()
            slice.limit(len)
            val decoded = StandardCharsets.UTF_8.decode(slice).toString()
            b.position(b.position() + len)
            PgTupleText(decoded)
          }
          else -> throw RuntimeException("Could not decode column, unknown type: ${dt}")
        })
  }

  return when (type) {
    // new
    'N'.code.toByte() -> {
      PgTupleNew(cols)
    }
    // old full
    'O'.code.toByte() -> {
      PgTupleFull(cols)
    }
    // old key
    'K'.code.toByte() -> {
      PgTupleKey(cols)
    }
    else -> throw RuntimeException("Could not decode tuple, unknown type: ${type}")
  }
}

fun decodeMsg(msg: ByteBuffer): PgMsg {
  val type = msg.get()
  val decodedMsg =
      when (type) {
        // begin txn
        'B'.code.toByte() -> {
          val finalLsn = msg.getLong().toULong()
          val rawTimestamp = msg.getLong().toULong()
          val xid = msg.getInt().toUInt()
          PgBegin(finalLsn, rawTimestamp, xid)
        }
        // commit txn
        'C'.code.toByte() -> {
          msg.get() // skip over unused flags
          val commitLsn = msg.getLong().toULong()
          val txnEndLsn = msg.getLong().toULong()
          val rawTimestamp = msg.getLong().toULong()
          PgCommit(commitLsn, txnEndLsn, rawTimestamp)
        }
        // origin
        'O'.code.toByte() -> {
          val originLsn = msg.getLong().toULong()
          val origin = StandardCharsets.UTF_8.decode(msg).toString()
          PgOrigin(originLsn, origin)
        }
        // relation
        'R'.code.toByte() -> {
          val id = msg.getInt().toUInt()
          val namespace = extractNulTerminatedString(msg)
          val relation = extractNulTerminatedString(msg)
          val replicaIdentitySetting = msg.get().toUByte()
          val ncols = msg.getShort().toInt()
          val cols = ArrayList<PgColumn>(ncols)
          for (colIdx in 0..<ncols) {
            val colFlags = msg.get()
            val isKey = colFlags == 0x01.toByte()
            val name = extractNulTerminatedString(msg)
            val typeId = msg.getInt()
            val dataType = lookupType(typeId)
            val typeModifier = msg.getInt().toUInt()
            cols.add(PgColumn(isKey, name, dataType, typeModifier))
          }
          PgRelation(id, namespace, relation, replicaIdentitySetting, cols)
        }
        // type
        'Y'.code.toByte() -> {
          val id = msg.getInt().toUInt()
          val namespace = extractNulTerminatedString(msg)
          val name = extractNulTerminatedString(msg)
          PgType(id, namespace, name)
        }
        // insert
        'I'.code.toByte() -> {
          val relationId = msg.getInt().toUInt()
          val new = extractTuple(msg)
          PgInsert(relationId, new)
        }
        // update
        'U'.code.toByte() -> {
          val relationId = msg.getInt().toUInt()
          val firstTuple = extractTuple(msg)
          if (firstTuple is PgTupleNew) {
            PgUpdate(relationId, null, firstTuple)
          } else {
            val secondTuple = extractTuple(msg)
            PgUpdate(relationId, firstTuple, secondTuple)
          }
        }
        // delete
        'D'.code.toByte() -> {
          val relationId = msg.getInt().toUInt()
          val old = extractTuple(msg)
          PgDelete(relationId, old)
        }
        // truncate
        'T'.code.toByte() -> {
          val nrelations = msg.getInt()
          val options = msg.get().toUByte()
          val relations = ArrayList<UInt>(nrelations)
          for (i in 0..<nrelations) {
            relations.add(msg.getInt().toUInt())
          }
          PgTruncate(options, relations)
        }
        else -> throw RuntimeException("Could not decode message unknown type: ${type}")
      }
  if (msg.hasRemaining()) {
    throw RuntimeException("Unexpected bytes remaining after decoding ${decodedMsg}")
  }
  return decodedMsg
}
