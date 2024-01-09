import { Environment, FileSystem } from "#std/sk_types";
import {
  SKDBMechanism,
  SKDB,
  RemoteSKDB,
  SKDBHandle,
  Params,
  SKDBSync,
  MirrorDefn,
} from "#skdb/skdb_types";
import { SKDBTable } from "#skdb/skdb_util";
import { SKDBGroupImpl } from "#skdb/skdb_group";
import { connect } from "#skdb/skdb_orchestration";

class SKDBMechanismImpl implements SKDBMechanism {
  writeCsv: (payload: string, source: string) => void;
  watermark: (replicationUid: string, table: string) => bigint;
  watchFile: (fileName: string, fn: (change: ArrayBuffer) => void) => void;
  getReplicationUid: (deviceUuid: string) => string;
  subscribe: (
    replicationUid: string,
    tables: string[],
    updateFile: string,
  ) => string;
  unsubscribe: (session: string) => void;
  diff: (
    session: string,
    watermarks: Map<string, bigint>,
  ) => ArrayBuffer | null;
  assertCanBeMirrored: (tableName: string) => void;
  tableExists: (tableName: string) => boolean;
  exec: (query: string) => SKDBTable;
  toggleView: (tableName: string) => void;

  constructor(
    client: SKDBSyncImpl,
    fs: FileSystem,
    utf8Encode: (v: string) => Uint8Array,
  ) {
    this.tableExists = (tableName: string) =>
      client.tableSchema(tableName) != "";
    this.exec = (query: string) => client.exec(query);
    this.assertCanBeMirrored = (tableName: string) =>
      client.assertCanBeMirrored(tableName);
    this.watermark = (replicationId: string, table: string) => {
      return BigInt(
        client.runLocal(["watermark", "--source", replicationId, table], ""),
      );
    };
    this.writeCsv = (payload: string, source: string) => {
      return client.runLocal(["write-csv", "--source", source], payload + "\n");
    };
    this.watchFile = (fileName: string, fn: (change: ArrayBuffer) => void) => {
      fs.watchFile(fileName, (change) => {
        if (change == "") {
          return;
        }
        fn(utf8Encode(change));
      });
    };
    this.getReplicationUid = (deviceUuid: string) => {
      return client.runLocal(["replication-id", deviceUuid], "").trim();
    };
    this.subscribe = (
      replicationUid: string,
      tables: string[],
      updateFile: string,
    ) => {
      return client
        .runLocal(
          [
            "subscribe",
            "--format=csv",
            "--updates",
            updateFile,
            "--ignore-source",
            replicationUid,
          ].concat(tables),
          "",
        )
        .trim();
    };
    this.unsubscribe = (session: string) => {
      client.runLocal(["disconnect", session], "").trim();
    };
    this.diff = (session: string, watermarks: Map<string, bigint>) => {
      const acc = {};
      for (const [table, wm] of watermarks.entries()) {
        acc[table] = { since: wm };
      }
      const diffSpec = JSON.stringify(acc, (_key, value) =>
        typeof value === "bigint" ? Number(value) : value,
      );
      let d = client.runLocal(["diff", "--format=csv", session], diffSpec);
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
  private accessKey: string;
  private fs: FileSystem;

  save: () => Promise<boolean>;
  runLocal: (new_args: Array<string>, new_stdin: string) => string;
  watch: (
    query: string,
    params: Params,
    onChange: (rows: SKDBTable) => void,
  ) => { close: () => void };
  watchChanges: (
    query: string,
    params: Params,
    init: (rows: SKDBTable) => void,
    update: (added: SKDBTable, removed: SKDBTable) => void,
  ) => { close: () => void };

  private runner: (fn: () => string) => SKDBTable;

  connectedRemote?: RemoteSKDB;

  private constructor(environment: Environment) {
    this.environment = environment;
    this.fs = environment.fs();
  }

  static create(
    handle: SKDBHandle,
    env: Environment,
    save: () => Promise<boolean>,
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
      if (typeof window === "undefined") {
        throw new Error(
          "No endpoint passed to connect and no window object to infer from.",
        );
      }
      const loc = window.location;
      const scheme = loc.protocol === "https:" ? "wss://" : "ws://";
      endpoint = `${scheme}${loc.host}`;
    }

    const creds = {
      accessKey: accessKey,
      privateKey: privateKey,
      deviceUuid: this.clientUuid,
    };

    this.accessKey = accessKey;

    this.connectedRemote = await connect(
      this.environment,
      new SKDBMechanismImpl(this, this.fs, this.environment.encodeUTF8),
      endpoint,
      db,
      creds,
    );

    // Setting up local privacy checks
    await this.mirror(
      "skdb_user_permissions",
      "skdb_groups",
      "skdb_group_permissions",
    );
    await this.exec(
      "CREATE UNIQUE INDEX skdb_permissions_group_user ON skdb_group_permissions(groupID, userID);",
    );

    await this.setUser(accessKey);
  }

  getUser(): string | undefined {
    return this.accessKey;
  }

  watermark(replicationId: string, table: string): bigint {
    return BigInt(
      this.runLocal(["watermark", "--source", replicationId, table], ""),
    );
  }

  subscribe = (viewName: string, f: (change: string) => void) => {
    const fileName = "/subscriptions/sub" + this.subscriptionCount;
    this.fs.watchFile(fileName, f);
    this.subscriptionCount++;
    this.runLocal(
      ["subscribe", viewName, "--format=csv", "--updates", fileName],
      "",
    );
  };

  addParams = (
    args: Array<string>,
    params: Params,
    stdin: string,
  ): [Array<string>, string] => {
    if (params instanceof Map) {
      params = Object.fromEntries(params);
    }
    let args1 = ["--expect-query-params"].concat(args);
    let stdin1 = JSON.stringify(params) + "\n" + stdin;
    return [args1, stdin1];
  };

  exec = (stdin: string, params: Params = new Map()) => {
    return this.runner(() => {
      let [args1, stdin1] = this.addParams(["--format=js"], params, stdin);
      return this.runLocal(args1, stdin1);
    });
  };

  tableSchema = (tableName: string) => {
    return this.runLocal(["dump-table", tableName], "");
  };

  setUser = (userName: string) => {
    return this.runLocal(["set-user", userName], "");
  };

  viewSchema = (viewName: string) => {
    return this.runLocal(["dump-view", viewName], "");
  };

  schema = (tableName?: string) => {
    if (tableName === undefined) {
      const tables = this.runLocal(["dump-tables"], "");
      const views = this.runLocal(["dump-views"], "");
      return tables + views;
    }

    const viewSchema = this.viewSchema(tableName);
    if (viewSchema.trim() != "") {
      return viewSchema;
    }

    return this.tableSchema(tableName);
  };

  insert = (tableName: string, values: Array<any>) => {
    let params = new Map();
    let keys = values.map((val, i) => {
      let key = "@key" + i;
      params.set(key, val);
      return key;
    });
    let stdin =
      "insert into " + tableName + " values (" + keys.join(", ") + ");";
    let [args1, stdin1] = this.addParams([], params, stdin);
    return this.runLocal(args1, stdin1) == "";
  };

  assertCanBeMirrored(tableName: string): void {
    const error = this.runLocal(["can-mirror", tableName], "");
    if (error === "") {
      return;
    }
    throw new Error(error);
  }
  async mirror(...tables: MirrorDefn[]) {
    const is_mirror_def_of = (table) => (mirror_def) =>
      mirror_def === table || mirror_def.table === table;
    for (const metatable of [
      "skdb_user_permissions",
      "skdb_groups",
      "skdb_group_permissions",
    ]) {
      if (!tables.some(is_mirror_def_of(metatable))) tables.push(metatable);
    }
    return this.connectedRemote!.mirror(...tables);
  }

  async serverExec(query: string, params: Params) {
    return this.connectedRemote!.exec(query, params);
  }

  async serverTableSchema(tableName: string) {
    return this.connectedRemote!.tableSchema(tableName);
  }

  async serverViewSchema(tableName: string) {
    return this.connectedRemote!.viewSchema(tableName);
  }

  async serverSchema() {
    return this.connectedRemote!.schema();
  }

  createServerDatabase = (dbName: string) =>
    this.connectedRemote!.createDatabase(dbName);
  createServerUser = () => this.connectedRemote!.createUser();
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
  };

  subscribe = async (viewName: string, f: (change: string) => void) => {
    return this.skdbSync.subscribe(viewName, f);
  };

  exec = async (stdin: string, params: Params = new Map()) => {
    const rows = await this.skdbSync.exec(stdin, params);
    return new SKDBTable(...rows);
  };

  async watch(
    query: string,
    params: Params,
    onChange: (rows: SKDBTable) => void,
  ) {
    let closable = this.skdbSync.watch(query, params, onChange);
    return Promise.resolve({ close: () => Promise.resolve(closable.close()) });
  }

  async watchChanges(
    query: string,
    params: Params,
    init: (rows: SKDBTable) => void,
    update: (added: SKDBTable, removed: SKDBTable) => void,
  ) {
    let closable = this.skdbSync.watchChanges(query, params, init, update);
    return Promise.resolve({ close: () => Promise.resolve(closable.close()) });
  }

  tableSchema = async (tableName: string) => {
    return this.skdbSync.tableSchema(tableName);
  };

  viewSchema = async (viewName: string) => {
    return this.skdbSync.viewSchema(viewName);
  };

  schema = async (tableName?: string) => {
    return this.skdbSync.schema(tableName);
  };

  async insert(tableName: string, values: Array<any>) {
    return this.skdbSync.insert(tableName, values);
  }

  async mirror(...tables: MirrorDefn[]) {
    return this.skdbSync.mirror(...tables);
  }

  async closeConnection() {
    return this.skdbSync.serverClose();
  }

  async save() {
    return this.skdbSync.save();
  }

  async createGroup() {
    return SKDBGroupImpl.create(this);
  }
  async lookupGroup(groupID: string) {
    return SKDBGroupImpl.lookup(this, groupID);
  }

}
