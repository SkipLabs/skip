// prettier-ignore
import { runUrl, type ModuleInit } from "#std/sk_types.js";
import type {
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
} from "./skipruntime_service.js";
import { check } from "./internals/skipruntime_impl.js";
import type {
  SKStore,
  SKStoreFactory,
  ColumnSchema,
  Schema,
  TableCollection,
  Table,
  TTableCollection,
  TTable,
  TJSON,
  JSONObject,
  Accumulator,
  Local,
  Remote,
  Database,
} from "./skipruntime_api.js";
import { runWithServer_ } from "./internals/skipruntime_process.js";
export { TimedQueue } from "./internals/skipruntime_module.js";
export type {
  SKStore,
  TJSON,
  TableCollection,
  Table,
  Schema,
  JSONObject,
  TTableCollection,
  TTable,
  ColumnSchema,
  Accumulator,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
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
  EntryPoint,
} from "./skipruntime_api.js";

export { ValueMapper, MapOptions } from "./skipruntime_api.js";
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
  init: (
    skstore: SKStore,
    tables: Record<string, TableCollection<TJSON[]>>,
  ) => void,
  local: Local,
  remotes: Record<string, Remote> = {},
  tokens: Record<string, number> = {},
): Promise<Record<string, Table<TJSON[]>>> {
  const data = await runUrl(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, local, remotes, tokens);
}

export async function createInlineSKStore(
  init: (skstore: SKStore, ...tables: TableCollection<TJSON[]>[]) => void,
  local: Local,
  remotes: Record<string, Remote> = {},
  tokens: Record<string, number> = {},
): Promise<Table<TJSON[]>[]> {
  const tables: Table<TJSON[]>[] = [];
  const result = await createSKStore(
    (skstore: SKStore, tables: Record<string, TableCollection<TJSON[]>>) => {
      const handles: TableCollection<TJSON[]>[] = [];
      for (const schema of local.tables) {
        const name = schema.alias ? schema.alias : schema.name;
        handles.push(tables[name]);
      }
      for (const remote of Object.values(remotes)) {
        for (const schema of remote.tables) {
          const name = schema.alias ? schema.alias : schema.name;
          handles.push(tables[name]);
        }
      }
      init(skstore, ...handles);
    },
    local,
    remotes,
    tokens,
  );
  for (const schema of local.tables) {
    const name = schema.alias ? schema.alias : schema.name;
    tables.push(result[name]);
  }
  for (const remote of Object.values(remotes)) {
    for (const schema of remote.tables) {
      const name = schema.alias ? schema.alias : schema.name;
      tables.push(result[name]);
    }
  }
  return tables;
}

export async function createLocalSKStore(
  init: (skstore: SKStore, ...tables: TableCollection<TJSON[]>[]) => void,
  schemas: Schema[],
  tokens: Record<string, number> = {},
  database?: Database,
): Promise<Table<TJSON[]>[]> {
  return createInlineSKStore(
    init,
    database ? { tables: schemas, database } : { tables: schemas },
    {},
    tokens,
  );
}

export function freeze<T>(value: T): T {
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

export async function runWithServer(
  service: SimpleSkipService,
  options: Record<string, any>,
  database?: Database,
) {
  await runWithServer_(service, createSKStore, options, database);
}
