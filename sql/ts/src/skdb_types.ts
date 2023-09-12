import { Shared } from "#std/sk_types";



export interface SkdbHandle {
  runner: (fn: () => string) => Promise<Array<any>>;
  main: (new_args: Array<string>, new_stdin: string) => string;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }
}

export interface SKDB {
  subscribe: (viewName: string, f: (change: string) => void) => Promise<void>;

  exec: (query: string, params: Params, server?: boolean) => Promise<Array<any>>;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => Promise<{ close: () => void }>
  
  tableSchema: (tableName: string, server?: boolean) => Promise<string>;
  viewSchema: (viewName: string, server?: boolean) => Promise<string>;
  schema: (server?: boolean) => Promise<string>;
  insert: (tableName: string, values: Array<any>) => Promise<boolean>;
  save: () => Promise<boolean>;
  connect: (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => Promise<void>;

  createServerDatabase: (dbName: string) => Promise<ProtoResponseCreds>;
  createServerUser: () => Promise<ProtoResponseCreds>;
  mirror: (tableName: string, filterExpr?: string) => Promise<void>;
  serverClose: () => Promise<void>;
}

export interface SkdbMechanism {
  writeCsv: (table: string, payload: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (replicationUid: string, table: string, updateFile: string) => string;
  diff: (watermark: bigint, session: string) => ArrayBuffer | null;
  tableExists: (tableName: string) => Promise<boolean>;
  sql: (query: string) => Promise<Array<any>>;
  assertCanBeMirrored: (tableName: string) => void;
  toggleView: (tableName: string) => void;
}

export var metadataTable = (tableName: string) => {
  return `skdb__${tableName}_sync_metadata`;
}

export interface Storage {
  save(): Promise<boolean>;
}

export type ProtoResponseCreds = {
  type: "credentials";
  accessKey: string;
  privateKey: Uint8Array;
}

export type Params = Map<string, string|number> | Object;

export interface Server {
  createDatabase: (dbName: string) => Promise<ProtoResponseCreds>;
  createUser(): Promise<ProtoResponseCreds>;
  schema: () => Promise<string>;
  tableSchema: (tableName: string) => Promise<string>;
  viewSchema: (viewName: string) => Promise<string>;
  mirror: (tableName: string, filterExpr?: string) => Promise<void>;
  sqlRaw: (query: string, params: Params) => Promise<string>;
  sql: (query: string, params: Params) => Promise<Array<any>>;
  close(): void;
}

export type Page = { pageid: number, content: any };


export interface PagedMemory {
  init(fn: (page: Page) => void): void;
  restore(pages: Array<Page>): void;
  clear() : void;
  update() : void;
  getPages(): Promise<Array<Page>>;
}

export interface SKDBShared extends Shared {
  create: (dbName ?: string, asWorker ?: boolean) => Promise<SKDB>;
}

/* ***************************************************************************/
/* The type used to represent callables. */
/* ***************************************************************************/

export class SKDBCallable<T1, T2> {
  private id: number;

  constructor(id: number) {
    this.id = id;
  }

  getId(): number {
    return this.id;
  }
}

export class ExternalFuns {
  private externalFuns: Array<(any) => any>;

  constructor() {
    this.externalFuns = [];
  }

  register<T1, T2>(f: (obj: T1) => T2): SKDBCallable<T1, T2> {
    if (typeof f != "function") {
      throw new Error("Only function can be registered");
    }
    let funId = this.externalFuns.length;
    this.externalFuns.push(f);
    return new SKDBCallable(funId);
  }

  call(funId: number, jso: object) {
    return this.externalFuns[funId]!(jso);
  }
}

