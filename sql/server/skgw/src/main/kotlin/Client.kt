package io.skiplabs.skdb.client

import io.skiplabs.skdb.Credentials
import io.skiplabs.skdb.MuxedSocket
import io.skiplabs.skdb.ProtoData
import io.skiplabs.skdb.ProtoMessage
import io.skiplabs.skdb.ProtoPushPromise
import io.skiplabs.skdb.ProtoQuery
import io.skiplabs.skdb.ProtoRequestTail
import io.skiplabs.skdb.ProtoSchemaQuery
import io.skiplabs.skdb.QueryResponseFormat
import io.skiplabs.skdb.SchemaScope
import io.skiplabs.skdb.Skdb
import io.skiplabs.skdb.Stream
import io.skiplabs.skdb.connectMux
import io.skiplabs.skdb.decodeProtoMsg
import io.skiplabs.skdb.encodeProtoMsg
import java.io.BufferedOutputStream
import java.net.URI
import java.nio.CharBuffer
import java.nio.charset.StandardCharsets
import java.util.concurrent.ScheduledExecutorService
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.channels.onFailure
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.coroutineScope

class SkdbConnection(
    val endpoint: URI,
    val creds: Credentials,
    val local: Skdb,
    val taskPool: ScheduledExecutorService,
    val replicationId: UInt,
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

  suspend fun runRemoteTail(
      table: String,
      control: SendChannel<ProtoData>,
      since: ULong = 0u,
      filterExpr: String? = null
  ) {
    if (muxedSocket == null) {
      throw RuntimeException("Socket not opened")
    }

    val stream = muxedSocket?.openStream()
    if (stream == null) {
      throw RuntimeException("Could not create stream")
    }

    val proc =
        local.writeCsv(
            user = "root",
            table,
            replicationId.toString(),
            { bytes, shouldFlush ->
              // client does not send acks back to the server. but
              // useful to report back for tracking
              val msg = ProtoData(bytes, shouldFlush)
              control.trySendBlocking(msg).onFailure { throwable ->
                System.err.println("Failed to enqueue on to a channel: ${throwable}")
              }
            },
            { stream.error(2000u, "Process unexpected EOF") })
    try {
      val stdin = BufferedOutputStream(proc.outputStream)

      val chan = consume(stream)

      val req = ProtoRequestTail(table, since, filterExpr)
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
            control.close(RuntimeException("Unexpected message received in response"))
          }
        }
      }
    } finally {
      proc.destroy()
      control.close()
    }
  }

  suspend fun runLocalTail(table: String, control: SendChannel<ProtoData>) {
    if (muxedSocket == null) {
      throw RuntimeException("Socket not opened")
    }

    val stream = muxedSocket?.openStream()
    if (stream == null) {
      throw RuntimeException("Could not create stream")
    }

    val req = ProtoPushPromise(table)
    stream.send(encodeProtoMsg(req))

    val chan = consume(stream)

    val proc =
        local.tail(
            user = "root",
            table,
            since = 0u,
            filter = null,
            replicationId.toString(),
            { bytes, shouldFlush ->
              val msg = encodeProtoMsg(ProtoData(bytes, shouldFlush))
              stream.send(msg)
            },
            { stream.error(2000u, "Process unexpected EOF") })

    try {
      for (msg in chan) {
        when (msg) {
          is ProtoData -> {
            control.send(msg)
          }
          else -> {
            control.close(RuntimeException("Unexpected message received in response"))
          }
        }
      }
    } finally {
      proc.destroy()
      control.close()
    }
  }
}
