package io.skiplabs.skgw

// this factors out policy and monitoring from mechanism
interface ServerPolicy {
  fun shouldAcceptConnection(db: String): Boolean

  // you can then hook in to socket events by using socket.observeLifecycle
  fun notifySocketCreated(socket: MuxedSocket, db: String)
}

// no policy. also useful for subclasses that want to define partial
// policy -- template method pattern
open class NullServerPolicy : ServerPolicy {
  override fun shouldAcceptConnection(db: String): Boolean {
    return true
  }

  override fun notifySocketCreated(socket: MuxedSocket, db: String) {}
}
