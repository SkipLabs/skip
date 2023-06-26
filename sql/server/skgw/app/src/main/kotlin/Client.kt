package io.skiplabs.skgw.client

import io.skiplabs.skgw.Credentials
import io.skiplabs.skgw.MuxedSocket
import io.skiplabs.skgw.ProtoData
import io.skiplabs.skgw.ProtoMessage
import io.skiplabs.skgw.ProtoPushPromise
import io.skiplabs.skgw.ProtoQuery
import io.skiplabs.skgw.ProtoRequestTail
import io.skiplabs.skgw.ProtoSchemaQuery
import io.skiplabs.skgw.QueryResponseFormat
import io.skiplabs.skgw.SchemaScope
import io.skiplabs.skgw.Skdb
import io.skiplabs.skgw.Stream
import io.skiplabs.skgw.connectMux
import io.skiplabs.skgw.decodeProtoMsg
import io.skiplabs.skgw.encodeProtoMsg
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.net.URI
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets
import java.util.concurrent.ScheduledExecutorService
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.coroutineScope

class SkdbConnection(
    val endpoint: URI,
    val creds: Credentials,
    val local: Skdb,
    val taskPool: ScheduledExecutorService
) {

  private var muxedSocket: MuxedSocket? = null

  suspend fun open() = coroutineScope {
    muxedSocket =
        connectMux(
            endpoint,
            taskPool = taskPool,
            onStream = { _, _ -> println("> stream opened [dmfbj]") },
            onClose = { println("> close [inpep]") },
            onError = { _, code, reason -> println("error ${code} ${reason}") },
            creds = creds,
        )
  }

  fun close() {
    muxedSocket?.closeSocket()
  }

  private fun consume(stream: Stream): ReceiveChannel<ProtoMessage> {
    val chan = Channel<ProtoMessage>()

    stream.onData = { bytes ->
      val msg = decodeProtoMsg(bytes)
      chan.trySendBlocking(msg).onFailure { throwable ->
        System.err.println("Failed to enqueue on to a channel: ${throwable}")
      }
    }
    stream.onClose = { chan.close() }
    stream.onError = { code, reason ->
      println(": [swnso] code: ${code}")
      println(": [ldggf] reason: ${reason}")
      chan.close(RuntimeException(reason))
    }

    return chan
  }

  private suspend fun request(req: ProtoMessage): String {
    if (muxedSocket == null) {
      throw RuntimeException("Socket not opened")
    }

    val stream = muxedSocket?.openStream()
    if (stream == null) {
      throw RuntimeException("Could not create stream")
    }
    val chan = consume(stream)

    stream.send(encodeProtoMsg(req))
    stream.close()

    val bufs = ArrayList<CharBuffer>()
    for (msg in chan) {
      when (msg) {
        is ProtoData -> {
          val decoder = StandardCharsets.UTF_8.newDecoder()
          val charbuf = decoder.decode(msg.data)
          bufs.add(charbuf)
          if (msg.finFlagSet) {
            return bufs.map { it.toString() }.joinToString(separator = "")
          }
        }
        else -> {
          throw RuntimeException("Unexpected message received in response")
        }
      }
    }

    throw RuntimeException("Did not receive a complete payload")
  }

  suspend fun schema(): String {
    return request(ProtoSchemaQuery(scope = SchemaScope.ALL))
  }

  suspend fun sqlRaw(query: String): String {
    return request(ProtoQuery(query, QueryResponseFormat.RAW))
  }

  // TODO: this only returns control on failure. currently no way to
  // know when we're 'caught up'
  suspend fun establishServerTail(table: String) {
    if (muxedSocket == null) {
      throw RuntimeException("Socket not opened")
    }

    // TODO: should be able to close this proc on close()
    val proc =
        local.writeCsv(
            user = "root", // TODO: user
            table,
            replicationId = "123", // TODO: replication id
            { _, _ ->
              // do nothing; client drops acks
            },
            {
              // TODO: catastrophic failure
            })
    val stdin = BufferedOutputStream(proc.outputStream)

    val stream = muxedSocket?.openStream()
    if (stream == null) {
      throw RuntimeException("Could not create stream")
    }
    val chan = consume(stream)

    // TODO: since and filter
    val req = ProtoRequestTail(table, since = 0u, filterExpr = null)
    stream.send(encodeProtoMsg(req))

    for (msg in chan) {
      when (msg) {
        is ProtoData -> {
          val data = msg.data
          stdin.write(data.array(), data.arrayOffset() + data.position(), data.remaining())
          if (msg.finFlagSet) {
            stdin.flush()
          }
        }
        else -> {
          throw RuntimeException("Unexpected message received in response")
        }
      }
    }
  }

  // TODO: this immediately returns control. currently no way to know
  // when we're 'syncd'
  fun establishLocalTail(table: String) {
    if (muxedSocket == null) {
      throw RuntimeException("Socket not opened")
    }

    val stream = muxedSocket?.openStream()
    if (stream == null) {
      throw RuntimeException("Could not create stream")
    }

    val req = ProtoPushPromise(table)
    stream.send(encodeProtoMsg(req))

    // TODO: should be able to close this proc on close()
    local.tail(
      user = "root", // TODO: user - pass this in?
      table,
      since = 0u,
      filter = null,
      replicationId = "123", // TODO: replication id
      { bytes, shouldFlush ->
        val msg = encodeProtoMsg(ProtoData(bytes, shouldFlush))
        stream.send(msg) },
      {
        // TODO: catastrophic failure
      })
  }
}
