import { Wrk } from "#std/sk_types";
import { PromiseWorker, Function, Caller } from "#std/sk_worker";
import { SKDB, ProtoResponseCreds, Params, RemoteSKDB, SkdbMechanism, MirrorDefn } from "#skdb/skdb_types";

class WrappedRemote implements RemoteSKDB {
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

  mirror(...tables: MirrorDefn[]) {
    return this.worker.post(new Caller(this.wrapped, "mirror", tables));
  }

  exec(query: string, params?: Params) {
    return this.worker.post(new Caller(this.wrapped, "exec", [query, params]));
  }

  close() {
    return this.worker.post(new Caller(this.wrapped, "close", [], true));
  }

  isConnectionHealthy() {
    return this.worker.post(new Caller(this.wrapped, "isConnectionHealthy", []));
  }

  tablesAwaitingSync() {
    return this.worker.post(new Caller(this.wrapped, "tablesAwaitingSync", []));
  }

  onReboot(fn: () => void): Promise<void> {
    return this.worker.post(new Caller(this.wrapped, "onReboot", [fn]));
  }

  connectedAs(): Promise<string> {
    return this.worker.post(new Caller(this.wrapped, "connectedAs", []));
  }
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
    return this.worker.post(new Function("subscribe", [viewName, f]));
  }

  exec = async (query: string, params: Params = new Map()) => {
    return this.worker.post(new Function("exec", [query, params])) as Promise<Array<any>>;
  }

  watch = async (query: string, params: Params, onChange: (rows: Array<any>) => void) => {
    return this.worker.post(new Function("watch", [query, params, onChange], { wrap: true, autoremove: true })).then(wrapped => {
      let close = () => this.worker.post(new Caller(wrapped.wrapped, "close", []));
      return { close: close };
    });
  }

  watchChanges = async (query: string, params: Params, init: (rows: Array<any>) => void, update: (added: Array<any>, removed: Array<any>) => void) => {
    return this.worker.post(new Function("watchChanges", [query, params, init, update], { wrap: true, autoremove: true })).then(wrapped => {
      let close = () => this.worker.post(new Caller(wrapped.wrapped, "close", []));
      return { close: close };
    });
  }

  tableSchema = async (tableName: string) => {
    return this.worker.post(new Function("tableSchema", [tableName])) as Promise<string>;
  };

  viewSchema = async (viewName: string) => {
    return this.worker.post(new Function("viewSchema", [viewName])) as Promise<string>;
  };

  schema = async (tableName?: string) => {
    return this.worker.post(new Function("schema", [tableName])) as Promise<string>;
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

  mirror = async (...tables: MirrorDefn[]) => {
    return this.worker.post(new Function("mirror", tables));
  }

  closeConnection = async () => {
    return this.worker.post(new Function("closeConnection", []));
  }

  currentUser?: string;

  connect = async (db: string, accessKey: string, privateKey: CryptoKey, endpoint?: string) => {
    this.currentUser = accessKey;
    return this.worker.post(new Function("connect", [db, accessKey, privateKey, endpoint]));
  }

  connectedRemote = async () => {
    return this.worker.post(new Function("connectedRemote", [], { wrap: true, autoremove: false }))
      .then(wrapped => new WrappedRemote(this.worker, wrapped.wrapped));
  }
}
