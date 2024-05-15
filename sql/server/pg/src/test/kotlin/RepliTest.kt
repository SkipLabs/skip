package io.skiplabs.skdb.pg

import io.skiplabs.skdb.openSkdb

fun main() {
  val skdb = openSkdb("test")!!
  val handler = PgToSkdbSync(skdb)
  val loop =
      PgEventLoop(
          url = "jdbc:postgresql://pg:5432/imdb",
          user = "postgres",
          password = "password",
          slot = "skdb_test",
          publication = "skdb_pub",
          delegate = handler::handleMsg)

  loop.start()
}
