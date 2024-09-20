import type {
  Database,
  EagerCollection,
  NonEmptyIterator,
  OutputMapper,
  Remote,
  Schema,
  SKStore,
  Table,
  TableCollection,
  TJSON,
} from "./skipruntime_api.js";

import type {
  GenericSkipService,
  InputDefinition,
  RemoteInputs,
  SimpleSkipService,
  Writer,
} from "./skipruntime_service.js";

import { ctext as text, cjson as json } from "./skipruntime_utils.js";

import {
  type createSKStore as CreateSKStore,
  type InputMapper,
} from "./skip-runtime.js";
import type { TableCollectionImpl } from "./internals/skipruntime_impl.js";

class FromInput implements InputMapper<TJSON[], TJSON, TJSON> {
  mapElement(entry: TJSON[], _occ: number): Iterable<[TJSON, TJSON]> {
    return Array([entry[0], entry[1]]);
  }
}

class ToOutput implements OutputMapper<TJSON[], TJSON, TJSON> {
  mapElement(key: TJSON, it: NonEmptyIterator<TJSON>) {
    const v = it.first();
    return Array([key, JSON.stringify(v), "", "read-write"]);
  }
}

const requestSchema = {
  name: "__sk_requests",
  columns: [
    text("id", false, true),
    json("request"),
    text("skdb_author"),
    text("skdb_access"),
  ],
};

function inputSchema(name: string) {
  return {
    name,
    columns: [
      text("key", false, true),
      json("value"),
      text("skdb_author"),
      text("skdb_access"),
    ],
  };
}

const responseSchema = {
  name: "__sk_responses",
  columns: [
    text("id", false, true),
    json("response"),
    text("skdb_author"),
    text("skdb_access"),
  ],
};

class WriterImpl<V extends TJSON> implements Writer<V> {
  constructor(private table: Table<TJSON[]>) {}

  set(key: string, value: V): void {
    this.table.insert([[key, JSON.stringify(value), "", "read-write"]], true);
  }

  delete(keys: string[]): void {
    this.table.deleteWhere({ key: keys });
  }
}

function toWriters(
  tables: Record<string, Table<TJSON[]>>,
): Record<string, Writer<TJSON>> {
  const writers: Record<string, Writer<TJSON>> = {};
  for (const key of Object.keys(tables)) {
    writers[key] = new WriterImpl(tables[key]);
  }
  return writers;
}

class SimpleToGenericSkipService implements GenericSkipService {
  refreshTokens?: Record<string, number>;

  init?: (tables: Record<string, Table<TJSON[]>>) => Promise<void>;

  constructor(private simple: SimpleSkipService) {
    if (simple.refreshTokens) this.refreshTokens = simple.refreshTokens;
    const sInit = simple.init;
    if (sInit) {
      this.init = async (tables: Record<string, Table<TJSON[]>>) => {
        const writers: Record<string, Writer<TJSON>> = {};
        for (const key of Object.keys(tables)) {
          if (key == "__sk_requests") continue;
          writers[key] = new WriterImpl(tables[key]);
        }
        return sInit(writers);
      };
    }
  }

  localInputs() {
    const inputs: Record<string, InputDefinition> = {};
    if (this.simple.inputTables) {
      this.simple.inputTables.map((table) => {
        inputs[table] = {
          schema: inputSchema(table),
          fromTableRow: FromInput,
          params: [],
        };
      });
    }
    return {
      __sk_requests: {
        schema: requestSchema,
        fromTableRow: FromInput,
        params: [],
      },
      ...inputs,
    };
  }

  remoteInputs(): Record<string, RemoteInputs> {
    const inputs: Record<string, RemoteInputs> = {};
    if (this.simple.remoteTables) {
      for (const [key, sri] of Object.entries(this.simple.remoteTables)) {
        const rInputs: Record<string, InputDefinition> = {};
        sri.tables.map((table) => {
          rInputs[table] = {
            schema: inputSchema(table),
            fromTableRow: FromInput,
            params: [],
          };
        });
        inputs[key] = {
          database: sri.database,
          inputs: rInputs,
        };
      }
    }
    return inputs;
  }

  outputs() {
    return {
      __sk_responses: {
        schema: responseSchema,
        toTableRow: ToOutput,
        params: [],
      },
    };
  }

  reactiveCompute(
    store: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) {
    const requests = inputs["__sk_requests"];
    delete inputs["__sk_requests"];
    const result = this.simple.reactiveCompute(store, requests, inputs);
    return {
      outputs: { __sk_responses: result.output },
      update: (
        event: TJSON,
        tables: Record<string, Table<TJSON[]>>,
        remoteWriters: Record<string, (event: TJSON) => Promise<void>>,
      ) => result.update(event, toWriters(tables), remoteWriters),
    };
  }
}

function isGenericSkipService(service: GenericSkipService | SimpleSkipService) {
  if (!("localInputs" in service)) return false;
  if (!("remoteInputs" in service)) return false;
  if (!("outputs" in service)) return false;
  if (typeof service.localInputs != "function") return false;
  if (typeof service.remoteInputs != "function") return false;
  if (typeof service.outputs != "function") return false;
  return true;
}

export async function runService(
  service: GenericSkipService | SimpleSkipService,
  createSKStore: typeof CreateSKStore,
  database?: Database,
): Promise<
  [
    (
      event: TJSON,
      remote: Record<string, (event: TJSON) => Promise<void>>,
    ) => void | Promise<void>,
    Record<string, Table<TJSON[]>>,
    Record<string, Table<TJSON[]>>,
  ]
> {
  const gService: GenericSkipService = isGenericSkipService(service)
    ? (service as GenericSkipService)
    : new SimpleToGenericSkipService(service as SimpleSkipService);
  const localInputs = gService.localInputs();
  const remoteInputs = gService.remoteInputs();
  const outputs = gService.outputs();
  const inputSchemas: Schema[] = [];
  const outputSchemas: Schema[] = [];
  for (const [key, value] of Object.entries(localInputs)) {
    const schema = value.schema;
    if (schema.name != key) {
      schema.alias = key;
    }
    inputSchemas.push(schema);
  }
  for (const [key, value] of Object.entries(outputs)) {
    const schema = value.schema;
    if (schema.name != key) {
      schema.alias = key;
    }
    outputSchemas.push(schema);
  }
  const remotes: Record<string, Remote> = {};
  for (const [key, ri] of Object.entries(remoteInputs)) {
    const schemas: Schema[] = [];
    for (const [key, value] of Object.entries(ri.inputs)) {
      const schema = value.schema;
      if (schema.name != key) {
        schema.alias = key;
      }
      schemas.push(schema);
    }
    remotes[key] = { database: ri.database, tables: schemas };
  }
  let update:
    | ((
        event: TJSON,
        remote: Record<string, (event: TJSON) => Promise<void>>,
      ) => void | Promise<void>)
    | null = null;
  const iTables: Record<string, Table<TJSON[]>> = {};
  const oTables: Record<string, Table<TJSON[]>> = {};
  const initSKStore = (
    store: SKStore,
    tables: Record<string, TableCollection<TJSON[]>>,
  ) => {
    const iHandles: Record<string, EagerCollection<TJSON, TJSON>> = {};
    for (const [key, value] of Object.entries(localInputs)) {
      const table = tables[key];
      iHandles[key] = table.map(value.fromTableRow, ...value.params);
      iTables[key] = (table as TableCollectionImpl<TJSON[]>).toTable();
    }
    for (const remove of Object.values(remoteInputs)) {
      for (const [key, value] of Object.entries(remove.inputs)) {
        const table = tables[key];
        iHandles[key] = table.map(value.fromTableRow, ...value.params);
      }
    }
    const result = gService.reactiveCompute(store, iHandles);
    const rkeys = Object.keys(result.outputs);
    const okeys = Object.keys(outputs);
    if (rkeys.length != okeys.length) {
      throw new Error(
        `The number of output collections (${rkeys.length})` +
          ` must correspond to number of output tables (${okeys.length}).`,
      );
    }
    for (const [key, output] of Object.entries(outputs)) {
      const ehandle = result.outputs[key];
      // eslint-disable-next-line  @typescript-eslint/no-unnecessary-condition
      if (!ehandle) {
        throw new Error(`The ${key} must be return by reactiveCompute.`);
      }
      const table = tables[key];
      // eslint-disable-next-line  @typescript-eslint/no-unnecessary-condition
      if (!table) {
        throw new Error(`Unable to retrieve ${key} table.`);
      }
      oTables[key] = (table as TableCollectionImpl<TJSON[]>).toTable();
      ehandle.mapTo(tables[key], output.toTableRow, ...output.params);
    }
    update = (event, remotes) => result.update(event, iTables, remotes);
  };
  await createSKStore(
    initSKStore,
    database
      ? {
          inputs: inputSchemas,
          outputs: outputSchemas,
          database,
        }
      : {
          inputs: inputSchemas,
          outputs: outputSchemas,
        },
    remotes,
    gService.refreshTokens,
    gService.init,
  );
  return [update!, iTables, oTables];
}
