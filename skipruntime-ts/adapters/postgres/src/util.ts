import { type Json, SkipError } from "@skipruntime/core";
import format from "pg-format";

/**
 * Exception indicating an error while establishing the connection between PostgreSQL and Skip.
 * @hideconstructor
 */
export class SkipPostgresError extends SkipError {}

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

  if (type == "TEXT")
    return {
      col,
      type,
      select: (table: string, key: string) =>
        format("SELECT * FROM %I WHERE %I = %L;", table, col, key),
    };

  const int32_MIN = -2147483648;
  const int32_MAX = 2147483647;
  const int16_MIN = -32768;
  const int16_MAX = 32767;

  let boundsCheck: (x: number) => boolean;
  switch (type) {
    case "BIGINT":
    case "INT8":
      boundsCheck = () => true;
      break;
    case "INTEGER":
    case "INT":
    case "INT4":
      boundsCheck = (x: number) => x >= int32_MIN && x <= int32_MAX;
      break;
    case "SMALLINT":
    case "INT2":
      boundsCheck = (x: number) => x >= int16_MIN && x <= int16_MAX;
      break;
    case "BIGSERIAL":
    case "SERIAL8":
      boundsCheck = (x: number) => x >= 1;
      break;
    case "SERIAL":
    case "SERIAL4":
      boundsCheck = (x: number) => x >= 1 && x <= int32_MAX;
      break;
    case "SMALLSERIAL":
    case "SERIAL2":
      boundsCheck = (x: number) => x >= 1 && x <= int16_MAX;
      break;
    default:
      throw new SkipPostgresError("Unsupported Postgres key type: " + type);
  }
  return {
    col,
    type,
    select: (table: string, key: string) => {
      const keyNum = Number(key);
      if (!Number.isSafeInteger(keyNum) || !boundsCheck(keyNum))
        throw new SkipPostgresError(`Invalid ${type} key: ${key}`);
      return format(
        "SELECT * FROM %I WHERE %I = " + keyNum.toString() + ";",
        table,
        col,
      );
    },
  };
}
