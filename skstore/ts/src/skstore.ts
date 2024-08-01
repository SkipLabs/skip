// prettier-ignore
import { runUrl, type ModuleInit } from "#std/sk_types.js";
import type {
  SKStore,
  Accumulator,
  Opt,
  SKStoreFactory,
  ColumnSchema,
  MirrorSchema,
  TableHandle,
  Table,
  TTableHandle,
  TTable,
  TJSON,
  JSONObject,
} from "./skstore_api.js";

export type {
  SKStore,
  TJSON,
  TableHandle,
  Table,
  MirrorSchema,
  JSONObject,
  TTableHandle,
  TTable,
};

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

var modules: ModuleInit[];
/*--MODULES--*/

async function wasmUrl(): Promise<URL> {
  //@ts-ignore
  if (import.meta.env || import.meta.webpack) {
    //@ts-ignore
    return await import("./skstore.wasm?url");
  }

  return new URL("./skstore.wasm", import.meta.url);
}

export async function createSKStore(
  init: (skstore: SKStore, ...tables: TableHandle<TJSON[]>[]) => void,
  tables: MirrorSchema[],
  connect: boolean = true,
): Promise<Table<TJSON[]>[]> {
  let data = await runUrl(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, tables, connect);
}

export function integer(
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

export function schema(name: string, expected: ColumnSchema[]): MirrorSchema {
  return {
    name,
    expected,
  };
}

export function text(
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

export function json(
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
