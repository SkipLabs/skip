import type {
  EagerCollection,
  InputMapper,
  Schema,
  OutputMapper,
  Param,
  SKStore,
  Table,
  TJSON,
  Database,
} from "./skipruntime_api.js";

export interface Writer<V extends TJSON> {
  set(key: string, value: V): void;
  delete(keys: string[]): void;
}

export type ServiceOutput = {
  outputs: Record<string, EagerCollection<TJSON, TJSON>>;
  update: (
    event: TJSON,
    table: Record<string, Table<TJSON[]>>,
    remote: Record<string, (event: TJSON) => Promise<void>>,
  ) => Promise<void>;
};

export type SimpleServiceOutput = {
  output: EagerCollection<string, TJSON>;
  update: (
    event: TJSON,
    writers: Record<string, Writer<TJSON>>,
    remote: Record<string, (event: TJSON) => Promise<void>>,
  ) => Promise<void>;
};

export type InputDefinition = {
  schema: Schema;
  fromTableRow: new (...params: Param[]) => InputMapper<TJSON[], TJSON, TJSON>;
  params: Param[];
};

export type RemoteInputs = {
  database: Database;
  inputs: Record<string, InputDefinition>;
};

export type OutputDefinition = {
  schema: Schema;
  toTableRow: new (...params: Param[]) => OutputMapper<TJSON[], TJSON, TJSON>;
  params: Param[];
};

export interface GenericSkipService {
  localInputs(): Record<string, InputDefinition>;
  remoteInputs(): Record<string, RemoteInputs>;

  outputs(): Record<string, OutputDefinition>;

  // Each token associates a string identifier with a refresh frequency (in milliseconds)
  refreshTokens?: Record<string, number>;

  init?: (tables: Record<string, Table<TJSON[]>>) => Promise<void>;

  reactiveCompute(
    store: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ): ServiceOutput;
}

export type SimpleRemoteInputs = {
  database: Database;
  tables: string[];
};

export interface SimpleSkipService {
  inputTables?: string[];
  remoteTables?: Record<string, SimpleRemoteInputs>;

  // Each token associates a string identifier with a refresh frequency (in milliseconds)
  refreshTokens?: Record<string, number>;

  init?: (table: Record<string, Writer<TJSON[]>>) => Promise<void>;

  reactiveCompute(
    store: SKStore,
    requests: EagerCollection<string, TJSON>,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): SimpleServiceOutput;
}
