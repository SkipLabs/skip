import { type Json, SkipError } from "@skipruntime/core";
import format from "pg-format";

/**
 * Exception indicating an error while establishing the connection between PostgreSQL and Skip.
 * @hideconstructor
 */
export class SkipPostgresError extends SkipError {}

const min32bitInt = -2147483648;
const max32bitInt = 2147483647;
const min16bitInt = -32768;
const max16bitInt = 32767;

export type PostgresPKey =
  | "TEXT"
  | "SERIAL"
  | "SERIAL2"
  | "SERIAL4"
  | "SERIAL8"
  | "BIGSERIAL"
  | "SMALLSERIAL"
  | "INTEGER"
  | "INT"
  | "INT2"
  | "INT4"
  | "INT8"
  | "BIGINT"
  | "SMALLINT";

/**
 * Validate that a specified key column is of a legal type, and return a function to produce a select-query for that key column.
 */

export function validateKeyParam(params: Json): {
  col: string;
  type: string;
  select: (table: string, key: string) => string;
} {
  if (
    typeof params != "object" ||
    !("key" in params) ||
    typeof params["key"] != "object" ||
    params["key"] == null
  )
    throw new SkipPostgresError(
      "No key specified for external Postgres data source",
    );

  if (!("col" in params["key"]) || typeof params["key"]["col"] != "string")
    throw new SkipPostgresError(
      "No key column specified for external Postgres data source",
    );
  const col: string = params["key"]["col"];

  if (!("type" in params["key"]) || typeof params["key"]["type"] != "string")
    throw new SkipPostgresError(
      "No key type specified for external Postgres data source",
    );
  const type: string = params["key"]["type"];

  let select;
  switch (type) {
    case "TEXT":
      select = (table: string, key: string) =>
        format("SELECT * FROM %I WHERE %I = %L;", table, col, key);
      break;
    case "BIGSERIAL":
    case "SERIAL8":
    case "BIGINT":
    case "INT8":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 64-bit integer (and positive, if serial)
        if (
          !Number.isSafeInteger(keyNum) ||
          (keyNum < 1 && ["BIGSERIAL", "SERIAL8"].includes(type))
        )
          throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    case "SERIAL":
    case "SERIAL4":
    case "INTEGER":
    case "INT":
    case "INT4":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 32-bit integer (and positive, if serial)
        if (
          !Number.isSafeInteger(keyNum) ||
          keyNum < min32bitInt ||
          keyNum > max32bitInt ||
          (keyNum < 1 && ["SERIAL", "SERIAL4"].includes(type))
        )
          throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    case "SMALLSERIAL":
    case "SERIAL2":
    case "SMALLINT":
    case "INT2":
      select = (table: string, key: string) => {
        const keyNum = Number(key);
        // Checks if key is a safe 16-bit integer (and positive, if serial)
        if (
          !Number.isSafeInteger(keyNum) ||
          keyNum < min16bitInt ||
          keyNum > max16bitInt ||
          (keyNum < 1 && ["SERIAL2", "SMALLSERIAL"].includes(type))
        )
          throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
        return format(
          "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
          table,
          col,
        );
      };
      break;
    default:
      throw new SkipPostgresError("Unsupported Postgres key type: " + type);
  }
  return { col, type, select };
}
