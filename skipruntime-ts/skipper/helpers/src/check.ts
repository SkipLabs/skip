import type { Json, JsonObject, Entry } from "@skipruntime/core";
import type { JsonPartialObject } from "@skipruntime/core/json.js";
import { AuthenticationError } from "./errors.js";

export type PartialObject = {
  [key: string]: Json | null | undefined;
};

/**
 * Narrow a `Json` value to its object variants (`JsonObject` /
 * `JsonPartialObject`). Sole reason this exists: a bare
 * `Array.isArray(v)` guard does NOT narrow against `readonly Json[]`
 * inside a `Json` union — `Array.isArray` is typed as `value is any[]`
 * and TS does not equate `any[]` with `readonly Json[]`, so a check
 * like `if (Array.isArray(v)) return …` leaves the array variant in
 * the union afterwards. Passing the value through this predicate
 * works because the user-defined `value is JsonObject | JsonPartialObject`
 * signature lets TS strip the array variant explicitly.
 * @returns a boolean that indicate if it's a JsonObject
 */
export function isJsonObject(
  value: Json,
): value is JsonObject | JsonPartialObject {
  return typeof value === "object" && !Array.isArray(value);
}

/**
 * Symmetric companion of `isJsonObject`. Same TS-narrowing rationale —
 * the `value is readonly Json[]` annotation narrows the union the way
 * `Array.isArray` alone does not.
 * @returns a boolean that indicate if it's a Json[]
 */
export function isJsonArray(value: Json): value is readonly Json[] {
  return Array.isArray(value);
}

export function expectPositiveNumber(
  value: unknown,
  path: string = "",
): number {
  const v = expectNumber(value, path);
  if (v < 0) throw new TypeError(message(path, "positive number", value));
  return v;
}
// Type guard for number
export function expectNumber(value: unknown, path: string = ""): number {
  if (typeof value === "number" && !Number.isNaN(value)) return value;
  throw new TypeError(message(path, "number", value));
}

// Type guard for string
export function expectString(value: unknown, path: string = ""): string {
  if (typeof value === "string") return value;
  throw new TypeError(message(path, "string", value));
}

const kEmailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const kUuidPattern =
  /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;
const kDatePattern = /^\d{4}-\d{2}-\d{2}$/;
const kHostnamePattern =
  /^(?=.{1,253}$)(?!-)[a-zA-Z0-9-]{1,63}(?<!-)(\.(?!-)[a-zA-Z0-9-]{1,63}(?<!-))*$/;
const kIpv4Pattern =
  /^(25[0-5]|2[0-4]\d|[01]?\d\d?)(\.(25[0-5]|2[0-4]\d|[01]?\d\d?)){3}$/;

// Type guard for a string constrained by an OpenAPI `format` keyword.
// Unknown formats fall through to a plain string check so callers can
// emit `expectStringFormat(v, "<any>")` without breaking — only the
// formats listed below add a runtime constraint.
export function expectStringFormat(
  value: unknown,
  format: string,
  path: string = "",
): string {
  const s = expectString(value, path);
  switch (format) {
    case "uri":
    case "uri-reference":
    case "url": {
      try {
        new URL(s);
      } catch {
        throw new TypeError(message(path, `string<${format}>`, value));
      }
      return s;
    }
    case "email":
      if (!kEmailPattern.test(s))
        throw new TypeError(message(path, "string<email>", value));
      return s;
    case "uuid":
      if (!kUuidPattern.test(s))
        throw new TypeError(message(path, "string<uuid>", value));
      return s;
    case "date":
      if (!kDatePattern.test(s) || Number.isNaN(Date.parse(s)))
        throw new TypeError(message(path, "string<date>", value));
      return s;
    case "date-time":
      if (Number.isNaN(Date.parse(s)))
        throw new TypeError(message(path, "string<date-time>", value));
      return s;
    case "hostname":
      if (!kHostnamePattern.test(s))
        throw new TypeError(message(path, "string<hostname>", value));
      return s;
    case "ipv4":
      if (!kIpv4Pattern.test(s))
        throw new TypeError(message(path, "string<ipv4>", value));
      return s;
    default:
      return s;
  }
}

// Type guard for string array
export function expectStringArray(value: unknown, path: string = ""): string[] {
  return expectArrayWith(value, "Array<string>", expectString, path);
}

// Convert string or number to number (for query params which may arrive as strings from HTTP or as numbers from JSON)
export function expectStringOrNumber(
  value: unknown,
  path: string = "",
): number {
  if (typeof value === "number" && !Number.isNaN(value)) return value;
  if (typeof value === "string") {
    const n = Number(value);
    if (!Number.isNaN(n)) return n;
  }
  throw new TypeError(message(path, "number or numeric string", value));
}

export function expectStringOrBoolean(
  value: unknown,
  path: string = "",
): boolean {
  if (typeof value === "boolean") return value;
  if (typeof value === "string") {
    return Boolean(value);
  }
  throw new TypeError(message(path, "boolean or boolean string", value));
}

export function castBranded<T extends string>(value: string): T {
  return value as T;
}

export function expectBranded<T extends string>(
  value: unknown,
  path: string = "",
): T {
  return castBranded<T>(expectString(value, path));
}

export function expectPatternString<T extends string>(
  value: unknown,
  name: string,
  pattern: RegExp,
  path: string = "",
): T {
  const strValue = expectString(value, path);
  if (!pattern.test(strValue)) {
    throw new TypeError(message(path, name, value));
  }
  return strValue as T;
}

export function expectSet<T extends string | number>(
  value: unknown,
  name: string,
  values: Set<T>,
  path: string = "",
): T {
  if (
    (typeof value === "string" || typeof value === "number") &&
    values.has(value as T)
  ) {
    return value as T;
  }
  throw new TypeError(message(path, name, value));
}

export function expectNotNull(value: unknown, path: string = ""): Json {
  if (value !== null && value !== undefined) return value as Json;
  throw new TypeError(message(path, "defined and not null", value));
}

export function expectBoolean(value: unknown, path: string = ""): boolean {
  if (typeof value === "boolean") return value;
  throw new TypeError(message(path, "boolean", value));
}

export function expectArrayWith<T>(
  value: unknown,
  name: string,
  checker: (v: unknown, path: string) => T,
  path: string = "",
): T[] {
  if (!Array.isArray(value)) throw new TypeError(message(path, name, value));
  else {
    const result: T[] = Array.of();
    let idx = 0;
    for (const v of value) {
      result.push(checker(v, `${path}[${idx++}]`));
    }
    return result;
  }
}

export function expectUndefinedOr<T>(
  value: unknown,
  checker: (v: unknown, path: string) => T,
  path: string = "",
): T | undefined {
  if (value === undefined) return undefined;
  return checker(value, path);
}

export function expectNullOr<T>(
  value: unknown,
  checker: (v: unknown, path: string) => T,
  path: string = "",
): T | null {
  if (value === null) return null;
  return checker(value, path);
}

export function expectOr<T>(
  value: unknown,
  name: string,
  checker1: (v: unknown, path: string) => T,
  checker2: (v: unknown, path: string) => T,
  path: string = "",
): T {
  try {
    return checker1(value, path);
  } catch {
    try {
      return checker2(value, path);
    } catch {
      throw new TypeError(message(path, name, value));
    }
  }
}

export function expectRecordWith<K extends string | number, V>(
  value: unknown,
  name: string,
  keyChecker: (v: unknown, path: string) => K,
  valueChecker: (v: unknown, path: string) => V,
  path: string = "",
): Record<K, V> {
  const msg = () => message(path, name, value);
  if (value !== null && typeof value === "object") {
    const v = value as Record<string, unknown>;
    const okeys = Object.keys(value);
    const obj: Record<K, V> = {} as Record<K, V>;
    for (const key of okeys) {
      obj[keyChecker(key, path)] = valueChecker(v[key], `${path}.${key}`);
    }
    return obj;
  }
  throw new TypeError(msg());
}

export function expectObject<T>(
  value: unknown,
  path: string = "",
): Record<string, T> {
  const msg = () => message(path, "", value);
  if (!value || typeof value !== "object") throw new TypeError(msg());
  return value as Record<string, T>;
}

export function expectEntryWith<K extends Json, V extends Json>(
  value: unknown,
  keyChecker: (v: unknown, path: string) => K,
  valueChecker: (v: unknown, path: string) => V,
  path: string = "",
): Entry<K, V> {
  if (!Array.isArray(value))
    throw new TypeError(message(path, "Entry<K,V>", value));
  if (value.length !== 2)
    throw new TypeError(message(path, "Entry<K,V>", `size ${value.length}`));
  const key = keyChecker(value[0], "[0]");
  const values = expectArrayWith(value[1], "Array<V>", valueChecker, "[1]");
  return [key, values];
}

export function expectEntriesWith<K extends Json, V extends Json>(
  value: unknown,
  keyChecker: (v: unknown, path: string) => K,
  valueChecker: (v: unknown, path: string) => V,
  path: string = "",
): Entry<K, V>[] {
  return expectArrayWith(
    value,
    "Array<Entry>",
    (v: unknown, path: string) => {
      return expectEntryWith(v, keyChecker, valueChecker, path);
    },
    path,
  );
}

export function message(
  path: string,
  expected: unknown,
  value: unknown,
): string {
  const exp =
    typeof expected === "string" ? expected : JSON.stringify(expected);
  const got = typeof value === "string" ? value : JSON.stringify(value);
  return `Invalid ${path} expect ${exp} got ${got}`;
}

// Auth validators that throw AuthenticationError instead of TypeError
export function expectAuthString(value: unknown, path: string = ""): string {
  if (typeof value === "string") return value;
  throw new AuthenticationError(`Missing or invalid authentication at ${path}`);
}

export function expectBearerToken(value: unknown, path: string = ""): string {
  if (typeof value !== "string") {
    throw new AuthenticationError(
      `Missing or invalid authentication at ${path}`,
    );
  }
  const prefix = "Bearer ";
  if (!value.startsWith(prefix)) {
    throw new AuthenticationError(`Invalid bearer token format at ${path}`);
  }
  return value.slice(prefix.length);
}
