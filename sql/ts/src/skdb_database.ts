import { Environment, FileSystem } from "#std/sk_types";
import { SkdbMechanism, SKDB, RemoteSKDB, SkdbHandle, Params, SKDBSync, MirrorDefn } from "#skdb/skdb_types";
import { connect } from "#skdb/skdb_orchestration";

class SkdbMechanismImpl implements SkdbMechanism {
  writeCsv: (payload: string, source: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (replicationUid: string, tables: string[], updateFile: string) => string;
  unsubscribe: (session: string) => void;
  diff: (session: string, watermarks: Map<string, bigint>) => ArrayBuffer | null;
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
    this.writeCsv = (payload: string, source: string) => {
      return client.runLocal(["write-csv", "--source", source], payload + '\n');
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
    this.subscribe = (replicationUid: string, tables: string[], updateFile: string) => {
      return client.runLocal(
        [
          "subscribe", "--format=csv",
          "--updates", updateFile, "--ignore-source", replicationUid
        ].concat(tables),
        ""
      ).trim()
    };
    this.unsubscribe = (session: string) => {
      client.runLocal(["disconnect", session], "").trim()
    };
    this.diff = (session: string, watermarks: Map<string, bigint>) => {
      const acc = {};
      for (const [table, wm] of watermarks.entries()) {
        acc[table] = {since: wm}
      }
      const diffSpec = JSON.stringify(acc, (_key, value) =>
        typeof value === 'bigint' ? Number(value) : value
      );
      let d = client.runLocal(
        [
          "diff", "--format=csv",
          session,
        ],
        diffSpec
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
  watchChanges: (query: string, params: Params, onChange: (added: Array<any>, removed: Array<any>) => void) => { close: () => void }

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
    client.watchChanges = handle.watchChanges;
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

  schema = (tableName?: string) => {
    if (tableName === undefined) {
      const tables = this.runLocal(["dump-tables"], "");
      const views = this.runLocal(["dump-views"], "");
      return tables + views;
    }

    const viewSchema = this.viewSchema(tableName);
    if (viewSchema.trim() != '') {
      return viewSchema
    }

    return this.tableSchema(tableName);
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
  mirror = (...tables: MirrorDefn[]) => this.connectedRemote!.mirror(...tables);
  serverClose = () => this.connectedRemote!.close();
}

export class SKDBImpl implements SKDB {
  private skdbSync: SKDBSync;

  constructor(skdbSync: SKDBSync) {
    this.skdbSync = skdbSync;
  }

  currentUser?: string;

  async connect(
    db: string,
    accessKey: string,
    privateKey: CryptoKey,
    endpoint?: string,
  ): Promise<void> {
    this.currentUser = accessKey;
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

  async watchChanges(query: string, params: Params, onChanges: (added: Array<any>, deleted: Array<any>) => void) {
    let closable = this.skdbSync.watchChanges(query, params, onChanges);
    return Promise.resolve({ close: () => Promise.resolve(closable.close()) })
  }


  tableSchema = async (tableName: string) => {
    return this.skdbSync.tableSchema(tableName);
  }

  viewSchema = async (viewName: string) => {
    return this.skdbSync.viewSchema(viewName);
  }

  schema = async (tableName?: string) => {
    return this.skdbSync.schema(tableName);
  }

  async insert(tableName: string, values: Array<any>) {
    return this.skdbSync.insert(tableName, values);
  }

  async mirror(...tables: MirrorDefn[]) {
    return this.skdbSync.mirror(...tables);
  }

  async closeConnection() {
    return this.skdbSync.serverClose()
  }

  async save() {
    return this.skdbSync.save()
  }
}
