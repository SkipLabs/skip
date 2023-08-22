import {Wrk} from "#std/sk_types";
import {PromiseWorker, Function} from "#std/sk_worker";
import {SKDB, ProtoResponseCreds} from "#skdb/skdb_types";

export class SKDBWorker implements SKDB {
  private worker: PromiseWorker;
  
  constructor(worker: Wrk) {
    this.worker = new PromiseWorker(worker);
  }

  create = async (dbName ?: string): Promise<void> => {
    await this.worker.post(new Function("create", [dbName]));
  }

  onRootChange = async (f: (rootName: string) => void) => {
    await this.worker.subscribe(new Function("onRootChange", []), f);
  };
  
  subscribe = async (viewName: string, f: (change: string) => void) => {
    await this.worker.subscribe(new Function("subscribe", [viewName]), f);
  };

  sqlRaw = async (query: string, server: boolean = false) => {
    return await this.worker.post(new Function("sqlRaw", [query, server])) as string;
  };

  sql = async (query: string, server: boolean = false) => {
    return await this.worker.post(new Function("sql", [query, server])) as Array<any>;
  }

  cmd = async (new_args: Array<string>, new_stdin: string) => {
    return await this.worker.post(new Function("cmd", [new_args, new_stdin])) as string;
  };

  tableExists = async (tableName: string) => {
    return await this.worker.post(new Function("tableExists", [tableName])) as boolean;
  };

  tableSchema = async(tableName: string, server: boolean = false) => {
    return await this.worker.post(new Function("tableSchema", [tableName, server])) as string;
  };

  viewExists = async (viewName: string) => {
    return await this.worker.post(new Function("viewExists", [viewName])) as boolean;
  };

  viewSchema = async(viewName: string, server: boolean = false) => {
    return await this.worker.post(new Function("viewSchema", [viewName, server])) as string;
  };

  schema = async(server: boolean = false) => {
    return await this.worker.post(new Function("schema", [server])) as string;
  };

  insert = async (tableName: string, values: Array<any>) => {
    return await this.worker.post(new Function("insert", [tableName, values])) as boolean;
  };

  save = async () => {
    return await this.worker.post(new Function("save", [])) as boolean;
  }

  createServerDatabase = async (dbName: string) => {
    return await this.worker.post(new Function("createServerDatabase", [dbName])) as ProtoResponseCreds;
  }

  createServerUser = async () => {
    return await this.worker.post(new Function("createServerUser", [])) as ProtoResponseCreds;
  }

  mirrorServerTable = async (tableName: string, filterExpr?: string) => {
    return await this.worker.post(new Function("mirrorServerTable", [tableName, filterExpr]));
  }

  serverClose = async ()  => {
    return await this.worker.post(new Function("serverClose", []));
  }
}