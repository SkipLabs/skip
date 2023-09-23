import { Wrk } from "#std/sk_types";
import { PromiseWorker, Function, Caller } from "#std/sk_worker";
import { SKDB, ProtoResponseCreds, Params, RemoteSKDB, SkdbMechanism } from "#skdb/skdb_types";

export class WrappedRemote implements RemoteSKDB {
  private worker: PromiseWorker;
  private wrapped: number;

  constructor(worker: PromiseWorker, wrapped: number) {
    this.worker = worker;
    this.wrapped = wrapped;
  }

  createDatabase(dbName: string) {
    return this.worker.post(new Caller(this.wrapped, "createDatabase", [dbName]));
  }

  createUser() {
    return this.worker.post(new Caller(this.wrapped, "createUser", []));
  }

  schema() {
    return this.worker.post(new Caller(this.wrapped, "schema", []));
  }

  tableSchema(tableName: string) {
    return this.worker.post(new Caller(this.wrapped, "tableSchema", [tableName]));
  }

  viewSchema(viewName: string) {
    return this.worker.post(new Caller(this.wrapped, "viewSchema", [viewName]));
  }

  mirror(tableName: string, filterExpr?: string) {
    return this.worker.post(new Caller(this.wrapped, "mirror", [tableName, filterExpr]));
  }

  exec(query: string, params?: Params)  {
    return this.worker.post(new Caller(this.wrapped, "mirror", [query, params]));
  }
  
  isConnectionHealthy() {
    return this.worker.post(new Caller(this.wrapped, "isConnectionHealthy", []));
  }

  tablesAwaitingSync() {
    return this.worker.post(new Caller(this.wrapped, "tablesAwaitingSync", []));
  }

  close() {
    return this.worker.post(new Caller(this.wrapped, "close", [], true));
  }

  setOnReboot(onReboot: (server: RemoteSKDB, skdb: SkdbMechanism) => void): Promise<void> {
    throw new Error("On reboot cannot be defined in worker mode");
  };
}

export class SKDBWorker implements SKDB {
  private worker: PromiseWorker;

  constructor(worker: Wrk) {
    this.worker = new PromiseWorker(worker);
  }

  create = async (dbName?: string): Promise<void> => {
    return this.worker.post(new Function("create", [dbName]));
  }

  subscribe = async (viewName: string, f: (change: string) => void) => {
    return this.worker.subscribe(new Function("subscribe", [viewName]), f);
  }

  exec = async (query: string, params: Params = new Map(), server: boolean = false) => {
    return this.worker.post(new Function("exec", [query, params, server])) as Promise<Array<any>>;
  }

  watch = async (query: string, params: Params, onChange: (rows: Array<any>) => void) => {
    return this.worker.subscribe(new Function("watch", [query, params], {wrap: true, autoremove: true}), onChange).then(wrapped => {
      let close = () => this.worker.post(new Caller(wrapped.wrapped, "close", []));
      return { close: close };
    });
  }

  tableSchema = async (tableName: string, server: boolean = false) => {
    return this.worker.post(new Function("tableSchema", [tableName, server])) as Promise<string>;
  };

  viewSchema = async (viewName: string, server: boolean = false) => {
    return this.worker.post(new Function("viewSchema", [viewName, server])) as Promise<string>;
  };

  schema = async (server: boolean = false) => {
    return this.worker.post(new Function("schema", [server])) as Promise<string>;
  };

  insert = async (tableName: string, values: Array<any>) => {
    return this.worker.post(new Function("insert", [tableName, values])) as Promise<boolean>;
  };

  save = async () => {
    return this.worker.post(new Function("save", [])) as Promise<boolean>;
  }

  createServerDatabase = async (dbName: string) => {
    return this.worker.post(new Function("createServerDatabase", [dbName])) as Promise<ProtoResponseCreds>;
  }

  createServerUser = async () => {
    return this.worker.post(new Function("createServerUser", [])) as Promise<ProtoResponseCreds>;
  }

  mirror = async (tableName: string, filterExpr?: string) => {
    return this.worker.post(new Function("mirror", [tableName, filterExpr]));
  }

  closeConnection = async () => {
    return this.worker.post(new Function("serverClose", []));
  }

  connect = async (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => {
    return this.worker.post(new Function("connect", [db, accessKey, privateKey, endpoint]));
  }

  connectedRemote = async () => {
    return this.worker.post(new Function("connectedRemote", [], {wrap: true, autoremove: true})).then(wrapped => {
      return new WrappedRemote(this.worker, wrapped.wrapped) as any as RemoteSKDB;
    });
  }
}
