// prettier-ignore
import { runUrl, type ModuleInit, type Opt } from "#std/sk_types.js";
import type {
  SimpleRemoteInputs,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
} from "./skipruntime_service.js";
export { freeze } from "./internals/skipruntime_impl.js";
import type {
  DBFilter,
  DBType,
  Index,
  SKStore,
  SKStoreFactory,
  ColumnSchema,
  Schema,
  TableCollection,
  Table,
  TJSON,
  JSONObject,
  Accumulator,
  Local,
  Remote,
  Database,
} from "./skipruntime_api.js";
import { runWithServer_ } from "./internals/skipruntime_process.js";
export type { Opaque } from "./internals/skipruntime_module.js";
export { TimedQueue } from "./internals/skipruntime_module.js";
export type {
  DBFilter,
  DBType,
  Index,
  SKStore,
  TJSON,
  TableCollection,
  Table,
  Schema,
  JSONObject,
  ColumnSchema,
  Accumulator,
  SimpleRemoteInputs,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
  Opt,
};

export type {
  AValue,
  Database,
  Mapper,
  Param,
  RefreshToken,
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
  init: (
    skstore: SKStore,
    tables: Record<string, TableCollection<TJSON[]>>,
  ) => void,
  local: Local,
  remotes: Record<string, Remote> = {},
  tokens: Record<string, number> = {},
  initLocals?: (tables: Record<string, Table<TJSON[]>>) => Promise<void>,
): Promise<Record<string, Table<TJSON[]>>> {
  const data = await runUrl(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, local, remotes, tokens, initLocals);
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
      for (const schema of local.inputs) {
        const name = schema.alias ? schema.alias : schema.name;
        handles.push(tables[name]);
      }
      for (const remote of Object.values(remotes)) {
        for (const schema of remote.tables) {
          const name = schema.alias ? schema.alias : schema.name;
          handles.push(tables[name]);
        }
      }
      for (const schema of local.outputs) {
        const name = schema.alias ? schema.alias : schema.name;
        handles.push(tables[name]);
      }
      init(skstore, ...handles);
    },
    local,
    remotes,
    tokens,
  );
  for (const schema of local.inputs) {
    const name = schema.alias ? schema.alias : schema.name;
    tables.push(result[name]);
  }
  for (const remote of Object.values(remotes)) {
    for (const schema of remote.tables) {
      const name = schema.alias ? schema.alias : schema.name;
      tables.push(result[name]);
    }
  }
  for (const schema of local.outputs) {
    const name = schema.alias ? schema.alias : schema.name;
    tables.push(result[name]);
  }
  return tables;
}

export async function createLocalSKStore(
  init: (skstore: SKStore, ...tables: TableCollection<TJSON[]>[]) => void,
  inputs: Schema[],
  outputs: Schema[],
  tokens: Record<string, number> = {},
  database?: Database,
): Promise<Table<TJSON[]>[]> {
  return createInlineSKStore(
    init,
    database ? { inputs, outputs, database } : { inputs, outputs },
    {},
    tokens,
  );
}

export async function runWithServer(
  service: SimpleSkipService,
  options: Record<string, any>,
  database?: Database,
) {
  await runWithServer_(service, createSKStore, options, database);
}
