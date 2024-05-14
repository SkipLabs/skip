package io.skiplabs.skdb.pg

fun main() {
  val loop =
      PgEventLoop(
          url = "jdbc:postgresql://pg:5432/imdb",
          user = "postgres",
          password = "password",
          slot = "skdb_test",
          publication = "skdb_pub")
  loop.start()
}
