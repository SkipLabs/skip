package io.skiplabs.skdb.pg

import java.sql.DriverManager
import java.util.Properties
import java.util.concurrent.TimeUnit
import org.postgresql.PGConnection
import org.postgresql.PGProperty
import org.postgresql.replication.PGReplicationStream

// manages a PG logical replication stream, decoding
// and processing messages
// - active object, should be closed. start() takes ownership of the
//   current thread to run the loop
class PgEventLoop(
    val url: String,
    val user: String,
    val password: String,
    val slot: String,
    val publication: String
) {

  // TODO: not thread safe
  private var stream: PGReplicationStream? = null

  fun start() {
    if (stream != null) {
      throw RuntimeException("stream already started")
    }
    stream = startStream()

    while (true) {
      // TODO: what happens on close? I probably need to do something
      // smarter here. need a thread safe way of exiting the loop
      val msg = stream!!.read()

      // TODO: can it be null? docs say no. what happens on stream close?
      if (msg == null) {
        return
      }

      val pgMsg = decodeMsg(msg)
      // TODO: maybe this should be async, for better I/O and
      // parallelisation. some messages should be handled inline and
      // blocking to build the stream state in sequence - e.g.
      // relations
      process(pgMsg)

      // TODO:
      stream!!.setAppliedLSN(stream!!.getLastReceiveLSN())
      stream!!.setFlushedLSN(stream!!.getLastReceiveLSN())
    }
  }

  fun close() {
    stream!!.close()
  }

  private fun startStream(): PGReplicationStream {
    val props = Properties()
    PGProperty.USER.set(props, user)
    PGProperty.PASSWORD.set(props, password)
    // logical replication added in pg 9.4
    PGProperty.ASSUME_MIN_SERVER_VERSION.set(props, "9.4")
    PGProperty.REPLICATION.set(props, "database")
    PGProperty.PREFER_QUERY_MODE.set(props, "simple")

    val con = DriverManager.getConnection(url, props)
    val replConnection = con.unwrap(PGConnection::class.java)

    return replConnection
        .getReplicationAPI()
        .replicationStream()
        .logical()
        .withSlotName(slot)
        .withSlotOption("proto_version", 1)
        .withSlotOption("publication_names", publication)
        .withSlotOption("messages", true)
        .withStatusInterval(20, TimeUnit.SECONDS)
        .start()
  }

  private fun process(msg: PgMsg) {
    println(": [spznk] msg: ${msg}")
  }
}
