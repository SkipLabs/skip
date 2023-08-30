import { Shared } from "#std/sk_types";

export interface Utility {
  addRoot: <T1, T2>(rootName: string, callable: (obj: T1) => T2 | SKDBCallable<T1, T2>, arg: T1) => void;
  removeRoot: (rootName: string) => void;
  getRoot: (rootName: string) => any;
  trackedCall: <T1, T2>(callable: SKDBCallable<T1, T2>, arg: T1) => T2;
  trackedQuery: (request: string, start?: number, end?: number) => any;
  trackAndRegister: <T1, T2>(callable: SKDBCallable<T1, T2>, arg: T1, start?: number, end?: number) => SKDBCallable<T1, T2>;
  runner: (fn: () => string) => Promise<Array<any>>;
  registerFun: <T1, T2>(f: (obj: T1) => T2) => SKDBCallable<T1, T2>;
  addSubscribedRoot: (name: string, value: any) => void;
  removeSubscribedRoot: (name: string) => void;
  getRootChangeListeners: () => Array<(rootName: string) => void>;
  addRootChangeListener: (f: (rootName: string) => void) => void;
  main: (new_args: Array<string>, new_stdin: string) => string;
}

export interface SKDB {
  subscribe: (viewName: string, f: (change: string) => void) => Promise<void>;

  sqlRaw: (query: string, params: Map<string, string|number>, server?: boolean) => Promise<string>;
  sql: (query: string, params: Map<string, string|number>, server?: boolean) => Promise<Array<any>>;
  cmd: (new_args: Array<string>, new_stdin: string) => Promise<string>;
  tableExists: (tableName: string) => Promise<boolean>;
  tableSchema: (tableName: string, server?: boolean) => Promise<string>;
  viewExists: (viewName: string) => Promise<boolean>;
  viewSchema: (viewName: string, server?: boolean) => Promise<string>;
  schema: (server?: boolean) => Promise<string>;
  insert: (tableName: string, values: Array<any>) => Promise<boolean>;
  save: () => Promise<boolean>;
  connect: (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => Promise<void>;

  createServerDatabase: (dbName: string) => Promise<ProtoResponseCreds>;
  createServerUser: () => Promise<ProtoResponseCreds>;
  mirrorServerTable: (tableName: string, filterExpr?: string) => Promise<void>;
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

export interface Server {
  createDatabase: (dbName: string) => Promise<ProtoResponseCreds>;
  createUser(): Promise<ProtoResponseCreds>;
  schema: () => Promise<string>;
  tableSchema: (tableName: string) => Promise<string>;
  viewSchema: (viewName: string) => Promise<string>;
  mirrorTable: (tableName: string, filterExpr?: string) => Promise<void>;
  sqlRaw: (query: string, params: Map<string, string|number>) => Promise<string>;
  sql: (query: string, params: Map<string, string|number>) => Promise<Array<any>>;
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

