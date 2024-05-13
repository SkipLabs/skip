package io.skiplabs.skdb.pg

import java.sql.DriverManager
import java.util.Properties
import java.util.concurrent.TimeUnit
import org.postgresql.PGConnection
import org.postgresql.PGProperty

@kotlin.ExperimentalStdlibApi
fun connect(url: String) {
  val props = Properties()
  PGProperty.USER.set(props, "postgres")
  PGProperty.PASSWORD.set(props, "password")
  PGProperty.ASSUME_MIN_SERVER_VERSION.set(props, "9.4")
  PGProperty.REPLICATION.set(props, "database")
  PGProperty.PREFER_QUERY_MODE.set(props, "simple")

  val con = DriverManager.getConnection(url, props)
  val replConnection = con.unwrap(PGConnection::class.java)

  // creates the slot, but not the publication
  // replConnection
  //     .getReplicationAPI()
  //     .createReplicationSlot()
  //     .logical()
  //     .withSlotName("test")
  //     .withOutputPlugin("pgoutput")
  //     // .withOutputPlugin("test_decoding")
  //     .make()

  // query
  // con.setAutoCommit(true)
  // val st = con.createStatement()
  // val res =
  //     st.executeQuery(
  //         "select m.info, i.info as key from movie_info as m join info_type as i on m.info_type_id = i.id limit 10;")
  // res.next()
  // val x = res.getString("key")
  // println(": [foksp] : ${x}")
  // st.close()

  // get the stream
  val stream =
      replConnection
          .getReplicationAPI()
          .replicationStream()
          .logical()
          .withSlotName("skdb_test")
          .withSlotOption("proto_version", 1)
          .withSlotOption("publication_names", "skdb_pub")
          .withSlotOption("messages", true)
          .withStatusInterval(20, TimeUnit.SECONDS)
          .start()

  // process it
  while (true) {
    // non blocking receive message
    val msg = stream.read()

    // TODO: can it be null? when?
    if (msg == null) {
      continue
    }

    val offset = msg.arrayOffset()
    val source = msg.array()
    val length = source.size - offset
    val buf = ByteArray(length)
    msg.get(buf)
    println(buf.toHexString(HexFormat.Default))

    // feedback
    stream.setAppliedLSN(stream.getLastReceiveLSN())
    stream.setFlushedLSN(stream.getLastReceiveLSN())
  }
}
