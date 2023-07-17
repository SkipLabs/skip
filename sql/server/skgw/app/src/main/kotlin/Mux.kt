package io.skiplabs.skgw

import io.undertow.websockets.WebSocketConnectionCallback
import io.undertow.websockets.core.AbstractReceiveListener
import io.undertow.websockets.core.BufferedBinaryMessage
import io.undertow.websockets.core.BufferedTextMessage
import io.undertow.websockets.core.CloseMessage
import io.undertow.websockets.core.WebSocketChannel
import io.undertow.websockets.core.WebSockets
import io.undertow.websockets.spi.WebSocketHttpExchange
import java.net.URI
import java.nio.ByteBuffer
import java.nio.CharBuffer
import java.nio.channels.Channel
import java.nio.charset.StandardCharsets
import java.security.SecureRandom
import java.time.Duration
import java.time.Instant
import java.time.ZoneOffset
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.util.Arrays
import java.util.Base64
import java.util.Queue
import java.util.UUID
import java.util.concurrent.ConcurrentLinkedQueue
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicReference
import java.util.concurrent.locks.ReadWriteLock
import java.util.concurrent.locks.ReentrantReadWriteLock
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine
import org.java_websocket.client.WebSocketClient
import org.java_websocket.handshake.ServerHandshake
import org.xnio.ChannelListener

data class Credentials(
    val accessKey: String,
    val privateKey: ByteArray,
    val encryptedPrivateKey: ByteArray,
    val deviceUuid: String? = null,
) {
  fun b64privateKey(): String = Base64.getEncoder().encodeToString(privateKey)
  fun b64encryptedKey(): String = Base64.getEncoder().encodeToString(encryptedPrivateKey)
  fun clear(): Unit {
    privateKey.fill(0)
    encryptedPrivateKey.fill(0)
  }
  override fun toString(): String {
    return "Credentials(accessKey=${accessKey}, privateKey=**redacted**, deviceId=${deviceUuid})"
  }

  fun sign(nonce: ByteArray, date: String): ByteArray {
    val nonce64 = Base64.getEncoder().encodeToString(nonce)
    val content: String = "auth" + accessKey + date + nonce64
    val contentBytes = content.toByteArray(Charsets.UTF_8)

    val algo = "HmacSHA256"
    val mac = Mac.getInstance(algo)

    mac.init(SecretKeySpec(privateKey, algo))
    return mac.doFinal(contentBytes)
  }
}

interface MuxedSocketFactory {
  fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocket): MuxedSocket
}

class MuxedSocketEndpoint(val socketFactory: MuxedSocketFactory) : WebSocketConnectionCallback {

  override fun onConnect(exchange: WebSocketHttpExchange, channel: WebSocketChannel) {
    val muxedSocket = socketFactory.onConnect(exchange, WebSocketChannelAdapter(channel))

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
            return 100L * 1024 * 1024
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

class MuxedSocketClient(val uri: URI) : WebSocketClient(uri) {
  var socket: MuxedSocket? = null

  private var openContinuation: Continuation<MuxedSocketClient>? = null

  override fun onOpen(handshake: ServerHandshake) {
    if (openContinuation != null) {
      val cont = openContinuation
      openContinuation = null
      cont?.resume(this)
    }
  }

  override fun onMessage(msg: String) {
    throw RuntimeException("Received text data: ${msg}")
  }

  override fun onMessage(buf: ByteBuffer) {
    socket?.onSocketMessage(buf)
  }

  override fun onClose(code: Int, reason: String, remote: Boolean) {
    if (openContinuation != null) {
      openContinuation?.resumeWithException(
          RuntimeException("Close received while waiting for open"))
      openContinuation = null
      return
    }

    if (code == CloseMessage.NORMAL_CLOSURE || code == CloseMessage.GOING_AWAY) {
      socket?.onSocketClose()
    } else {
      socket?.onSocketError(0u, "websocket closed unexpectedly")
    }
  }

  override fun onError(ex: Exception) {
    if (openContinuation != null) {
      openContinuation?.resumeWithException(ex)
      openContinuation = null
      return
    }
    socket?.onSocketError(0u, "websocket error")
  }

  suspend fun open(muxSocket: MuxedSocket) = suspendCoroutine { cont ->
    socket = muxSocket
    openContinuation = cont
    this.connect()
  }
}

typealias onStreamFn = (MuxedSocket, Stream) -> Unit

typealias onDataFn = (ByteBuffer) -> Unit

typealias onSocketCloseFn = (MuxedSocket) -> Unit

typealias onStreamCloseFn = () -> Unit

typealias onSocketErrorFn = (MuxedSocket, UInt, String) -> Unit

typealias onStreamErrorFn = (UInt, String) -> Unit

typealias MuxedSocketLogger = (event: String, user: String, metadata: String?) -> Unit

sealed class MuxMsg

data class MuxAuthMsg(
    val version: UInt,
    val accessKey: String,
    val nonce: ByteArray,
    val signature: ByteArray,
    val deviceUuid: String,
    val date: String,
    val clientVersion: String,
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

interface WebSocket {
  fun close()
  fun sendData(data: ByteBuffer)
  fun sendClose(code: Int, reason: String)
  fun suspendReceives()
  fun resumeReceives()
}

// server from undertow
class WebSocketChannelAdapter(val channel: WebSocketChannel) : WebSocket {
  override fun close() {
    channel.close()
  }

  override fun sendData(data: ByteBuffer) {
    if (channel.isOpen()) {
      WebSockets.sendBinaryBlocking(data, channel)
    }
  }

  override fun sendClose(code: Int, reason: String) {
    if (channel.isOpen()) {
      WebSockets.sendCloseBlocking(code, reason, channel)
    }
  }

  override fun suspendReceives() {
    channel.suspendReceives()
  }

  override fun resumeReceives() {
    channel.resumeReceives()
  }
}

// client from java_websocket
class WebSocketClientAdapter(val client: WebSocketClient) : WebSocket {
  override fun close() {
    client.close()
  }

  override fun sendData(data: ByteBuffer) {
    client.send(data)
  }

  override fun sendClose(code: Int, reason: String) {
    client.close(code, reason)
  }

  override fun suspendReceives() {
    throw UnsupportedOperationException()
  }

  override fun resumeReceives() {
    throw UnsupportedOperationException()
  }
}

class MuxedSocket(
    val channel: WebSocket,
    val taskPool: ScheduledExecutorService,
    val onStream: onStreamFn,
    val onClose: onSocketCloseFn,
    val onError: onSocketErrorFn,
    val getDecryptedKey: (MuxAuthMsg) -> ByteArray = { _ ->
      throw RuntimeException("Acting as a client initated socket")
    },
    val isClient: Boolean = false,
    val log: MuxedSocketLogger = { _, _, _ -> },
) {
  enum class State {
    IDLE,
    AUTH,
    CLOSING,
    CLOSE_WAIT,
    CLOSED
  }

  data class AuthWith(val msg: MuxAuthMsg, val at: Instant)

  private val mutex: ReadWriteLock = ReentrantReadWriteLock()
  var authenticatedWith: AuthWith? = null
    get() =
        try {
          mutex.readLock().lock()
          field
        } finally {
          mutex.readLock().unlock()
        }
  private var state: State = State.IDLE
  private var nextStream: UInt = if (isClient) 1u else 2u
  private var otherStreamWatermark: UInt = 0u
  private val activeStreams: MutableMap<UInt, Stream> = HashMap()
  private var observers: MutableList<(State) -> Unit> = ArrayList()

  data class MuxedSocketEnd(val error: Boolean, val code: UInt?, val msg: String?)
  var endState: MuxedSocketEnd? = null
    get() =
        try {
          mutex.readLock().lock()
          field
        } finally {
          mutex.readLock().unlock()
        }

  private val maxConnectionDuration: Duration = Duration.ofMinutes(10)
  private var timeout: ScheduledFuture<*>? = null
  init {
    if (!isClient) {
      timeout =
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
    }
  }

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
      State.AUTH -> {
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
          endState = MuxedSocketEnd(false, null, null)
          setState(State.CLOSED)
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        channel.close()
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
          endState = MuxedSocketEnd(false, null, null)
          setState(State.CLOSED)
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        channel.close()
      }
      State.AUTH -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.close()
          }
          setState(State.CLOSING)
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.NORMAL_CLOSURE, "")
        channel.close()
      }
    }
    timeout?.cancel(false)
  }

  fun errorSocket(errorCode: UInt, msg: String) {
    when (getState()) {
      State.CLOSING,
      State.CLOSED -> {
        mutex.writeLock().lock()
        try {
          activeStreams.clear()
          endState = MuxedSocketEnd(true, errorCode, msg)
          setState(State.CLOSED)
        } finally {
          mutex.writeLock().unlock()
        }
      }
      State.IDLE,
      State.CLOSE_WAIT,
      State.AUTH -> {
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
          endState = MuxedSocketEnd(true, errorCode, msg)
          setState(State.CLOSED)
          val lastStream =
              if (nextStream - 2u > otherStreamWatermark) nextStream - 2u else otherStreamWatermark
          sendData(encodeGoawayMsg(lastStream, errorCode, msg))
        } finally {
          mutex.writeLock().unlock()
        }
        sendClose(CloseMessage.PROTOCOL_ERROR, msg)
        channel.close()
      }
    }
    timeout?.cancel(false)
  }

  // TODO: pingSocket() - we don't implement yet as we don't have a use
  // case and we should make this class async first

  fun observeLifecycle(callback: (State) -> Unit) {
    // callback should be thread-safe, no guarantees as to what thread
    // this is called on.
    mutex.writeLock().lock()
    try {
      // the mutex is held while calling callback.
      observers.add(callback)
    } finally {
      mutex.writeLock().unlock()
    }
  }

  fun sendAuth(creds: Credentials) {
    when (getState()) {
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH -> {
        throw RuntimeException("Trying to send an auth message on an authenticated socket.")
      }
      State.IDLE -> {
        val csrng = SecureRandom()
        val nonce = ByteArray(8)
        csrng.nextBytes(nonce)
        // javascript iso date format is _based_ on iso8601 but not fully compliant. yep.
        val date =
            ZonedDateTime.now(ZoneOffset.UTC)
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        val authMsg =
            MuxAuthMsg(
                version = 0u,
                accessKey = creds.accessKey,
                nonce = nonce,
                signature = creds.sign(nonce, date),
                deviceUuid = creds.deviceUuid ?: UUID.randomUUID().toString(),
                date = date,
                clientVersion = "kt-0.0.1", // TODO: this should be passed from above
            )
        mutex.writeLock().lock()
        try {
          authenticatedWith = AuthWith(authMsg, Instant.now())
          setState(State.AUTH)
        } finally {
          mutex.writeLock().unlock()
        }
        sendData(encodeAuthMsg(authMsg))
      }
    }
  }

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
              authenticatedWith = AuthWith(muxMsg, Instant.now())
              setState(State.AUTH)
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
      State.AUTH,
      State.CLOSING -> {
        if (!isClient) {
          val now = Instant.now()
          if (Duration.between(authenticatedWith?.at!!, now)
              .abs()
              .compareTo(maxConnectionDuration) > 0) {
            errorSocket(1003u, "session timeout")
          }
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
                  muxMsg.stream % 2u == (if (isClient) 0u else 1u) &&
                  muxMsg.stream > otherStreamWatermark) {
                // legitimate new stream
                otherStreamWatermark = muxMsg.stream
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
      State.AUTH -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.onStreamClose()
          }
          setState(State.CLOSE_WAIT)
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
          endState = MuxedSocketEnd(false, null, null)
          setState(State.CLOSED)
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
      State.AUTH,
      State.CLOSING -> {
        mutex.writeLock().lock()
        try {
          val keys = activeStreams.keys.toSet()
          for (key in keys) {
            val stream = activeStreams.get(key)
            stream?.onStreamError(errorCode, msg)
          }
          activeStreams.clear()
          endState = MuxedSocketEnd(true, errorCode, msg)
          setState(State.CLOSED)
          onError(this, errorCode, msg)
        } finally {
          mutex.writeLock().unlock()
        }
      }
    }
    timeout?.cancel(false)
  }

  // interface used by Stream //////////////////////////////////////////////////

  fun streamClose(streamId: UInt, nowClosed: Boolean) {
    when (getState()) {
      State.IDLE,
      State.CLOSING,
      State.CLOSED -> {}
      State.CLOSE_WAIT,
      State.AUTH -> {
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
      State.AUTH -> {
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
      State.AUTH -> {
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

  private fun setState(state: State) {
    // invariant: should be holding mutex.writeLock before calling this
    if (this.state == state) {
      return
    }
    this.state = state
    for (observer in observers) {
      observer(state)
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

  private fun encodeAuthMsg(msg: MuxAuthMsg): ByteBuffer {
    val encoder = StandardCharsets.US_ASCII.newEncoder()
    val buf = ByteBuffer.allocate(133 + msg.clientVersion.length)
    buf.putInt(0x0) // type 0 and stream 0
    buf.putInt(0x0) // mux protocol version
    // access key
    if (msg.accessKey.length > 20) {
      throw RuntimeException("accessKey ${msg.accessKey} too long")
    }
    var res = encoder.encode(CharBuffer.wrap(msg.accessKey), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    encoder.reset()
    buf.position(28) // rely on buf being zeroed out and set position to support short keys
    // nonce
    buf.put(msg.nonce)
    // signature
    buf.put(msg.signature)
    // uuid
    res = encoder.encode(CharBuffer.wrap(msg.deviceUuid), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    encoder.reset()
    // date
    when (msg.date.length) {
      24 -> {
        buf.put(0x0)
      }
      27 -> {
        buf.put(0x1)
      }
      else -> throw RuntimeException("Date ${msg.date} cannot be encoded")
    }
    res = encoder.encode(CharBuffer.wrap(msg.date), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    encoder.reset()
    // client version
    if (msg.clientVersion.length > 255) {
      throw RuntimeException("Cannot encode client version ${msg.clientVersion}, too long")
    }
    buf.put(msg.clientVersion.length.toByte())
    res = encoder.encode(CharBuffer.wrap(msg.clientVersion), buf, true)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    res = encoder.flush(buf)
    if (!res.isUnderflow()) {
      res.throwException()
    }
    encoder.reset()
    return buf.flip()
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
        val clientVersionLength = msg.get()
        val clientVersionBytes = ByteArray(clientVersionLength.toInt())
        msg.get(clientVersionBytes)
        val clientVersion = String(clientVersionBytes, StandardCharsets.US_ASCII)
        MuxAuthMsg(version, accessKey, nonce, signature, deviceUuid, date, clientVersion)
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
          State.AUTH -> {
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
    try {
      val now = Instant.now()
      val d = Instant.parse(auth.date)
      // delta represents physical timeline time, regardless of calendars and clock shifts
      val delta = Duration.between(d, now)

      // do not allow auths that were not recent. the margin is for clock skew.
      if (delta.abs().compareTo(Duration.ofMinutes(10)) > 0) {
        log("auth_failure", auth.accessKey, "too_old")
        return false
      }

      // TODO: check nonce against a cache to prevent replay attacks

      val creds = Credentials(auth.accessKey, getDecryptedKey(auth), ByteArray(0), auth.deviceUuid)
      val matches = Arrays.equals(creds.sign(auth.nonce, auth.date), auth.signature)

      // at least try to keep the private key in memory for as little time as possible
      creds.clear()

      if (!matches) {
        log("auth_failure", auth.accessKey, "bad_sig")
      }

      return matches
    } catch (ex: Exception) {
      log("auth_failure", auth.accessKey, ex.message)
      return false
    }
  }

  private fun sendClose(code: Int, reason: String) {
    channel.sendClose(code, reason)
  }

  private fun sendData(data: ByteBuffer) {
    channel.sendData(data)
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

  private var observers: Queue<(State) -> Unit> = ConcurrentLinkedQueue()

  data class StreamEnd(val error: Boolean, val code: UInt?, val msg: String?)
  var endState: AtomicReference<StreamEnd> = AtomicReference(null)
    get() = field

  // user-facing interface /////////////////////////////////////////////////////

  fun close() {
    when (state.get()) {
      State.CLOSING,
      State.CLOSED -> {}
      State.OPEN -> {
        setState(State.CLOSING)
        socket.streamClose(streamId, nowClosed = false)
      }
      State.CLOSEWAIT -> {
        endState.set(StreamEnd(false, null, null))
        setState(State.CLOSED)
        socket.streamClose(streamId, nowClosed = true)
      }
      null -> throw RuntimeException()
    }
  }

  fun error(errorCode: UInt, msg: String) {
    endState.set(StreamEnd(true, errorCode, msg))
    when (state.get()) {
      State.CLOSING,
      State.CLOSED -> {
        setState(State.CLOSED)
      }
      State.OPEN,
      State.CLOSEWAIT -> {
        setState(State.CLOSED)
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

  fun observeLifecycle(callback: (State) -> Unit) {
    observers.add(callback)
  }

  // interface used by MuxedSocket /////////////////////////////////////////////

  fun onStreamClose(): Boolean {
    return when (state.get()) {
      State.CLOSED -> true
      State.CLOSEWAIT -> false
      State.CLOSING -> {
        endState.set(StreamEnd(false, null, null))
        setState(State.CLOSED)
        onClose()
        true
      }
      State.OPEN -> {
        setState(State.CLOSEWAIT)
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
        endState.set(StreamEnd(true, errorCode, msg))
        setState(State.CLOSED)
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

  // internal //////////////////////////////////////////////////////////////////

  fun setState(s: State) {
    state.set(s)
    for (observer in observers) {
      observer(s)
    }
  }
}

suspend fun connectMux(
    endpoint: URI,
    taskPool: ScheduledExecutorService,
    onStream: onStreamFn,
    onClose: onSocketCloseFn,
    onError: onSocketErrorFn,
    creds: Credentials,
): MuxedSocket {
  val client = MuxedSocketClient(endpoint)
  val socket =
      MuxedSocket(
          channel = WebSocketClientAdapter(client),
          taskPool,
          onStream,
          onClose,
          onError,
          isClient = true,
      )
  client.open(socket)
  socket.sendAuth(creds)
  return socket
}
