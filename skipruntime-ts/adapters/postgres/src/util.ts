import { type Json, SkipError } from "@skipruntime/core";
import format from "pg-format";

const PG_TIMESTAMP_RE =
  /^(\d{4,})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})(\.\d+)?(?:Z|([+-])(\d{2})(?::?(\d{2}))?(?::(\d{2}))?)?( BC)?$/;

/**
 * Normalize a PostgreSQL `TIMESTAMP` or `TIMESTAMPTZ` text-format value to an
 * ECMAScript-compatible ISO 8601 UTC string (`YYYY-MM-DDTHH:mm:ss.sssZ`).
 *
 * Values without an explicit timezone offset (`TIMESTAMP` without time zone)
 * are interpreted as UTC so the output is independent of the host timezone.
 * Special values such as `infinity` / `-infinity` or unrecognized strings are
 * returned unchanged.
 *
 * @param value - Raw timestamp string returned by PostgreSQL.
 * @returns The normalized ISO 8601 UTC string, or `value` unchanged if unrecognized.
 */
export function pgTimestampToISO(value: string): string {
  const match = PG_TIMESTAMP_RE.exec(value);
  if (!match) return value;

  const [
    ,
    yearStr,
    monthStr,
    dayStr,
    hourStr,
    minStr,
    secStr,
    fracStr,
    tzSign,
    tzHour,
    tzMin,
    tzSec,
    bc,
  ] = match;

  let year = Number(yearStr);
  if (bc) year = -(year - 1);

  const month = Number(monthStr);
  const day = Number(dayStr);
  const hour = Number(hourStr);
  const minute = Number(minStr);
  const second = Number(secStr);
  const ms = fracStr ? Number(fracStr.slice(1, 4).padEnd(3, "0")) : 0;

  if (
    month < 1 ||
    month > 12 ||
    day < 1 ||
    day > 31 ||
    hour > 23 ||
    minute > 59 ||
    second > 59
  ) {
    return value;
  }

  const date = new Date(
    Date.UTC(year, month - 1, day, hour, minute, second, ms),
  );
  if (year >= 0 && year < 100) {
    date.setUTCFullYear(year);
  }
  if (
    Number.isNaN(date.getTime()) ||
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    return value;
  }
  if (tzSign) {
    const tzH = Number(tzHour);
    const tzM = Number(tzMin ?? "0");
    const tzS = Number(tzSec ?? "0");
    if (tzH > 23 || tzM > 59 || tzS > 59) return value;
    const sign = tzSign === "-" ? -1 : 1;
    const offsetMs = (tzH * 3600 + tzM * 60 + tzS) * 1000 * sign;
    date.setTime(date.getTime() - offsetMs);
  }
  return Number.isNaN(date.getTime()) ? value : date.toISOString();
}

/**
 * Exception indicating an error while establishing the connection between PostgreSQL and Skip.
 * @hideconstructor
 */
export class SkipPostgresError extends SkipError {}

/**
 * Postgres data types supported for use as Skip collection keys.
 */
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
