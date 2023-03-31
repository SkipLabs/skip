package io.skiplabs.skgw

import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedBinaryMessage
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.CloseMessage
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.WebSockets
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.channels.Channel
import java.nio.charset.StandardCharsets
import java.time.Duration
import java.time.Instant
import java.util.Base64
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import org.xnio.ChannelListener

// TODO: this all has a blocking interface

// TODO: none of this is thread safe. the assumption is that it all
// runs in callbacks on a sharded thread

interface MuxedSocketFactory {
  fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel): MuxedSocket
}

class MuxedSocketEndpoint(val socketFactory: MuxedSocketFactory) : WebSocketConnectionCallback {

  override fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel) {
    val muxedSocket = socketFactory.onConnect(exchange, channel)

    channel.receiveSetter.set(
        object : AbstractReceiveListener() {
          override fun onFullTextMessage(channel: WebSocketChannel, message: BufferedTextMessage) {
            throw RuntimeException("Unexpected text message received.")
          }
          override fun onFullBinaryMessage(
              channel: WebSocketChannel,
              message: BufferedBinaryMessage
          ) {
            val buf = WebSockets.mergeBuffers(*message.data.resource)
            muxedSocket.onSocketMessage(buf)
          }

          // websocket close or error
          override fun onCloseMessage(cm: CloseMessage, channel: WebSocketChannel) {
            if (cm.code == CloseMessage.NORMAL_CLOSURE) {
              muxedSocket.onSocketClose()
            } else {
              muxedSocket.onSocketError(0u, "websocket closed")
            }
          }
        })

    // underlying tcp close
    channel.closeSetter.set(
        object : ChannelListener<Channel> {
          override fun handleEvent(channel: Channel): Unit {
            muxedSocket.onSocketError(0u, "tcp socket closed")
          }
        })

    channel.resumeReceives()
  }
}

typealias onStreamFn = (Stream) -> Unit

typealias onDataFn = (ByteBuffer) -> Unit

typealias onCloseFn = () -> Unit

typealias onErrorFn = (UInt, String) -> Unit

sealed class MuxMsg

data class MuxAuthMsg(
    val version: UInt,
    val accessKey: String,
    val nonce: ByteArray,
    val signature: ByteArray,
    val date: String
) : MuxMsg()

data class MuxGoawayMsg(
    val lastStream: UInt,
    val errorCode: UInt,
    val msg: String,
) : MuxMsg()

data class MuxStreamDataMsg(val stream: UInt, val payload: ByteBuffer) : MuxMsg()

data class MuxStreamCloseMsg(val stream: UInt) : MuxMsg()

data class MuxStreamResetMsg(val stream: UInt, val errorCode: UInt, val msg: String) : MuxMsg()

class MuxedSocket(
    val onStream: onStreamFn,
    val onClose: onCloseFn,
    val onError: onErrorFn,
    val socket: WebSocketChannel,
    val getDecryptedKey: (String) -> ByteArray,
    private var state: State = State.IDLE,
    private var nextStream: UInt = 1u,
    private var clientStreamWatermark: UInt = 0u,
    private val activeStreams: MutableMap<UInt, Stream> = HashMap(),
) {
  enum class State {
    IDLE,
    AUTH_RECV,
    CLOSING,
    CLOSE_WAIT,
    CLOSED
  }

  // user-facing interface /////////////////////////////////////////////////////

  fun openStream(): Stream? {
    when (state) {
      State.IDLE,
      State.CLOSE_WAIT -> {
        return null
      }
      State.CLOSED,
      State.CLOSING -> {
        throw RuntimeException("Connection closed")
      }
      State.AUTH_RECV -> {
        val stream = Stream(nextStream, this)
        activeStreams.put(nextStream, stream)
        nextStream = nextStream + 2u
        return stream
      }
    }
  }

  fun closeSocket() {
    when (state) {
      State.CLOSING,
      State.CLOSED -> {}
      State.IDLE -> {
        activeStreams.clear()
        state = State.CLOSED
        WebSockets.sendCloseBlocking(CloseMessage.NORMAL_CLOSURE, "", socket)
        socket.close()
      }
      State.CLOSE_WAIT -> {
        for (stream in activeStreams.values) {
          stream.close()
        }
        activeStreams.clear()
        state = State.CLOSED
        WebSockets.sendCloseBlocking(CloseMessage.NORMAL_CLOSURE, "", socket)
        socket.close()
      }
      State.AUTH_RECV -> {
        for (stream in activeStreams.values) {
          stream.close()
        }
        state = State.CLOSING
        WebSockets.sendCloseBlocking(CloseMessage.NORMAL_CLOSURE, "", socket)
        socket.close()
      }
    }
  }

  fun errorSocket(errorCode: UInt, msg: String) {
    when (state) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {
        activeStreams.clear()
        state = State.CLOSED
      }
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        for (stream in activeStreams.values) {
          stream.error(errorCode, msg)
        }
        activeStreams.clear()
        state = State.CLOSED
        val lastStream =
            if (nextStream - 2u > clientStreamWatermark) nextStream - 2u else clientStreamWatermark
        WebSockets.sendBinaryBlocking(encodeGoawayMsg(lastStream, errorCode, msg), socket)
        WebSockets.sendCloseBlocking(CloseMessage.PROTOCOL_ERROR, msg, socket)
        socket.close()
      }
    }
  }

  // interface used by WS //////////////////////////////////////////////////////

  fun onSocketMessage(msg: ByteBuffer) {
    when (state) {
      State.CLOSE_WAIT,
      State.CLOSED -> {}
      State.IDLE -> {
        val muxMsg = decodeMsg(msg)
        when (muxMsg) {
          is MuxAuthMsg -> {
            if (!verify(muxMsg)) {
              onSocketError(3u, "Authentication failed")
              return
            }
            state = State.AUTH_RECV
          }
          is MuxGoawayMsg -> onSocketError(muxMsg.errorCode, muxMsg.msg)
          is MuxStreamDataMsg,
          is MuxStreamCloseMsg,
          is MuxStreamResetMsg -> onSocketError(1u, "Not yet authenticated")
        }
      }
      State.AUTH_RECV,
      State.CLOSING -> {
        val muxMsg = decodeMsg(msg)
        when (muxMsg) {
          // TODO: we may eventually allow this as a keep-alive
          is MuxAuthMsg -> onSocketError(2u, "auth already received")
          is MuxGoawayMsg -> onSocketError(muxMsg.errorCode, muxMsg.msg)
          is MuxStreamResetMsg -> {
            val stream = activeStreams.get(muxMsg.stream)
            stream?.onStreamError(muxMsg.errorCode, muxMsg.msg)
          }
          is MuxStreamCloseMsg -> {
            val stream = activeStreams.get(muxMsg.stream)
            val closed = stream?.onStreamClose()
            if (closed != null && closed) {
              activeStreams.remove(muxMsg.stream)
            }
          }
          is MuxStreamDataMsg -> {
            var stream = activeStreams.get(muxMsg.stream)
            if (stream == null && state == State.CLOSING) {
              return // we don't accept new streams while closing
            }

            if (stream == null &&
                muxMsg.stream % 2u == 1u &&
                muxMsg.stream > clientStreamWatermark) {
              // legitimate new stream
              clientStreamWatermark = muxMsg.stream
              stream = Stream(muxMsg.stream, this)
              activeStreams.put(muxMsg.stream, stream)
              onStream(stream)
            }

            stream?.onStreamData(muxMsg.payload)
          }
        }
      }
    }
  }

  fun onSocketClose() {
    when (state) {
      State.CLOSED,
      State.CLOSE_WAIT -> {}
      State.IDLE,
      State.AUTH_RECV -> {
        for (stream in activeStreams.values) {
          stream.onStreamClose()
        }
        onClose()
        state = State.CLOSE_WAIT
      }
      State.CLOSING -> {
        for (stream in activeStreams.values) {
          stream.onStreamClose()
        }
        onClose()
        activeStreams.clear()
        state = State.CLOSED
      }
    }
  }

  fun onSocketError(errorCode: UInt, msg: String) {
    // mux gowaway, websocket close with error code, or tcp close
    when (state) {
      State.CLOSED -> {}
      State.IDLE,
      State.CLOSE_WAIT,
      State.AUTH_RECV,
      State.CLOSING -> {
        for (stream in activeStreams.values) {
          stream.onStreamError(errorCode, msg)
        }
        onError(errorCode, msg)
        activeStreams.clear()
        state = State.CLOSED
      }
    }
  }

  // interface used by Stream //////////////////////////////////////////////////

  fun streamClose(streamId: UInt, nowClosed: Boolean) {
    when (state) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        WebSockets.sendBinaryBlocking(encodeStreamCloseMsg(streamId), socket)
        if (nowClosed) {
          activeStreams.remove(streamId)
        }
      }
    }
  }

  fun streamError(streamId: UInt, errorCode: UInt, msg: String) {
    when (state) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        WebSockets.sendBinaryBlocking(encodeStreamErrorMsg(streamId, errorCode, msg), socket)
        activeStreams.remove(streamId)
      }
    }
  }

  fun streamSend(streamId: UInt, data: ByteBuffer) {
    when (state) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        WebSockets.sendBinaryBlocking(encodeStreamDataMsg(streamId, data), socket)
      }
    }
  }

  // internal //////////////////////////////////////////////////////////////////

  private fun encodeGoawayMsg(lastStream: UInt, errorCode: UInt, msg: String): ByteBuffer {
    if (lastStream > 0xFFFFFFu) {
      throw IllegalArgumentException("lastStream too large")
    }
    val encoder = StandardCharsets.UTF_8.newEncoder()
    val buf = ByteBuffer.allocate(16 + msg.length * 3)
    buf.putInt(0x01000000) // type 1 and stream 0
    buf.putInt(lastStream.toInt())
    buf.putInt(errorCode.toInt())
    buf.putInt(0) // msg size placeholder - moves cursor

    var res = encoder.encode(CharBuffer.wrap(msg), buf, true)
    res.throwException()
    res = encoder.flush(buf)
    res.throwException()

    buf.putInt(12, buf.position() - 16) // go back and fill msg size

    return buf.flip()
  }

  private fun encodeStreamDataMsg(stream: UInt, data: ByteBuffer): ByteBuffer {
    if (stream > 0xFFFFFFu) {
      throw IllegalArgumentException("stream too large")
    }
    val buf = ByteBuffer.allocate(4)
    buf.putInt(((0x02u shl 24) or stream).toInt()) // type and stream
    buf.put(data)
    return buf.flip()
  }

  private fun encodeStreamCloseMsg(stream: UInt): ByteBuffer {
    if (stream > 0xFFFFFFu) {
      throw IllegalArgumentException("stream too large")
    }
    val buf = ByteBuffer.allocate(4)
    buf.putInt(((0x03u shl 24) or stream).toInt()) // type and stream
    return buf.flip()
  }

  private fun encodeStreamErrorMsg(stream: UInt, errorCode: UInt, msg: String): ByteBuffer {
    if (stream > 0xFFFFFFu) {
      throw IllegalArgumentException("stream too large")
    }
    val encoder = StandardCharsets.UTF_8.newEncoder()
    val buf = ByteBuffer.allocate(12 + msg.length * 3)
    buf.putInt(((0x04u shl 24) or stream).toInt()) // type 4 and stream
    buf.putInt(errorCode.toInt())
    buf.putInt(0) // msg size placeholder - moves cursor

    var res = encoder.encode(CharBuffer.wrap(msg), buf, true)
    res.throwException()
    res = encoder.flush(buf)
    res.throwException()

    buf.putInt(8, buf.position() - 12) // go back and fill msg size

    return buf.flip()
  }

  private fun decodeMsg(msg: ByteBuffer): MuxMsg {
    val typeAndStream = msg.getInt().toUInt()
    val type = typeAndStream shr 24
    val stream = typeAndStream or 0xFFFFFFu
    return when (type) {
      // auth
      0u -> {
        if (stream != 0u) {
          throw RuntimeException("Auth should happen on stream zero")
        }
        val version = (msg.getInt() ushr 24).toUInt()
        val accessKeyBytes = ByteArray(20)
        msg.get(accessKeyBytes)
        val accessKey = String(accessKeyBytes, StandardCharsets.US_ASCII)
        val nonce = ByteArray(8)
        msg.get(nonce)
        val signature = ByteArray(32)
        msg.get(signature)
        val dateLength = msg.get().toUInt() and 0x1u
        val dateBytes = ByteArray(if (dateLength == 0u) 24 else 27)
        msg.get(dateBytes)
        val date = String(dateBytes, StandardCharsets.US_ASCII)
        MuxAuthMsg(version, accessKey, nonce, signature, date)
      }
      // goaway
      1u -> {
        if (stream != 0u) {
          throw RuntimeException("Goaway should happen on stream zero")
        }
        val lastStream = (msg.getInt() and 0xFFFFFF).toUInt()
        val errorCode = msg.getInt().toUInt()
        val msgLength = msg.getInt()
        val msgBytes = ByteArray(msgLength)
        msg.get(msgBytes)
        val errorMsg = String(msgBytes, StandardCharsets.UTF_8)
        MuxGoawayMsg(lastStream, errorCode, errorMsg)
      }
      // stream data
      2u -> MuxStreamDataMsg(stream, msg.slice())
      // stream close
      3u -> MuxStreamCloseMsg(stream)
      // stream reset
      4u -> {
        val errorCode = msg.getInt().toUInt()
        val msgLength = msg.getInt()
        val msgBytes = ByteArray(msgLength)
        msg.get(msgBytes)
        val errorMsg = String(msgBytes, StandardCharsets.UTF_8)
        MuxStreamResetMsg(stream, errorCode, errorMsg)
      }
      // we throw as the server is assumed to always be ahead of clients
      else -> throw RuntimeException("Could not decode msg")
    }
  }

  private fun verify(auth: MuxAuthMsg): Boolean {
    val algo = "HmacSHA256"

    val now = Instant.now()
    val d = Instant.parse(auth.date)
    // delta represents physical timeline time, regardless of calendars and clock shifts
    val delta = Duration.between(d, now)

    // do not allow auths that were not recent. the margin is for clock skew.
    if (delta.abs().compareTo(Duration.ofMinutes(10)) > 0) {
      return false
    }

    // TODO: check nonce against a cache to prevent replay attacks

    val nonce = Base64.getEncoder().encodeToString(auth.nonce)
    val content: String = "auth" + auth.accessKey + auth.date + nonce
    val contentBytes = content.toByteArray(Charsets.UTF_8)

    val mac = Mac.getInstance(algo)

    val privateKey = getDecryptedKey(auth.accessKey)

    mac.init(SecretKeySpec(privateKey, algo))
    val ourSig = mac.doFinal(contentBytes)

    // at least try to keep the private key in memory for as little time as possible
    privateKey.fill(0)

    return ourSig == auth.signature
  }
}

class Stream(
    val streamId: UInt,
    val socket: MuxedSocket,
    var onData: onDataFn = {},
    var onClose: onCloseFn = {},
    var onError: onErrorFn = { _, _ -> },
    private var state: State = State.OPEN,
) {
  enum class State {
    OPEN,
    CLOSING,
    CLOSEWAIT,
    CLOSED,
  }

  fun close() {
    when (state) {
      State.CLOSING,
      State.CLOSED -> {}
      State.OPEN -> {
        state = State.CLOSING
        socket.streamClose(streamId, nowClosed = false)
      }
      State.CLOSEWAIT -> {
        state = State.CLOSED
        socket.streamClose(streamId, nowClosed = true)
      }
    }
  }

  fun error(errorCode: UInt, msg: String) {
    when (state) {
      State.CLOSING,
      State.CLOSED -> {
        state = State.CLOSED
      }
      State.OPEN,
      State.CLOSEWAIT -> {
        state = State.CLOSED
        socket.streamError(streamId, errorCode, msg)
      }
    }
  }

  fun send(data: ByteBuffer) {
    when (state) {
      State.CLOSING,
      State.CLOSED -> {}
      State.OPEN,
      State.CLOSEWAIT -> {
        socket.streamSend(streamId, data)
      }
    }
  }

  fun onStreamClose(): Boolean {
    return when (state) {
      State.CLOSED -> true
      State.CLOSEWAIT -> false
      State.CLOSING -> {
        state = State.CLOSED
        onClose()
        true
      }
      State.OPEN -> {
        state = State.CLOSEWAIT
        onClose()
        false
      }
    }
  }

  fun onStreamError(errorCode: UInt, msg: String) {
    when (state) {
      State.CLOSED -> {}
      State.CLOSEWAIT,
      State.CLOSING,
      State.OPEN -> {
        state = State.CLOSED
        onError(errorCode, msg)
      }
    }
  }

  fun onStreamData(data: ByteBuffer) {
    when (state) {
      State.CLOSED,
      State.CLOSEWAIT -> {}
      State.CLOSING,
      State.OPEN -> {
        onData(data)
      }
    }
  }
}
