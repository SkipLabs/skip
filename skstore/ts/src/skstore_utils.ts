import type {
  Accumulator,
  ColumnSchema,
  MirrorSchema,
  Opt,
} from "./skstore_api.js";

export class Sum implements Accumulator<number, number> {
  default = 0;
  accumulate(acc: number, value: number): number {
    return acc + value;
  }
  dismiss(acc: number, value: number): Opt<number> {
    return acc - value;
  }
}

export class Min implements Accumulator<number, number> {
  default = null;
  accumulate(acc: Opt<number>, value: number): number {
    return acc === null ? value : Math.min(acc, value);
  }
  dismiss(acc: number, value: number): Opt<number> {
    return value > acc ? acc : null;
  }
}

export class Max implements Accumulator<number, number> {
  default = null;
  accumulate(acc: Opt<number>, value: number): number {
    return acc === null ? value : Math.max(acc, value);
  }
  dismiss(acc: number, value: number): Opt<number> {
    return value < acc ? acc : null;
  }
}

export function schema(name: string, expected: ColumnSchema[]): MirrorSchema {
  return {
    name,
    expected,
  };
}

export function cinteger(
  name: string,
  primary?: boolean,
  notnull?: boolean,
): ColumnSchema {
  return {
    name,
    type: "INTEGER",
    primary,
    notnull,
  };
}

export function ctext(
  name: string,
  primary?: boolean,
  notnull?: boolean,
): ColumnSchema {
  return {
    name,
    type: "TEXT",
    primary,
    notnull,
  };
}

export function cjson(
  name: string,
  primary?: boolean,
  notnull?: boolean,
): ColumnSchema {
  return {
    name,
    type: "JSON",
    primary,
    notnull,
  };
}

export function cfloat(
  name: string,
  primary?: boolean,
  notnull?: boolean,
): ColumnSchema {
  return {
    name,
    type: "JSON",
    primary,
    notnull,
  };
}
