import { Environment, FileSystem } from "#std/sk_types";
import { SkdbMechanism, SKDB, RemoteSKDB, SkdbHandle, Params, SKDBSync } from "#skdb/skdb_types";
import { connect } from "#skdb/skdb_orchestration";

class SkdbMechanismImpl implements SkdbMechanism {
  writeCsv: (table: string, payload: string, source: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (replicationUid: string, table: string, updateFile: string) => string;
  diff: (watermark: bigint, session: string) => ArrayBuffer | null;
  assertCanBeMirrored: (tableName: string) => void;
  tableExists: (tableName: string) => boolean;
  exec: (query: string) => Array<any>;
  toggleView: (tableName: string) => void;

  constructor(client: SKDBSyncImpl, fs: FileSystem, utf8Encode: (v: string) => Uint8Array) {
    this.tableExists = (tableName: string) => client.tableSchema(tableName) != "";
    this.exec = (query: string) => client.exec(query);
    this.assertCanBeMirrored = (tableName: string) => client.assertCanBeMirrored(tableName);
    this.watermark = (replicationId: string, table: string) => {
      return BigInt(client.runLocal(["watermark", "--source", replicationId, table], ""));
    };
    this.writeCsv = (table: string, payload: string, source: string) => {
      return client.runLocal(["write-csv", table, "--source", source], payload + '\n');
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
      if (d.trim() == "") {
        return null;
      }
      return utf8Encode(d);
    };
    this.toggleView = (table: string) => {
      return client.runLocal(["toggle-view", table], "");
    };
  }
}

export class SKDBSyncImpl implements SKDBSync {
  private environment: Environment;
  private subscriptionCount: number = 0;
  private clientUuid: string = "";
  private fs: FileSystem;

  save: () => Promise<boolean>;
  runLocal: (new_args: Array<string>, new_stdin: string) => string;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }

  private runner: (fn: () => string) => Array<any>;

  connectedRemote?: RemoteSKDB;

  private constructor(environment: Environment) {
    this.environment = environment;
    this.fs = environment.fs();
  }

  static create(
    handle: SkdbHandle,
    env: Environment,
    save: () => Promise<boolean>
  ): SKDBSync {
    let client = new SKDBSyncImpl(env);
    client.save = save;
    client.runLocal = handle.main;
    client.clientUuid = env.crypto().randomUUID();
    client.runner = handle.runner;
    client.watch = handle.watch;
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

    this.connectedRemote = await connect(
      this.environment,
      new SkdbMechanismImpl(this, this.fs, this.environment.encodeUTF8),
      endpoint,
      db,
      creds
    );
  }

  watermark(replicationId: string, table: string): bigint {
    return BigInt(this.runLocal(["watermark", "--source", replicationId, table], ""));
  }

  subscribe = (viewName: string, f: (change: string) => void) => {
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
    params: Params,
    stdin: string
  ): [Array<string>, string] => {
    if (params instanceof Map) {
      params = Object.fromEntries(params);
    }
    let args1 = ["--expect-query-params"].concat(args);
    let stdin1 = JSON.stringify(params) + '\n' + stdin;
    return [args1, stdin1];
  }

  exec = (stdin: string, params: Params = new Map()) => {
    return this.runner(() => {
      let [args1, stdin1] = this.addParams(["--format=js"], params, stdin);
      return this.runLocal(args1, stdin1)
    });
  }

  tableSchema = (tableName: string) => {
    return this.runLocal(["dump-table", tableName], "");
  }

  viewSchema = (viewName: string) => {
    return this.runLocal(["dump-view", viewName], "")
  }

  schema = () => {
    const tables = this.runLocal(["dump-tables"], "");
    const views = this.runLocal(["dump-views"], "");
    return tables + views;
  }

  insert = (tableName: string, values: Array<any>) => {
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

  async serverExec(query: string, params: Params) {
    return this.connectedRemote!.exec(query, params);
  }

  async serverTableSchema(tableName: string) {
    return this.connectedRemote!.tableSchema(tableName);
  };

  async serverViewSchema(tableName: string) {
    return this.connectedRemote!.viewSchema(tableName);
  };

  async serverSchema() {
    return this.connectedRemote!.schema();
  }

  createServerDatabase = (dbName: string) => this.connectedRemote!.createDatabase(dbName);
  createServerUser = () => this.connectedRemote!.createUser();
  mirror = (tableName: string, filterExpr?: string) => this.connectedRemote!.mirror(tableName, filterExpr);
  serverClose = () => this.connectedRemote!.close();
}

export class SKDBImpl implements SKDB {
  private skdbSync: SKDBSync;

  constructor(skdbSync: SKDBSync) {
    this.skdbSync = skdbSync;
  }

  async connect(
    db: string,
    accessKey: string,
    privateKey: CryptoKey,
    endpoint?: string,
  ): Promise<void> {
    return this.skdbSync.connect(db, accessKey, privateKey, endpoint);
  }

  connectedRemote = async () => {
    return this.skdbSync.connectedRemote;
  }

  subscribe = async (viewName: string, f: (change: string) => void) => {
    return this.skdbSync.subscribe(viewName, f);
  }

  exec = async (stdin: string, params: Params = new Map()) => {
    return this.skdbSync.exec(stdin, params);
  }

  async watch(query: string, params: Params, onChange: (rows: Array<any>) => void) {
    let closable = this.skdbSync.watch(query, params, onChange);
    return Promise.resolve({ close: () => Promise.resolve(closable.close()) })
  }

  tableSchema = async (tableName: string) => {
    return this.skdbSync.tableSchema(tableName);
  }

  viewSchema = async (viewName: string) => {
    return this.skdbSync.viewSchema(viewName);
  }

  schema = async () => {
    return this.skdbSync.schema();
  }

  async insert(tableName: string, values: Array<any>) {
    return this.skdbSync.insert(tableName, values);
  }

  async mirror(tableName: string, filterExpr?: string) {
    return this.skdbSync.mirror(tableName, filterExpr);
  }

  async closeConnection() {
    return this.skdbSync.serverClose()
  }

  async save() {
    return this.skdbSync.save()
  }
}
