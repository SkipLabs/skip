package io.skiplabs.skgw

import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.ConcurrentMap
import java.util.concurrent.atomic.AtomicInteger

// this factors out policy and monitoring from mechanism
interface ServerPolicy {
  fun shouldAcceptConnection(db: String): Boolean

  // you can then hook in to socket events by using socket.observeLifecycle
  fun notifySocketCreated(socket: MuxedSocket, db: String)
}

// no policy. useful for subclasses that want to define partial policy
// -- template method pattern -- or as the default in composition
open class NullServerPolicy : ServerPolicy {
  override fun shouldAcceptConnection(db: String): Boolean {
    return true
  }

  override fun notifySocketCreated(socket: MuxedSocket, db: String) {}
}

val MAX_CONNECTIONS: UInt = 10_000u

class LimitGlobalConnections(val maxConns: UInt = MAX_CONNECTIONS) : NullServerPolicy() {

  val n: AtomicInteger = AtomicInteger(0)

  override fun shouldAcceptConnection(db: String): Boolean {
    val n = n.get()
    val acceptable = n < maxConns.toInt()
    if (!acceptable) {
      System.err.println("Rejecting conn as ${n} >= ${maxConns}")
    }
    return acceptable
  }

  override fun notifySocketCreated(socket: MuxedSocket, db: String) {
    n.incrementAndGet()
    socket.observeLifecycle { state ->
      when (state) {
        MuxedSocket.State.CLOSED -> n.decrementAndGet()
        MuxedSocket.State.IDLE,
        MuxedSocket.State.AUTH_RECV,
        MuxedSocket.State.CLOSING,
        MuxedSocket.State.CLOSE_WAIT -> Unit
      }
    }
  }
}

class LimitConnectionsPerDb(val maxConnsPerDatabase: UInt) : NullServerPolicy() {

  val openConns: ConcurrentMap<String, Int> = ConcurrentHashMap()

  override fun notifySocketCreated(socket: MuxedSocket, db: String) {
    val n = openConns.merge(db, 1) { oldvalue, _ -> oldvalue + 1 } ?: 1

    socket.observeLifecycle { state ->
      when (state) {
        MuxedSocket.State.CLOSED -> openConns.merge(db, 0) { oldvalue, _ -> oldvalue - 1 }
        MuxedSocket.State.IDLE,
        MuxedSocket.State.AUTH_RECV,
        MuxedSocket.State.CLOSING,
        MuxedSocket.State.CLOSE_WAIT -> Unit
      }
    }

    if (n > maxConnsPerDatabase.toInt()) {
      socket.errorSocket(2000u, "Database connection limit reached")
    }
  }
}

class LimitConnectionsPerUser(val maxConnsPerUser: UInt) : NullServerPolicy() {

  data class DbUser(val user: String, val db: String)

  val openConns: ConcurrentMap<DbUser, Int> = ConcurrentHashMap()

  override fun notifySocketCreated(socket: MuxedSocket, db: String) {
    socket.observeLifecycle { state ->
      val user = socket.authenticatedWith?.msg?.accessKey

      if (user != null) {
        val key = DbUser(user, db)
        when (state) {
          MuxedSocket.State.CLOSED -> {
            openConns.merge(key, 0) { oldvalue, _ ->
              val n = oldvalue - 1
              if (n < 1) null else n
            }
          }
          MuxedSocket.State.AUTH_RECV -> {
            val n = openConns.merge(key, 1) { oldvalue, _ -> oldvalue + 1 }
            if (n != null && n > maxConnsPerUser.toInt()) {
              socket.errorSocket(2000u, "User connection limit reached")
            }
          }
          MuxedSocket.State.IDLE,
          MuxedSocket.State.CLOSING,
          MuxedSocket.State.CLOSE_WAIT -> Unit
        }
      }
    }
  }
}
