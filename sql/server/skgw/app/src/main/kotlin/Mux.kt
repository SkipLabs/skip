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
import java.util.Arrays
import java.util.Base64
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicReference
import java.util.concurrent.locks.ReadWriteLock
import java.util.concurrent.locks.ReentrantReadWriteLock
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import org.xnio.ChannelListener

// TODO: this all has a blocking interface

interface MuxedSocketFactory {
  fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel): MuxedSocket
}

class MuxedSocketEndpoint(val socketFactory: MuxedSocketFactory) : WebSocketConnectionCallback {

  override fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel) {
    val muxedSocket = socketFactory.onConnect(exchange, channel)

    channel.receiveSetter.set(
        object : AbstractReceiveListener() {

          override fun getMaxPongBufferSize(): Long {
            return 1024
          }

          override fun getMaxCloseBufferSize(): Long {
            return 4096
          }

          override fun getMaxPingBufferSize(): Long {
            return 1024
          }

          override fun getMaxTextBufferSize(): Long {
            return 1024
          }

          override fun getMaxBinaryBufferSize(): Long {
            return 100L * 1024 * 1024;
          }

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
            if (cm.code == CloseMessage.NORMAL_CLOSURE || cm.code == CloseMessage.GOING_AWAY) {
              muxedSocket.onSocketClose()
            } else {
              muxedSocket.onSocketError(0u, "websocket closed unexpectedly")
            }
          }
        })

    // underlying tcp close
    channel.closeSetter.set(
        object : ChannelListener<Channel> {
          override fun handleEvent(channel: Channel): Unit {
            muxedSocket.onSocketClose()
          }
        })

    channel.resumeReceives()
  }
}

typealias onStreamFn = (MuxedSocket, Stream) -> Unit

typealias onDataFn = (ByteBuffer) -> Unit

typealias onSocketCloseFn = (MuxedSocket) -> Unit

typealias onStreamCloseFn = () -> Unit

typealias onSocketErrorFn = (MuxedSocket, UInt, String) -> Unit

typealias onStreamErrorFn = (UInt, String) -> Unit

sealed class MuxMsg

data class MuxAuthMsg(
    val version: UInt,
    val accessKey: String,
    val nonce: ByteArray,
    val signature: ByteArray,
    val deviceUuid: String,
    val date: String
) : MuxMsg()

data class MuxGoawayMsg(
    val lastStream: UInt,
    val errorCode: UInt,
    val msg: String,
) : MuxMsg()

class MuxPongMsg() : MuxMsg()

class MuxPingAlreadyHandledMsg() : MuxMsg()

data class MuxStreamDataMsg(val stream: UInt, val payload: ByteBuffer) : MuxMsg()

data class MuxStreamCloseMsg(val stream: UInt) : MuxMsg()

data class MuxStreamResetMsg(val stream: UInt, val errorCode: UInt, val msg: String) : MuxMsg()

class MuxedSocket(
    val socket: WebSocketChannel,
    val taskPool: ScheduledExecutorService,
    val onStream: onStreamFn,
    val onClose: onSocketCloseFn,
    val onError: onSocketErrorFn,
    val getDecryptedKey: (MuxAuthMsg) -> ByteArray,
    private val mutex: ReadWriteLock = ReentrantReadWriteLock(),
    private var authenticatedAt: Instant? = null,
    private var state: State = State.IDLE,
    private var nextStream: UInt = 2u,
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

  private val maxConnectionDuration: Duration = Duration.ofMinutes(10)
  private val timeout =
      taskPool.schedule(
          {
            // we use error rather than close to trigger error callback
            // per stream for cleanup. using close would rely on the
            // client gracefully responding with a close in order to free
            // resources
            this.errorSocket(1003u, "session timeout")
          },
          10,
          TimeUnit.MINUTES)

  // user-facing interface /////////////////////////////////////////////////////

  fun openStream(): Stream? {
    when (getState()) {
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
        mutex.writeLock().lock()
        try {
          activeStreams.put(nextStream, stream)
          nextStream = nextStream + 2u
        } finally {
          mutex.writeLock().unlock()
        }
        return stream
      }
    }
  }

  fun closeSocket() {
    when (getState()) {
      State.CLOSING,
      State.CLOSED -> {}
      State.IDLE -> {
        mutex.writeLock().lock()
        try {
          activeStreams.clear()
          state = State.CLOSED
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        socket.close()
      }
      State.CLOSE_WAIT -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          // we do not iterate over entries as we may remove them while iterating
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.close()
          }
          activeStreams.clear()
          state = State.CLOSED
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        socket.close()
      }
      State.AUTH_RECV -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.close()
          }
          state = State.CLOSING
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        socket.close()
      }
    }
    timeout.cancel(false)
  }

  fun errorSocket(errorCode: UInt, msg: String) {
    when (getState()) {
      State.CLOSING,
      State.CLOSED -> {
        mutex.writeLock().lock()
        try {
          activeStreams.clear()
          state = State.CLOSED
        } finally {
          mutex.writeLock().unlock()
        }
      }
      State.IDLE,
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            // this is different to closing. we just immediately trigger
            // callbacks on streams and only send the goaway for socket.
            // this is because erroring is not reciprocated by the client
            stream?.onStreamError(errorCode, msg)
          }
          activeStreams.clear()
          state = State.CLOSED
          val lastStream =
              if (nextStream - 2u > clientStreamWatermark) nextStream - 2u
              else clientStreamWatermark
          sendData(encodeGoawayMsg(lastStream, errorCode, msg))
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.PROTOCOL_ERROR, msg)
        socket.close()
      }
    }
    timeout.cancel(false)
  }

  // TODO: pingSocket() - we don't implement yet as we don't have a use
  // case and we should make this class async first

  // interface used by WS //////////////////////////////////////////////////////

  fun onSocketMessage(msg: ByteBuffer) {
    when (getState()) {
      State.CLOSE_WAIT,
      State.CLOSED -> {}
      State.IDLE -> {
        val muxMsg = decodeMsg(msg)
        when (muxMsg) {
          is MuxAuthMsg -> {
            if (!verify(muxMsg)) {
              errorSocket(1002u, "Authentication failed")
              return
            }
            mutex.writeLock().lock()
            try {
              state = State.AUTH_RECV
              authenticatedAt = Instant.now()
            } finally {
              mutex.writeLock().unlock()
            }
          }
          is MuxGoawayMsg -> onSocketError(muxMsg.errorCode, muxMsg.msg)
          is MuxStreamDataMsg,
          is MuxStreamCloseMsg,
          is MuxStreamResetMsg -> onSocketError(1001u, "Not yet authenticated")
          is MuxPongMsg,
          is MuxPingAlreadyHandledMsg -> {}
        }
      }
      State.AUTH_RECV,
      State.CLOSING -> {
        val now = Instant.now()
        if (Duration.between(authenticatedAt!!, now).abs().compareTo(maxConnectionDuration) > 0) {
          errorSocket(1003u, "session timeout")
        }

        val muxMsg = decodeMsg(msg)
        when (muxMsg) {
          // TODO: we may eventually allow this as a keep-alive
          is MuxAuthMsg -> onSocketError(1001u, "auth already received")
          is MuxGoawayMsg -> onSocketError(muxMsg.errorCode, muxMsg.msg)
          is MuxStreamResetMsg -> {
            val stream = getActiveStream(muxMsg.stream)
            stream?.onStreamError(muxMsg.errorCode, muxMsg.msg)
          }
          is MuxStreamCloseMsg -> {
            val stream = getActiveStream(muxMsg.stream)
            val closed = stream?.onStreamClose()
            if (closed != null && closed) {
              mutex.writeLock().lock()
              try {
                activeStreams.remove(muxMsg.stream)
              } finally {
                mutex.writeLock().unlock()
              }
            }
          }
          is MuxStreamDataMsg -> {
            var stream = getActiveStream(muxMsg.stream)
            if (stream == null && getState() == State.CLOSING) {
              return // we don't accept new streams while closing
            }

            mutex.writeLock().lock()
            try {
              if (stream == null &&
                  muxMsg.stream % 2u == 1u &&
                  muxMsg.stream > clientStreamWatermark) {
                // legitimate new stream
                clientStreamWatermark = muxMsg.stream
                stream = Stream(muxMsg.stream, this)
                activeStreams.put(muxMsg.stream, stream)
                onStream(this, stream)
              }
            } finally {
              mutex.writeLock().unlock()
            }

            stream?.onStreamData(muxMsg.payload)
          }
          is MuxPongMsg,
          is MuxPingAlreadyHandledMsg -> {}
        }
      }
    }
  }

  fun onSocketClose() {
    when (getState()) {
      State.CLOSED,
      State.CLOSE_WAIT -> {}
      State.IDLE,
      State.AUTH_RECV -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.onStreamClose()
          }
          state = State.CLOSE_WAIT
          onClose(this)
        } finally {
          mutex.writeLock().unlock()
        }
      }
      State.CLOSING -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.onStreamClose()
          }
          activeStreams.clear()
          state = State.CLOSED
          onClose(this)
        } finally {
          mutex.writeLock().unlock()
        }
      }
    }
    // we do not cancel the timeout here as this has only closed half
    // of the connection
  }

  fun onSocketError(errorCode: UInt, msg: String) {
    // mux gowaway, websocket close with error code, or tcp close
    when (getState()) {
      State.CLOSED -> {}
      State.IDLE,
      State.CLOSE_WAIT,
      State.AUTH_RECV,
      State.CLOSING -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.onStreamError(errorCode, msg)
          }
          activeStreams.clear()
          state = State.CLOSED
          onError(this, errorCode, msg)
        } finally {
          mutex.writeLock().unlock()
        }
      }
    }
    timeout.cancel(false)
  }

  // interface used by Stream //////////////////////////////////////////////////

  fun streamClose(streamId: UInt, nowClosed: Boolean) {
    when (getState()) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        sendData(encodeStreamCloseMsg(streamId))
        if (nowClosed) {
          mutex.writeLock().lock()
          try {
            activeStreams.remove(streamId)
          } finally {
            mutex.writeLock().unlock()
          }
        }
      }
    }
  }

  fun streamError(streamId: UInt, errorCode: UInt, msg: String) {
    when (getState()) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        sendData(encodeStreamErrorMsg(streamId, errorCode, msg))
        mutex.writeLock().lock()
        try {
          activeStreams.remove(streamId)
        } finally {
          mutex.writeLock().unlock()
        }
      }
    }
  }

  fun streamSend(streamId: UInt, data: ByteBuffer) {
    when (getState()) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH_RECV -> {
        sendData(encodeStreamDataMsg(streamId, data))
      }
    }
  }

  // internal //////////////////////////////////////////////////////////////////

  private fun getState(): State {
    try {
      mutex.readLock().lock()
      return state
    } finally {
      mutex.readLock().unlock()
    }
  }

  private fun getActiveStream(streamId: UInt): Stream? {
    try {
      mutex.readLock().lock()
      return activeStreams.get(streamId)
    } finally {
      mutex.readLock().unlock()
    }
  }

  private fun encodeGoawayMsg(lastStream: UInt, errorCode: UInt, msg: String): ByteBuffer {
    if (lastStream > 0xFFFFFFu) {
      throw IllegalArgumentException("lastStream too large")
    }
    val encoder = StandardCharsets.UTF_8.newEncoder()
    val buf = ByteBuffer.allocate(16 + msg.length * 4)
    buf.putInt(0x01000000) // type 1 and stream 0
    buf.putInt(lastStream.toInt())
    buf.putInt(errorCode.toInt())
    buf.putInt(0) // msg size placeholder - moves cursor

    var res = encoder.encode(CharBuffer.wrap(msg), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }

    buf.putInt(12, buf.position() - 16) // go back and fill msg size

    return buf.flip()
  }

  private fun encodePongMsg(): ByteBuffer {
    val buf = ByteBuffer.allocate(4)
    buf.putInt(0x06000000) // type 6 and stream 0
    return buf.flip()
  }

  private fun encodeStreamDataMsg(stream: UInt, data: ByteBuffer): ByteBuffer {
    if (stream > 0xFFFFFFu) {
      throw IllegalArgumentException("stream too large")
    }
    val buf = ByteBuffer.allocate(4 + data.remaining())
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
    val buf = ByteBuffer.allocate(12 + msg.length * 4)
    buf.putInt(((0x04u shl 24) or stream).toInt()) // type 4 and stream
    buf.putInt(errorCode.toInt())
    buf.putInt(0) // msg size placeholder - moves cursor

    var res = encoder.encode(CharBuffer.wrap(msg), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }

    buf.putInt(8, buf.position() - 12) // go back and fill msg size

    return buf.flip()
  }

  private fun decodeMsg(msg: ByteBuffer): MuxMsg {
    val typeAndStream = msg.getInt().toUInt()
    val type = typeAndStream shr 24
    val stream = typeAndStream and 0xFFFFFFu
    return when (type) {
      // auth
      0u -> {
        if (stream != 0u) {
          throw RuntimeException("Auth should happen on stream zero")
        }
        val version = (msg.getInt() ushr 24).toUInt()
        val accessKeyBytes = ByteArray(20)
        msg.get(accessKeyBytes)
        val zeroIdx = accessKeyBytes.indexOf(0)
        val accessKey =
            String(
                accessKeyBytes,
                0,
                if (zeroIdx == -1) accessKeyBytes.size else zeroIdx,
                StandardCharsets.US_ASCII)
        val nonce = ByteArray(8)
        msg.get(nonce)
        val signature = ByteArray(32)
        msg.get(signature)
        val deviceUuidBytes = ByteArray(36)
        msg.get(deviceUuidBytes)
        val deviceUuid = String(deviceUuidBytes, StandardCharsets.US_ASCII)
        val dateLength = msg.get().toUInt() and 0x1u
        val dateBytes = ByteArray(if (dateLength == 0u) 24 else 27)
        msg.get(dateBytes)
        val date = String(dateBytes, StandardCharsets.US_ASCII)
        MuxAuthMsg(version, accessKey, nonce, signature, deviceUuid, date)
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
      // ping
      5u -> {
        if (stream != 0u) {
          throw RuntimeException("Received ping on non-zero stream")
        }
        when (getState()) {
          State.IDLE,
          State.CLOSING,
          State.CLOSED -> {}
          State.CLOSE_WAIT,
          State.AUTH_RECV -> {
            sendData(encodePongMsg())
          }
        }
        MuxPingAlreadyHandledMsg()
      }
      // pong
      6u -> {
        if (stream != 0u) {
          throw RuntimeException("Received pong on non-zero stream")
        }
        MuxPongMsg()
      }
      // we throw as the server is assumed to always be ahead of clients
      else -> throw RuntimeException("Could not decode mux layer msg")
    }
  }

  private fun verify(auth: MuxAuthMsg): Boolean {
    val algo = "HmacSHA256"

    try {
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

      val privateKey = getDecryptedKey(auth)

      mac.init(SecretKeySpec(privateKey, algo))
      val ourSig = mac.doFinal(contentBytes)

      // at least try to keep the private key in memory for as little time as possible
      privateKey.fill(0)

      return Arrays.equals(ourSig, auth.signature)
    } catch (ex: Exception) {
      return false
    }
  }

  private fun sendClose(code: Int, reason: String) {
    if (socket.isOpen()) {
      WebSockets.sendCloseBlocking(code, reason, socket)
    }
  }

  private fun sendData(data: ByteBuffer) {
    if (socket.isOpen()) {
      WebSockets.sendBinaryBlocking(data, socket)
    }
  }
}

class Stream(
    val streamId: UInt,
    val socket: MuxedSocket,
    var onData: onDataFn = { _ -> },
    var onClose: onStreamCloseFn = {},
    var onError: onStreamErrorFn = { _, _ -> },
    private var state: AtomicReference<State> = AtomicReference(State.OPEN),
) {
  enum class State {
    OPEN,
    CLOSING,
    CLOSEWAIT,
    CLOSED,
  }

  // user-facing interface /////////////////////////////////////////////////////

  fun close() {
    when (state.get()) {
      State.CLOSING,
      State.CLOSED -> {}
      State.OPEN -> {
        state.set(State.CLOSING)
        socket.streamClose(streamId, nowClosed = false)
      }
      State.CLOSEWAIT -> {
        state.set(State.CLOSED)
        socket.streamClose(streamId, nowClosed = true)
      }
      null -> throw RuntimeException()
    }
  }

  fun error(errorCode: UInt, msg: String) {
    when (state.get()) {
      State.CLOSING,
      State.CLOSED -> {
        state.set(State.CLOSED)
      }
      State.OPEN,
      State.CLOSEWAIT -> {
        state.set(State.CLOSED)
        socket.streamError(streamId, errorCode, msg)
      }
      null -> throw RuntimeException()
    }
  }

  fun send(data: ByteBuffer) {
    when (state.get()) {
      State.CLOSING,
      State.CLOSED -> {}
      State.OPEN,
      State.CLOSEWAIT -> {
        socket.streamSend(streamId, data)
      }
      null -> throw RuntimeException()
    }
  }

  // interface used by MuxedSocket /////////////////////////////////////////////

  fun onStreamClose(): Boolean {
    return when (state.get()) {
      State.CLOSED -> true
      State.CLOSEWAIT -> false
      State.CLOSING -> {
        state.set(State.CLOSED)
        onClose()
        true
      }
      State.OPEN -> {
        state.set(State.CLOSEWAIT)
        onClose()
        false
      }
      null -> throw RuntimeException()
    }
  }

  fun onStreamError(errorCode: UInt, msg: String) {
    when (state.get()) {
      State.CLOSED -> {}
      State.CLOSEWAIT,
      State.CLOSING,
      State.OPEN -> {
        state.set(State.CLOSED)
        onError(errorCode, msg)
      }
      null -> throw RuntimeException()
    }
  }

  fun onStreamData(data: ByteBuffer) {
    when (state.get()) {
      State.CLOSED,
      State.CLOSEWAIT -> {}
      State.CLOSING,
      State.OPEN -> {
        onData(data)
      }
      null -> throw RuntimeException()
    }
  }
}
