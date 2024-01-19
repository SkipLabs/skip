package io.skiplabs.skdb

import java.io.FileInputStream
import java.nio.file.Files
import java.nio.file.Paths
import java.util.Optional
import java.util.Properties

val USER_CONFIG_FILE = ".skdb.conf"
var ENV = UserConfig.create()
val SERVICE_MGMT_DB_NAME = "skdb_service_mgmt"
val SKDB_PORT = 3586

class UserConfig(
    val port: Int,
    val skdbPath: String,
    val skdbInitPath: String,
    val skdbDatabases: String,
    val addCredFormat: String,
) {
  companion object {
    val SKDB = "/skdb/build/skdb"
    val SKDB_INIT = "/skdb/build/init.sql"
    val SKDB_DATABASES = "/var/db"
    val SKDB_ADD_CRED =
        "cd /skdb/build/package && npx skdb-cli --add-cred --host ws://localhost:%d --db %s --access-key %s <<< \"%s\""

    private fun userConfigFile(): Optional<String> {
      var path = Paths.get("").toAbsolutePath()
      while (path != null) {
        var file = path.resolve(USER_CONFIG_FILE)
        if (Files.exists(file)) {
          return Optional.of(file.toString())
        }
        path = path.getParent()
      }
      return Optional.empty()
    }

    fun fromFile(file: String): UserConfig {
      FileInputStream(file).use {
        var prop = Properties()
        // load a properties file
        prop.load(it)
        return UserConfig(
            Integer.parseInt(prop.getProperty("skdb_port", "" + SKDB_PORT)),
            prop.getProperty("skdb", SKDB),
            prop.getProperty("skdb_init", SKDB_INIT),
            prop.getProperty("skdb_databases", SKDB_DATABASES),
            prop.getProperty("skdb_add_cred", SKDB_ADD_CRED),
        )
      }
    }

    fun create(port: Int = SKDB_PORT): UserConfig {
      var user_config_file = userConfigFile()
      if (user_config_file.isPresent()) {
        return fromFile(user_config_file.get())
      }
      return UserConfig(
          port,
          SKDB,
          SKDB_INIT,
          SKDB_DATABASES,
          SKDB_ADD_CRED,
      )
    }
  }

  fun resolveDbPath(db: String): String {
    return Paths.get(this.skdbDatabases).resolve(db + ".db").toString()
  }
}
