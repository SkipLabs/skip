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
      is PgRelation -> {} // handled for us
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
                      val colDef = relation.cols.get(idx)
                      serialiseValue(colValue, colDef)
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
      is PgDelete -> {
        val relation = relations.get(msg.relationId)
        if (relation == null) {
          throw RuntimeException("Could not find relation for ${msg.relationId}")
        }
        val table = relation.relation
        val tuple = msg.old
        when (tuple) {
          is PgTupleKey -> {
            val cols = tuple.cols
            val colDefs = relation.cols
            val matchExpr =
                cols
                    .mapIndexedNotNull { idx, colValue ->
                      if (!(colValue is PgTupleText)) {
                        null
                      } else {
                        val colDef = colDefs.get(idx)
                        "${colDef.name} = ${serialiseValue(colValue, colDef)}"
                      }
                    }
                    .joinToString(" AND ")

            val sqlDelete = "DELETE FROM ${table} WHERE ${matchExpr};\n"
            currentWriter!!.write(sqlDelete)
          }
          is PgTupleFull -> {
            val cols = tuple.cols
            val matchExpr =
                cols
                    .mapIndexed { idx, colValue ->
                      val colDef = relation.cols.get(idx)
                      "${colDef.name} = ${serialiseValue(colValue, colDef)}"
                    }
                    .joinToString(" AND ")

            val sqlDelete = "DELETE FROM ${table} WHERE ${matchExpr};\n"
            currentWriter!!.write(sqlDelete)
          }
          else -> throw RuntimeException("Unexpected tuple type for delete: ${tuple}")
        }
      }
      is PgUpdate -> {
        val relation = relations.get(msg.relationId)
        if (relation == null) {
          throw RuntimeException("Could not find relation for ${msg.relationId}")
        }
        val table = relation.relation
        val oldTuple = msg.old
        val newTuple = msg.new

        val matchExpr =
            if (oldTuple == null) {
              // the key did not change so we can extract it from the new tuple
              val colDefs = relation.cols
              if (!(newTuple is PgTupleNew)) {
                throw RuntimeException("Unexpected type for new tuple in update: ${newTuple}")
              }
              val colValues = newTuple.cols
              colDefs
                  .mapIndexedNotNull { idx, def ->
                    if (def.isKey) {
                      val colValue = colValues.get(idx)
                      "${def.name} = ${serialiseValue(colValue, def)}"
                    } else {
                      null
                    }
                  }
                  .joinToString(" AND ")
            } else {
              when (oldTuple) {
                is PgTupleKey -> {
                  val colDefs = relation.cols
                  oldTuple.cols
                      .mapIndexedNotNull { idx, colValue ->
                        if (!(colValue is PgTupleText)) {
                          null
                        } else {
                          val colDef = colDefs.get(idx)
                          "${colDef.name} = ${serialiseValue(colValue, colDef)}"
                        }
                      }
                      .joinToString(" AND ")
                }
                is PgTupleFull -> {
                  oldTuple.cols
                      .mapIndexed { idx, colValue ->
                        val colDef = relation.cols.get(idx)
                        "${colDef.name} = ${serialiseValue(colValue, colDef)}"
                      }
                      .joinToString(" AND ")
                }
                else ->
                    throw RuntimeException("Unexpected tuple type for update previous: ${oldTuple}")
              }
            }

        val setExpr =
            when (newTuple) {
              is PgTupleNew -> {
                newTuple.cols
                    .mapIndexedNotNull { idx, colValue ->
                      val colDef = relation.cols.get(idx)
                      "${colDef.name} = ${serialiseValue(colValue, colDef)}"
                    }
                    .joinToString(",")
              }
              else -> throw RuntimeException("Unexpected tuple type for update new: ${newTuple}")
            }

        val sqlUpdate = "UPDATE ${table} SET ${setExpr} WHERE ${matchExpr};\n"
        currentWriter!!.write(sqlUpdate)
      }
      // TODO:
      is PgTruncate -> {}
      else -> {
        // TODO:
        System.err.println("WARNING: skdb sync dropping ${msg}")
      }
    }
  }
}

fun serialiseValue(colValue: PgTupleData, colDef: PgColumn): String {
  return when (colValue) {
    is PgTupleNull -> "NULL"
    is PgTupleUnchangedToast -> throw RuntimeException("Unexpected data type unchanged in insert")
    is PgTupleText -> {
      val v = colValue.data
      val colType = colDef.dataType
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
