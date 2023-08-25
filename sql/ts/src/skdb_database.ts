
import { Environment, FileSystem} from "#std/sk_types";
import { Orchestrable, SKDB, Server, SKDBCallable, Utility} from "#skdb/skdb_types";
import { connect } from "#skdb/skdb_orchestration";

class OrchestrableImpl implements Orchestrable {
  writeCsv: (table: string, payload: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (replicationUid: string, table: string, updateFile: string) => string;
  diff: (watermark: bigint, session: string) => ArrayBuffer | null;
  assertCanBeMirrored: (tableName: string) => void;
  tableExists: (tableName: string) => Promise<boolean>;
  sql: (query: string) => Promise<Array<any>>;

  constructor(client: SKDBImpl, fs: FileSystem, utf8Encode: (v: string) => Uint8Array) {
    this.tableExists = (tableName: string) => client.tableExists(tableName);
    this.sql = (query: string) => client.sql(query);
    this.assertCanBeMirrored = (tableName: string) => client.assertCanBeMirrored(tableName);
    this.watermark = (replicationId: string, table: string) => {
      return BigInt(client.runLocal(["watermark", "--source", replicationId, table], ""));
    };
    this.writeCsv = (table: string, payload: string) => {
      return client.runLocal(["write-csv", table], payload + '\n');
    };
    this.watchFile = (fileName: string, fn: (change: ArrayBuffer) => void) => {
      fs.watchFile(fileName, change => {
        if (change == "") {
          return;
        }
        fn(utf8Encode(change));
      });
    };
    this.getReplicationUid = (deviceUuid: string) => {
      return client.runLocal(["replication-id", deviceUuid], "").trim()
    };
    this.subscribe = (replicationUid: string, table: string, updateFile: string) => {
      return client.runLocal(
        [
          "subscribe", table, "--connect", "--format=csv",
          "--updates", updateFile, "--ignore-source", replicationUid
        ],
        ""
      ).trim()
    };
    this.diff = (watermark: bigint, session: string) => {
      let d = client.runLocal(
        [
          "diff", "--format=csv",
          "--since",
          watermark.toString(),
          session,
        ], 
        ""
      );
      if (d == "") {
        return null;
      }
      return utf8Encode(d);
    };
  }
}

export class SKDBImpl implements SKDB {
  private environment: Environment;
  private subscriptionCount: number = 0;
  private clientUuid: string = "";
  private fs: FileSystem;

  registerFun: <T1, T2>(f: (obj: T1) => T2) => SKDBCallable<T1, T2>;
  addRoot: <T1, T2>(rootName: string, callable: (obj: T1) => T2 | SKDBCallable<T1, T2>, arg: T1) => void;
  removeRoot: (rootName: string) => void;
  getRoot: (rootName: string) => any;
  trackedCall: <T1, T2>(callable: SKDBCallable<T1, T2>, arg: T1) => T2;
  trackedQuery: (request: string, start?: number, end?: number) => any;
  onRootChange: (f: (rootName: string) => void) => void;
  save: () => Promise<boolean>;
  runLocal: (new_args: Array<string>, new_stdin: string) => string;
  
  private runner: (fn: () => string) => Promise<Array<any>>;

  server?: Server;

  private constructor(environment: Environment) {
    this.environment = environment;
    this.fs = environment.fs();
  }

  static async create(
    utility: Utility,
    env: Environment,
    save: () => Promise<boolean> 
  ): Promise<SKDB> {
    let client = new SKDBImpl(env);
    client.save = save;
    client.runLocal = utility.main;
    client.clientUuid = env.crypto().randomUUID();
    client.onRootChange =  (f: (rootName: string) => void) => {
      utility.addRootChangeListener(f);
    };
    client.addRoot = <T1, T2>(rootName: string, callable: (obj: T1) => T2 | SKDBCallable<T1, T2>, arg: T1) => utility.addRoot(rootName, callable, arg);
    client.removeRoot = (rootName) => utility.removeRoot(rootName);
    client.getRoot = (rootName) => utility.getRoot(rootName);
    client.trackedCall = <T1, T2>(callable: SKDBCallable<T1, T2>, arg: T1) => utility.trackedCall(callable, arg);
    client.trackedQuery = (request: string, start?: number, end?: number) => utility.trackedQuery(request, start, end);
    client.runner = utility.runner;
    client.registerFun = <T1, T2>(f: (obj: T1) => T2) => utility.registerFun(f);
    client.runSubscribeRoots(utility);
    return client;
  }

  async connect(
    db: string,
    accessKey: string,
    privateKey: CryptoKey,
    endpoint?: string,
  ): Promise<void> {
    if (!endpoint) {
      if (typeof window === 'undefined') {
        throw new Error("No endpoint passed to connect and no window object to infer from.");
      }
      const loc = window.location;
      const scheme = loc.protocol === "https:" ? "wss://" : "ws://"
      endpoint = `${scheme}${loc.host}`
    }

    const creds = {
      accessKey: accessKey,
      privateKey: privateKey,
      deviceUuid: this.clientUuid,
    };
    
    this.server = await connect(
      this.environment, 
      new OrchestrableImpl(this, this.fs, this.environment.encodeUTF8),
      endpoint,
      db,
      creds
    );
  }

  watermark(replicationId: string, table: string): bigint {
    return BigInt(this.runLocal(["watermark", "--source", replicationId, table], ""));
  }

  cmd(new_args: Array<string>, new_stdin: string): Promise<string> {
    return Promise.resolve(this.runLocal(new_args, new_stdin));
  }

  subscribe = async (viewName: string, f: (change: string) => void) => {
    const fileName = "/subscriptions/sub" + this.subscriptionCount;
    this.fs.watchFile(fileName, f);
    this.subscriptionCount++;
    this.runLocal(
      ["subscribe", viewName, "--format=csv", "--updates", fileName],
      ""
    );
  }

  addParams = (
    args: Array<string>,
    params: Map<string, string|number>,
    stdin: string
  ): [Array<string>, string] => {
    let args1 = ["--expect-query-params"].concat(args);
    let stdin1 = JSON.stringify(Object.fromEntries(params)) + '\n' + stdin;
    return [args1, stdin1];
  }

  sqlRaw = async (stdin: string, params: Map<string, string|number> = new Map(), server: boolean = false) => {
    if (server) {
      return await this.server!.sqlRaw(stdin, params);
    } else {
      let [args1, stdin1] = this.addParams([], params, stdin);
      return this.runLocal(args1, stdin1);
    }
  }

  sql = async (stdin: string, params: Map<string, string|number> = new Map(), server: boolean = false) => {
    if (server) {
      return await this.server!.sql(stdin, params);
    } else {
      return await this.runner(() => {
        let [args1, stdin1] = this.addParams(["--format=js"], params, stdin);
        return this.runLocal(args1, stdin1)
      });
    }
  }

  tableExists = async (tableName: string) => {
    return this.runLocal(["dump-table", tableName], "").trim() != "";
  }

  tableSchema = async (tableName: string, server: boolean = false) => {
    if (server) {
      return await this.server!.tableSchema(tableName);
    } else {
      return this.runLocal(["dump-table", tableName], "");
    }
  }

  viewExists = async (viewName: string) => {
    return this.runLocal(["dump-view", viewName], "") != "";
  }

  viewSchema = async (viewName: string, server: boolean = false) => {
    if (server) {
      return await this.server!.viewSchema(viewName);
    } else {
      return this.runLocal(["dump-view", viewName], "");
    }
  }

  schema = async (server: boolean = false) => {
    if (server) {
      return await this.server!.schema();
    } else {
      const tables = this.runLocal(["dump-tables"], "");
      const views = this.runLocal(["dump-views"], "");
      return tables + views;
    }
  }

  insert = async (tableName: string, values: Array<any>) => {
    let params = new Map();
    let keys =
      values.map((val, i) => {
        let key = "@key" + i;
        params.set(key, val);
        return key;
      });
    let stdin =
      "insert into " + tableName + " values (" + keys.join(", ") + ");";
    let [args1, stdin1] = this.addParams([], params, stdin);
    return this.runLocal(args1, stdin1) == "";
  }

  assertCanBeMirrored(tableName: string): void {
    const error = this.runLocal(["can-mirror", tableName], "");
    if (error === "") {
      return
    }
    throw new Error(error);
  }

  createServerDatabase = (dbName: string) => this.server!.createDatabase(dbName);
  createServerUser = () => this.server!.createUser();
  mirrorServerTable = (tableName: string, filterExpr?: string) => this.server!.mirrorTable(tableName, filterExpr);
  serverClose = () => Promise.resolve(this.server!.close());

  private runSubscribeRoots(utility: Utility): void {
    let fileName = "/subscriptions/jsroots";
    this.fs.watchFile(fileName, (text) => {
      let changed = new Map();
      let updates = text.split("\n").filter((x) => x.indexOf("\t") != -1);
      for (const update of updates) {
        if (update.substring(0, 1) !== "0") continue;
        let json = JSON.parse(update.substring(update.indexOf("\t") + 1));
        utility.removeSubscribedRoot(json.name);
        changed.set(json.name, true);
      }
      for (const update of updates) {
        if (update.substring(0, 1) === "0") continue;
        let json = JSON.parse(update.substring(update.indexOf("\t") + 1));
        utility.addSubscribedRoot(json.name, json.value);
        changed.set(json.name, true);
      }
      for (const f of utility.getRootChangeListeners()) {
        for (const name of changed.keys()) {
          f(name);
        }
      }
    });
    this.subscriptionCount++;
    this.runLocal(
      ["subscribe", "jsroots", "--format=json", "--updates", fileName],
      ""
    );
  }
}
