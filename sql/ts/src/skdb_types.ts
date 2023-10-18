import { Shared } from "#std/sk_types";

export interface SkdbHandle {
  runner: (fn: () => string) => Array<any>;
  main: (new_args: Array<string>, new_stdin: string) => string;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }
}

export type MirrorDefn = {
  table: string,
  filterExpr?: string,
} | string;

export interface SKDBSync {
  // CLIENT
  exec: (query: string, params?: Params) => Array<any>;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }
  insert: (tableName: string, values: Array<any>) => boolean;

  tableSchema: (tableName: string) => string;
  viewSchema: (viewName: string) => string;
  schema: (tableName?: string) => string;
  subscribe: (viewName: string, f: (change: string) => void) => void;
  save: () => Promise<boolean>;

  // SERVER
  connect: (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => Promise<void>;
  mirror: (...tables: MirrorDefn[]) => Promise<void>;

  connectedRemote?: RemoteSKDB;
  createServerDatabase: (dbName: string) => Promise<ProtoResponseCreds>;
  createServerUser: () => Promise<ProtoResponseCreds>;
  serverExec: (query: string, params?: Params) => Promise<Array<any>>;
  serverTableSchema: (tableName: string) => Promise<string>;
  serverViewSchema: (tableName: string) => Promise<string>;
  serverSchema: () => Promise<string>;
  serverClose: () => void;
}

export interface SKDB {
  exec: (query: string, params?: Params) => Promise<Array<any>>;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => Promise<{ close: () => Promise<void> }>

  connect: (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => Promise<void>;
  connectedRemote: () => Promise<RemoteSKDB|undefined>;
  closeConnection: () => Promise<void>;
  currentUser?: string;

  mirror: (...tables: MirrorDefn[]) => Promise<void>;

  schema: (tableName?: string) => Promise<string>;
  save: () => Promise<boolean>;
}

export interface SkdbMechanism {
  writeCsv: (payload: string, source: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (replicationUid: string, tables: string[], updateFile: string) => string;
  unsubscribe: (session: string) => void;
  diff: (watermark: bigint, session: string) => ArrayBuffer | null;
  tableExists: (tableName: string) => boolean;
  exec: (query: string) => Array<any>;
  assertCanBeMirrored: (tableName: string) => void;
  toggleView: (tableName: string) => void;
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

export interface RemoteSKDB {
  connectedAs(): Promise<string>;

  createUser(): Promise<ProtoResponseCreds>;
  schema: () => Promise<string>;
  tableSchema: (tableName: string) => Promise<string>;
  viewSchema: (viewName: string) => Promise<string>;

  createDatabase: (dbName: string) => Promise<ProtoResponseCreds>;

  mirror: (...tables: MirrorDefn[]) => Promise<void>;
  exec: (query: string, params?: Params) => Promise<Array<any>>;

  isConnectionHealthy: () => Promise<boolean>;
  tablesAwaitingSync: () => Promise<Set<string>>;

  onReboot: (fn: () => void) => Promise<void>;

  close(): Promise<void>;
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
  createSync: (dbName ?: string, asWorker ?: boolean) => Promise<SKDBSync>;
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
