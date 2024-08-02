// prettier-ignore
import { runUrl, type ModuleInit } from "#std/sk_types.js";
import { check } from "./prv/skstore_impl.js";
import type {
  SKStore,
  SKStoreFactory,
  ColumnSchema,
  MirrorSchema,
  TableHandle,
  Table,
  TTableHandle,
  TTable,
  TJSON,
  JSONObject,
  Accumulator,
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
  ColumnSchema,
  Accumulator,
};

export type {
  Mapper,
  EntryMapper as TableMapper,
  OutputMapper,
  EHandle,
  NonEmptyIterator,
  LHandle,
  LazyCompute,
  AsyncLazyCompute,
  Loadable,
  ALHandle,
} from "./skstore_api.js";

export {
  Sum,
  Min,
  Max,
  schema,
  ctext,
  cinteger,
  cfloat,
  cjson,
} from "./skstore_utils.js";

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

export function freeze<T extends TJSON | null>(value: T): T {
  if (value == null) return value;
  const type = typeof value;
  if (type == "string" || type == "number" || type == "boolean") {
    return value;
  } else if (type == "object") {
    if ((value as any).__sk_frozen) {
      return value;
    } else if (Object.isFrozen(value)) {
      check(value);
      return value;
    } else if (Array.isArray(value)) {
      Object.defineProperty(value, "__sk_frozen", {
        enumerable: false,
        writable: false,
        value: true,
      });
      const length: number = value.length;
      for (let i = 0; i < length; i++) {
        value[i] = freeze(value[i]);
      }
      return Object.freeze(value) as T;
    } else {
      const jso = value as any;
      Object.defineProperty(value, "__sk_frozen", {
        enumerable: false,
        writable: false,
        value: true,
      });
      for (const key of Object.keys(jso)) {
        jso[key] = freeze(jso[key]);
      }
      return Object.freeze(jso) as T;
    }
  } else {
    throw new Error("'" + type + "' cannot be frozen.");
  }
}
