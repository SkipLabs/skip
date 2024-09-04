// prettier-ignore
import { runUrl, type ModuleInit } from "#std/sk_types.js";
import { check } from "./internals/skipruntime_impl.js";
import type {
  SKStore,
  SKStoreFactory,
  ColumnSchema,
  MirrorSchema,
  TableCollection,
  Table,
  TTableCollection,
  TTable,
  TJSON,
  JSONObject,
  Accumulator,
} from "./skipruntime_api.js";

export type {
  SKStore,
  TJSON,
  TableCollection,
  Table,
  MirrorSchema,
  JSONObject,
  TTableCollection,
  TTable,
  ColumnSchema,
  Accumulator,
};

export type {
  Mapper,
  InputMapper,
  OutputMapper,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  AsyncLazyCompute,
  Loadable,
  AsyncLazyCollection,
} from "./skipruntime_api.js";

export { ValueMapper } from "./skipruntime_api.js";
export {
  Sum,
  Min,
  Max,
  schema,
  ctext,
  cinteger,
  cfloat,
  cjson,
} from "./skipruntime_utils.js";

const modules: ModuleInit[] = [];
/*--MODULES--*/

async function wasmUrl(): Promise<URL> {
  //@ts-expect-error  ImportMeta is incomplete
  if (import.meta.env || import.meta.webpack) {
    /* eslint-disable @typescript-eslint/no-unsafe-return */
    //@ts-expect-error  Cannot find module './skstore.wasm?url' or its corresponding type declarations.
    return await import("./skip-runtime.wasm?url");
    /* eslint-enable @typescript-eslint/no-unsafe-return */
  }

  return new URL("./skip-runtime.wasm", import.meta.url);
}

export async function createSKStore(
  init: (skstore: SKStore, ...tables: TableCollection<TJSON[]>[]) => void,
  tables: MirrorSchema[],
  connect: boolean = true,
): Promise<Table<TJSON[]>[]> {
  const data = await runUrl(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, tables, connect);
}

export function freeze<T extends TJSON>(value: T): T {
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
      const jso = value as Record<string, any>;
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
