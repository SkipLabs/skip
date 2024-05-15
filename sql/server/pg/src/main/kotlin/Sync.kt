package io.skiplabs.skdb.pg

import io.skiplabs.skdb.OutputFormat
import io.skiplabs.skdb.Skdb
import java.io.BufferedWriter

// TODO: might be better using the write-csv interface?

class PgToSkdbSync(val skdb: Skdb) {
  private var currentProc: Process? = null
  private var currentWriter: BufferedWriter? = null

  fun handleMsg(msg: PgMsg, relations: Map<UInt, PgRelation>) {
    when (msg) {
      is PgBegin -> {
        if (currentProc != null) {
          currentProc?.destroy()
        }
        currentProc = skdb.sqlStream(OutputFormat.RAW)
        currentWriter = currentProc!!.outputWriter()
        // currentWriter!!.write("BEGIN TRANSACTION;\n")
      }
      is PgCommit -> {
        // currentWriter!!.write("COMMIT;")
        currentWriter!!.flush()
        currentWriter!!.close()
        currentWriter = null
        currentProc = null
      }
      is PgInsert -> {
        val relation = relations.get(msg.relationId)
        if (relation == null) {
          throw RuntimeException("Could not find relation for ${msg.relationId}")
        }

        val table = relation.relation

        val tuple = msg.new
        when (tuple) {
          is PgTupleNew -> {
            val cols = tuple.cols
            // TODO: should be using parameters rather than splicing
            val valueList =
                cols
                    .mapIndexed { idx, colValue ->
                      when (colValue) {
                        is PgTupleNull -> "NULL"
                        is PgTupleUnchangedToast ->
                            throw RuntimeException("Unexpected data type unchanged in insert")
                        is PgTupleText -> {
                          val v = colValue.data
                          val colType = relation.cols.get(idx).dataType
                          when (colType) {
                            PgGeneralisedDataType.BOOL -> {
                              if (v in
                                  arrayOf(
                                      "TRUE",
                                      "'t'",
                                      "'true'",
                                      "'y'",
                                      "'yes'",
                                      "'on'",
                                      "'1'",
                                  )) {
                                "1"
                              } else {
                                "0"
                              }
                            }
                            PgGeneralisedDataType.INT -> v
                            PgGeneralisedDataType.FLOAT -> v
                            PgGeneralisedDataType.TEXT -> "'${v}'"
                            PgGeneralisedDataType.UNSUPPORTED -> {
                              // TODO:
                              throw RuntimeException("Could not insert unsupported data type")
                            }
                          }
                        }
                      }
                    }
                    .joinToString(",", prefix = "(", postfix = ")")

            val colList =
                relation.cols.map { it.name }.joinToString(",", prefix = "(", postfix = ")")

            val sqlInsert = "INSERT INTO ${table} ${colList} VALUES ${valueList};\n"
            currentWriter!!.write(sqlInsert)
          }
          else -> throw RuntimeException("Unexpected tuple type for insert: ${tuple}")
        }
      }
      else -> {
        // TODO:
        System.err.println("WARNING: dropping ${msg}")
      }
    }
  }
}
