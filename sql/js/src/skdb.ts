/* ***************************************************************************/
/* WASM Loading. */
/* ***************************************************************************/

export async function fetchWasmSource(): Promise<Uint8Array> {
  let wasmModule = await fetch(new URL("../skdb.wasm", import.meta.url));
  let wasmBuffer = await wasmModule.arrayBuffer();
  return new Uint8Array(wasmBuffer);
}

/* ***************************************************************************/
/* Interfaces. */
/* ***************************************************************************/

interface Memory {
  buffer: ArrayBuffer;
}

interface WasmExports {
  SKIP_Obstack_alloc: (size: number) => number;
  sk_string_create: (addr: number, size: number) => number;
  SKIP_throw_EndOfFile: () => void;
  SKIP_add_root: (
    rootNameWasmStr: number,
    funId: number,
    funArg: number
  ) => void;
  SKIP_remove_root: (rootNameWasmStr: number) => void;
  SKIP_skfs_init: () => void;
  SKIP_initializeSkip: () => void;
  SKIP_skfs_end_of_init: () => void;
  SKIP_init_jsroots: () => void;
  SKIP_call0: (f: () => void) => void;
  SKIP_get_persistent_size: () => number;
  sk_pop_dirty_page: () => number;
  SKIP_get_version: () => number;
  SKIP_tracked_call: (funId: number, funArg: number) => number;
  SKIP_tracked_query: (request: number, start: number, end: number) => number;
  skip_main: () => void;
  memory: Memory;
}

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

function clearSKDBStore(
  dbName: string,
  storeName: string,
): Promise<void> {
  if (typeof indexedDB === 'undefined') {
    throw new Error("No indexedDB in this environment.");
  }
  return new Promise((resolve, reject) => {
    let open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      let db = open.result;
      let store = db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      let db = open.result;
      let tx = db.transaction(storeName, "readwrite");
      let store = tx.objectStore(storeName);

      store.clear();

      tx.oncomplete = function () {
        resolve();
      };

      tx.onerror = function (err) {
        reject(err);
      };
    };

    open.onerror = function (err) {
      reject(err);
    };
  });
}

class RebootStatus {
  isReboot: boolean = false;
}

function makeSKDBStore(
  dbName: string,
  storeName: string,
  version: number,
  memory: ArrayBuffer,
  memorySize: number,
  rebootStatus: RebootStatus,
  pageSize: number
): Promise<IDBDatabase> {
  if (typeof indexedDB === 'undefined') {
    throw new Error("No indexedDB in this environment.");
  }
  let memory32 = new Uint32Array(memory);
  // Let's round up the memorySize to be pageSize aligned
  memorySize = (memorySize + (pageSize - 1)) & ~(pageSize - 1);

  return new Promise((resolve, reject) => {
    let open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      let db = open.result;
      let store = db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      let db = open.result;
      let tx = db.transaction(storeName, "readwrite");
      let store = tx.objectStore(storeName);

      store.getAll().onsuccess = (event) => {
        let target = event.target;
        if(target == null) {
          reject(new Error("Unexpected null target"));
          return;
        }
        let pages =
            (
              target as unknown as
              { result: Array<{pageid: number, content: ArrayBuffer}>}
            ).result;
        if(pages.length == 0) {
          rebootStatus.isReboot = true;
          let i;
          let cursor = 0;
          for (i = 0; i < memorySize / pageSize; i++) {
            const content = memory.slice(cursor, cursor + pageSize);
            store.put({ pageid: i, content: content });
            cursor = cursor + pageSize;
          }
        }
        else {
          for (let pageIdx = 0; pageIdx < pages.length; pageIdx++) {
            let page = pages[pageIdx]!;
            const pageid = page.pageid;
            if (pageid < 0) continue;
            let pageBuffer = new Uint32Array(page.content);
            const start = pageid * (pageSize / 4);
            for (let i = 0; i < pageBuffer.length; i++) {
              memory32[start + i] = pageBuffer[i]!;
            }
          }
        }
      }

      tx.oncomplete = function () {
        resolve(db);
      };

      tx.onerror = function (err) {
        reject(err);
      };
    };

    open.onerror = function (err) {
      reject(err);
    };
  });
}

/* ***************************************************************************/
/* A few primitives to encode/decode. */
/* ***************************************************************************/

function encodeUTF8(exports: WasmExports, s: string): number {
  let data = new Uint8Array(exports.memory.buffer);
  let i = 0,
    addr = exports.SKIP_Obstack_alloc(s.length * 4);
  for (let ci = 0; ci != s.length; ci++) {
    let c = s.charCodeAt(ci);
    if (c < 128) {
      data[addr + i++] = c;
      continue;
    }
    if (c < 2048) {
      data[addr + i++] = (c >> 6) | 192;
    } else {
      if (c > 0xd7ff && c < 0xdc00) {
        if (++ci >= s.length)
          throw new Error("UTF-8 encode: incomplete surrogate pair");
        let c2 = s.charCodeAt(ci);
        if (c2 < 0xdc00 || c2 > 0xdfff)
          throw new Error(
            "UTF-8 encode: second surrogate character 0x" +
              c2.toString(16) +
              " at index " +
              ci +
              " out of range"
          );
        c = 0x10000 + ((c & 0x03ff) << 10) + (c2 & 0x03ff);
        data[addr + i++] = (c >> 18) | 240;
        data[addr + i++] = ((c >> 12) & 63) | 128;
      } else data[addr + i++] = (c >> 12) | 224;
      data[addr + i++] = ((c >> 6) & 63) | 128;
    }
    data[addr + i++] = (c & 63) | 128;
  }
  return exports.sk_string_create(addr, i);
}

function encodeUTF8Str(text: string): Uint8Array {
  const encoder = new TextEncoder();
  return encoder.encode(text);
}

function decodeUTF8(bytes: ArrayBuffer): string {
  const decoder = new TextDecoder("utf-8", {fatal: true});
  return decoder.decode(bytes);
}

function wasmStringToJS(exports: WasmExports, wasmPointer: number): string {
  let size = exports["SKIP_String_byteSize"](wasmPointer);
  let data = new Uint8Array(exports.memory.buffer);

  return decodeUTF8(data.slice(wasmPointer, wasmPointer + size));
}

function stringify(obj: any): string {
  if (obj === undefined) {
    obj = null;
  }
  return JSON.stringify(obj);
}

/* ***************************************************************************/
/* The type used to represent callables. */
/* ***************************************************************************/

class SKDBCallable<T1, T2> {
  private id: number;

  constructor(id: number) {
    this.id = id;
  }

  getId(): number {
    return this.id;
  }
}

/* ***************************************************************************/
/* The local database. */
/* ***************************************************************************/

function metadataTable(tableName: string): string {
  return `skdb__${tableName}_sync_metadata`;
}

export class SKDB {
  private subscriptionCount: number = 0;
  private args: Array<string> = [];
  private current_stdin: number = 0;
  private stdin: string = "";
  private stdout: Array<string> = new Array();
  private stdout_objects: Array<any> = new Array();
  private onRootChangeFuns: Array<(rootName: string) => void> = new Array();
  private externalFuns: Array<(any) => any> = [];
  private fileDescrs: Map<string, number> = new Map();
  private fileDescrNbr: number = 2;
  private files: Array<Array<String>> = new Array();
  private changed_files: Array<number> = new Array();
  private execOnChange: Array<(change: string) => void> = new Array();
  private lineBuffer: Array<number> = [];
  private storeName: string | null;
  private nbrInitPages: number = -1;
  private roots: Map<string, number> = new Map();
  private pageSize: number = -1;
  private db: IDBDatabase | null = null;
  private dirtyPagesMap: Array<number> = [];
  private dirtyPages: Array<number> = [];
  // @ts-expect-error
  private exports: WasmExports;
  private clientUuid: string = "";

  server?: SKDBServer;

  private constructor(storeName: string | null) {
    this.storeName = storeName;
  }

  static async clear(dbName: string, storeName: string): Promise<void> {
    await clearSKDBStore(dbName, storeName);
  }

  static async create(
    dbName: string | null = null,
    getWasmSource?: () => Promise<Uint8Array>
  ): Promise<SKDB> {
    let storeName: string | null = null;
    if(dbName != null) {
      storeName = "SKDBStore";
    }
    let client = new SKDB(storeName);
    let pageBitSize = 20;
    client.pageSize = 1 << pageBitSize;
    let env = client.makeWasmImports();
    // NOTE `skdb-wasm-b64` is imported dynamically to avoid bundling
    // the wasm in the same file.
    const getWasmSource_ = getWasmSource ?? (
      () => import('./skdb-wasm-b64.js').then((mod) => mod.getWasmSource())
    );
    const wasmBytes = await getWasmSource_();
    let wasm = await WebAssembly.instantiate(wasmBytes, { env: env });
    let exports = wasm.instance.exports as unknown as WasmExports;
    client.exports = exports;
    exports.SKIP_skfs_init();
    exports.SKIP_initializeSkip();
    exports.SKIP_skfs_end_of_init();
    client.nbrInitPages = exports.SKIP_get_persistent_size() / client.pageSize + 1;
    let version = exports.SKIP_get_version();
    let rebootStatus = new RebootStatus();
    if(dbName != null && storeName != null) {
      client.db = await makeSKDBStore(
        dbName,
        storeName,
        version,
        exports.memory.buffer,
        exports.SKIP_get_persistent_size(),
        rebootStatus,
        client.pageSize
      );
    }

    client.exports.SKIP_init_jsroots();
    client.runSubscribeRoots(rebootStatus.isReboot);

    client.clientUuid = crypto.randomUUID();

    return client;
  }

  openFile(filename: string): number {
    if (this.fileDescrs[filename] !== undefined) {
      return this.fileDescrs[filename];
    }
    let fd = this.fileDescrNbr;
    this.files[fd] = new Array();
    this.fileDescrs[filename] = fd;
    this.fileDescrNbr++;
    return fd;
  }

  watchFile(filename: string, f: (change: string) => void): void {
    const fd = this.openFile(filename);
    this.execOnChange[fd] = f;
  }

  async connect(
    db: string,
    accessKey: string,
    privateKey: CryptoKey,
    endpoint?: string,
  ): Promise<SKDBServer> {
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

    this.server = await SKDBServer.connect(this, endpoint, db, creds);
    return this.server;
  }

  private makeWasmImports(): {} {
    let data = this;
    let field_names: Array<string> = new Array();
    let objectIdx = 0;
    let object: {[k: string]: any} = {};
    return {
      abort: function (err) {
        throw new Error("abort " + err);
      },
      abortOnCannotGrowMemory: function (err) {
        throw new Error("abortOnCannotGrowMemory " + err);
      },
      __cxa_throw: function (ptr, type, destructor) {
        throw ptr;
      },
      SKIP_print_backtrace: function () {
        console.trace("");
      },
      SKIP_etry: function (f, exn_handler) {
        try {
          return data.exports.SKIP_call0(f);
        } catch (_) {
          return data.exports.SKIP_call0(exn_handler);
        }
      },
      __setErrNo: function (err) {
        throw new Error("ErrNo " + err);
      },
      SKIP_call_external_fun: function (funId, str) {
        return encodeUTF8(
          data.exports,
          stringify(
            data.externalFuns[funId]!(
              JSON.parse(wasmStringToJS(data.exports, str))
            )
          )
        );
      },
      SKIP_print_error: function (str) {
        console.error(wasmStringToJS(data.exports, str));
      },
      SKIP_read_line_fill: function () {
        data.lineBuffer = [];
        const endOfLine = 10;
        if (data.current_stdin >= data.stdin.length) {
          data.exports.SKIP_throw_EndOfFile();
        }
        while (data.stdin.charCodeAt(data.current_stdin) !== 10) {
          if (data.current_stdin >= data.stdin.length) {
            if (data.lineBuffer.length == 0) {
              data.exports.SKIP_throw_EndOfFile();
            } else {
              return data.lineBuffer;
            }
          }
          data.lineBuffer.push(data.stdin.charCodeAt(data.current_stdin));
          data.current_stdin++;
        }
        data.current_stdin++;
        return data.lineBuffer;
      },
      SKIP_read_line_get: function (i) {
        return data.lineBuffer[i];
      },
      SKIP_getchar: function (i) {
        if (data.current_stdin >= data.stdin.length) {
          data.exports.SKIP_throw_EndOfFile();
        }
        let result = data.stdin.charCodeAt(data.current_stdin);
        data.current_stdin++;
        return result;
      },
      SKIP_clear_field_names: function() {
        field_names = new Array();
      },
      SKIP_push_field_name: function(str) {
        field_names.push(wasmStringToJS(data.exports, str))
      },
      SKIP_clear_object: function() {
        objectIdx = 0;
        object = {};
      },
      SKIP_push_object_field_null: function() {
        let field_name: string = field_names[objectIdx]!;
        object[field_name] = null;
        objectIdx++;
      },
      SKIP_push_object_field_int32: function(n: number) {
        let field_name: string = field_names[objectIdx]!;
        object[field_name] = n;
        objectIdx++;
      },
      SKIP_push_object_field_int64: function(str) {
        let field_name: string = field_names[objectIdx]!;
        object[field_name] = parseInt(wasmStringToJS(data.exports, str), 10);
        objectIdx++;
      },
      SKIP_push_object_field_float: function(str) {
        let field_name: string = field_names[objectIdx]!;
        object[field_name] = parseFloat(wasmStringToJS(data.exports, str));
        objectIdx++;
      },
      SKIP_push_object_field_string: function(str) {
        let field_name: string = field_names[objectIdx]!;
        object[field_name] = wasmStringToJS(data.exports, str);
        objectIdx++;
      },
      SKIP_push_object: function () {
        data.stdout_objects.push(object);
      },
      SKIP_print_raw: function (str) {
        data.stdout.push(wasmStringToJS(data.exports, str));
      },
      SKIP_getArgc: function (i) {
        return data.args.length;
      },
      SKIP_getArgN: function (n) {
        return encodeUTF8(data.exports, data.args[n]!);
      },
      SKIP_unix_open: function (wasmFilename) {
        let filename = wasmStringToJS(data.exports, wasmFilename);
        return data.openFile(filename);
      },
      SKIP_write_to_file: function (fd, str) {
        let jsStr = wasmStringToJS(data.exports, str);
        if (jsStr == "") return;
        data.files[fd]!.push(jsStr);
        data.changed_files[fd] = fd;
        if (data.execOnChange[fd] !== undefined) {
          data.execOnChange[fd]!(data.files[fd]!.join(""));
          data.files[fd] = [];
        }
      },
      SKIP_glock: function () {},
      SKIP_gunlock: function () {},
    };
  }

  private runAddRoot(rootName: string, funId: number, arg: any): void {
    this.args = [];
    this.stdin = "";
    this.stdout = new Array();
    this.current_stdin = 0;
    this.exports.SKIP_add_root(
      encodeUTF8(this.exports, rootName),
      funId,
      encodeUTF8(this.exports, stringify(arg))
    );
  }

  private async copyPage(start: number, end: number): Promise<ArrayBuffer> {
    let memory = this.exports.memory.buffer;
    return memory.slice(start, end);
  }

  private async storePages(): Promise<boolean> {
    if(this.storeName == null) {
      return new Promise((resolve, _) => resolve(true));
    }
    let storeName = this.storeName;
    return new Promise((resolve, reject) => (async () => {
      if(this.db == null) {
        resolve(true);
      }

      let pages = this.dirtyPages;
      let db = this.db!;
      let tx = db.transaction(storeName, "readwrite");
      tx.onabort = (err) => {
        resolve(false);
      }
      tx.onerror = (err) => {
        console.log("Error sync db: " + err);
        resolve(false);
      }
      tx.oncomplete = () => {
        this.dirtyPages = [];
        this.dirtyPagesMap = [];
        resolve(true);
      }
      let copiedPages = new Array();
      for (let j = 0; j < pages.length; j++) {
        let page = pages[j]!;
        let start = page * this.pageSize;
        let end = page * this.pageSize + this.pageSize;
        let content = await this.copyPage(start, end);
        copiedPages.push({ pageid: page, content });
      }
      let store = tx.objectStore(storeName);
      for(let j = 0; j < copiedPages.length; j++) {
        store.put(copiedPages[j]!);
      }
    })());

  }

  async save() {
    while (true) {
      let dirtyPage = this.exports.sk_pop_dirty_page();
      if (dirtyPage == -1) break;
      if (dirtyPage >= this.nbrInitPages) {
        if (this.dirtyPagesMap[dirtyPage] != dirtyPage) {
          this.dirtyPagesMap[dirtyPage] = dirtyPage;
          this.dirtyPages.push(dirtyPage);
        }
      }
    }

    for (let dirtyPage = 0; dirtyPage < this.nbrInitPages; dirtyPage++) {
      if (this.dirtyPagesMap[dirtyPage] != dirtyPage) {
        this.dirtyPagesMap[dirtyPage] = dirtyPage;
        this.dirtyPages.push(dirtyPage);
      }
    }
    await this.storePages();
  }

  runLocal(new_args: Array<string>, new_stdin: string): string {
    console.assert(this.nbrInitPages >= 0);
    this.args = new_args;
    this.stdin = new_stdin;
    this.stdout = new Array();
    this.current_stdin = 0;

    this.exports.skip_main();

    return this.stdout.join("");
  }

  runSubscribeRoots(reboot: boolean): void {
    this.roots = new Map();
    let fileName = "/subscriptions/jsroots";
    this.watchFile(fileName, (text) => {
      let changed = new Map();
      let updates = text.split("\n").filter((x) => x.indexOf("\t") != -1);
      for (const update of updates) {
        if (update.substring(0, 1) !== "0") continue;
        let json = JSON.parse(update.substring(update.indexOf("\t") + 1));
        this.roots.delete(json.name);
        changed.set(json.name, true);
      }
      for (const update of updates) {
        if (update.substring(0, 1) === "0") continue;
        let json = JSON.parse(update.substring(update.indexOf("\t") + 1));
        this.roots.set(json.name, json.value);
        changed.set(json.name, true);
      }
      for (const f of this.onRootChangeFuns) {
        for (const name of changed.keys()) {
          f(name);
        }
      }
    });
    this.subscriptionCount++;
    if(reboot) {
      this.runLocal(
        ["subscribe", "jsroots", "--format=json", "--updates", fileName],
        ""
      );
    }
  }

  watermark(table: string): bigint {
    return BigInt(this.runLocal(["watermark", table], ""));
  }

  cmd(new_args: Array<string>, new_stdin: string): string {
    return this.runLocal(new_args, new_stdin);
  }

  registerFun<T1, T2>(f: (obj: T1) => T2): SKDBCallable<T1, T2> {
    let funId = this.externalFuns.length;
    this.externalFuns.push(f);
    return new SKDBCallable(funId);
  }

  trackedCall<T1, T2>(callable: SKDBCallable<T1, T2>, arg: T1): T2 {
    let result = this.exports.SKIP_tracked_call(
      callable.getId(),
      encodeUTF8(this.exports, stringify(arg))
    );
    return JSON.parse(wasmStringToJS(this.exports, result));
  }

  trackedQuery(request: string, start?: number, end?: number): any {
    if (start === undefined) start = 0;
    if (end === undefined) end = -1;
    let result = this.exports.SKIP_tracked_query(
      encodeUTF8(this.exports, request),
      start,
      end
    );
    return wasmStringToJS(this.exports, result)
      .split("\n")
      .filter((x) => x != "")
      .map((x) => JSON.parse(x));
  }

  onRootChange(f: (rootName: string) => void): void {
    this.onRootChangeFuns.push(f);
  }

  addRoot<T1, T2>(
    rootName: string,
    callable: SKDBCallable<T1, T2>,
    arg: T1
  ): void {
    this.runAddRoot(rootName, callable.getId(), arg);
  }

  removeRoot(rootName: string): void {
    this.exports.SKIP_remove_root(encodeUTF8(this.exports, rootName));
  }

  getRoot(rootName: string): any {
    return this.roots.get(rootName);
  }

  subscribe(viewName: string, f: (change: string) => void): void {
    const fileName = "/subscriptions/sub" + this.subscriptionCount;
    this.watchFile(fileName, f);
    this.subscriptionCount++;
    this.runLocal(
      ["subscribe", viewName, "--format=csv", "--updates", fileName],
      ""
    );
  }

  sqlRaw(stdin: string): string {
    return this.runLocal([], stdin);
  }

  sql(stdin: string): Array<any> | string {
    this.stdout_objects = new Array();
    let stdout = this.runLocal(["--format=js"], stdin);
    if(stdout == "") {
      let result = this.stdout_objects;
      return result;
    }
    return stdout;
  }

  tableExists(tableName: string): boolean {
    return this.runLocal(["dump-table", tableName], "").trim() != "";
  }

  tableSchema(tableName: string): string {
    return this.runLocal(["dump-table", tableName], "");
  }

  viewExists(viewName: string): boolean {
    return this.runLocal(["dump-view", viewName], "") != "";
  }

  viewSchema(viewName: string): string {
    return this.runLocal(["dump-view", viewName], "");
  }

  schema(): string {
    const tables = this.runLocal(["dump-tables"], "");
    const views = this.runLocal(["dump-views"], "");
    return tables + views;
  }

  insert(tableName: string, values: Array<any>): void {
    values = values.map((x) => {
      if (typeof x == "string") {
        if (x == undefined) {
          return "NULL";
        }
        return "'" + x + "'";
      }
      return x;
    });
    let stdin =
      "insert into " + tableName + " values (" + values.join(", ") + ");";
    this.runLocal([], stdin);
  }
}

/* ***************************************************************************/
/* Orchestration protocol. */
/* ***************************************************************************/

type ProtoQuery = {
  type: "query";
  query: string;
  format: "json"|"raw"|"csv";
}

type ProtoQuerySchema = {
  type: "schema";
  name?: string;
  scope: "all"|"table"|"view";
}

type ProtoRequestTail = {
  type: "tail";
  table: string;
  since: bigint;
}

type ProtoPushPromise = {
  type: "pushPromise";
  table: string;
}

type ProtoRequestCreateDb = {
  type: "createDatabase";
  name: string;
}

type ProtoRequestCreateUser = {
  type: "createUser";
}

type ProtoResponseCreds = {
  type: "credentials";
  accessKey: String;
  privateKey: Uint8Array;
}

type ProtoCtrlMsg = ProtoQuery | ProtoQuerySchema | ProtoRequestCreateDb |
 ProtoRequestTail | ProtoPushPromise | ProtoRequestCreateUser

type ProtoData = {
  type: "data";
  payload: ArrayBuffer;
}

type ProtoResponse = ProtoResponseCreds | ProtoData

type ProtoMsg = ProtoCtrlMsg | ProtoResponse

function encodeProtoMsg(msg: ProtoMsg): ArrayBuffer {
  switch (msg.type) {
      case "query": {
        const buf = new ArrayBuffer(6 + msg.query.length * 3);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        const textEncoder = new TextEncoder();
        const encodeResult = textEncoder.encodeInto(msg.query, uint8View.subarray(6));
        dataView.setUint8(0, 0x1);  // type
        const formatLookup = new Map([
          ["json", 0x0],
          ["raw", 0x1],
          ["csv", 0x2],
        ]);
        const format = formatLookup.get(msg.format);
        if (format === undefined) {
          throw new Error(`Cannot serialize format ${msg.format}`);
        }
        dataView.setUint8(1, format);
        dataView.setUint32(2, encodeResult.written || 0, false);
        return buf.slice(0, 6 + (encodeResult.written || 0));
      }
      case "schema": {
        const name = msg.name || "";
        const buf = new ArrayBuffer(4 + name.length * 3);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        const textEncoder = new TextEncoder();
        const encodeResult = textEncoder.encodeInto(name, uint8View.subarray(4));
        dataView.setUint8(0, 0x4);  // type
        const scopeLookup = new Map([
          ["all", 0x0],
          ["table", 0x1],
          ["view", 0x2],
        ]);
        const scope = scopeLookup.get(msg.scope);
        if (scope === undefined) {
          throw new Error(`Cannot serialize scope ${msg.scope}`);
        }
        dataView.setUint8(1, scope);
        dataView.setUint16(2, encodeResult.written || 0, false);
        return buf.slice(0, 4 + (encodeResult.written || 0));
      }
      case "tail": {
        const buf = new ArrayBuffer(14 + msg.table.length * 3);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        const textEncoder = new TextEncoder();
        const encodeResult = textEncoder.encodeInto(msg.table, uint8View.subarray(14));
        dataView.setUint8(0, 0x2);  // type
        dataView.setBigUint64(4, msg.since, false);
        dataView.setUint16(12, encodeResult.written || 0, false);
        return buf.slice(0, 14 + (encodeResult.written || 0));
      }
      case "pushPromise": {
        const buf = new ArrayBuffer(6 + msg.table.length * 3);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        const textEncoder = new TextEncoder();
        const encodeResult = textEncoder.encodeInto(msg.table, uint8View.subarray(6));
        dataView.setUint8(0, 0x3);  // type
        dataView.setUint16(4, encodeResult.written || 0, false);
        return buf.slice(0, 6 + (encodeResult.written || 0));
      }
      case "createDatabase": {
        const buf = new ArrayBuffer(3 + msg.name.length * 3);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        const textEncoder = new TextEncoder();
        const encodeResult = textEncoder.encodeInto(msg.name, uint8View.subarray(3));
        dataView.setUint8(0, 0x5);  // type
        dataView.setUint16(1, encodeResult.written || 0, false);
        return buf.slice(0, 3 + (encodeResult.written || 0));
      }
      case "createUser": {
        const buf = new ArrayBuffer(1);
        const dataView = new DataView(buf);
        dataView.setUint8(0, 0x6);  // type
        return buf;
      }
      case "credentials": {
        throw new Error("Encoding credentials unsupported");
      }
      case "data": {
        const buf = new ArrayBuffer(2 + msg.payload.byteLength);
        const uint8View = new Uint8Array(buf);
        const dataView = new DataView(buf);
        dataView.setUint8(0, 0x0);  // type
        // fin flag always set - we currently assume that JS doesn't stream chunks
        dataView.setUint8(1, 0x1);
        uint8View.set(new Uint8Array(msg.payload), 2);
        return buf;
      }
  }
}

class ProtoMsgDecoder {
  private bufs: Array<Uint8Array> = [];
  private msgs: Array<ProtoMsg|null> = [];

  private popBufs(): ArrayBuffer {
    if (this.bufs.length == 1) {
      // avoid copying for the common case of single buffer
      const buf = this.bufs.pop();
      if (!buf) {
        throw new Error("invariant violation");
      }
      return buf;
    }

    let bytes = 0;
    for (const buf of this.bufs) {
      bytes += buf.byteLength;
    }

    const acc = new ArrayBuffer(bytes);
    const uint8View = new Uint8Array(acc);
    let offset = 0;
    for (const buf of this.bufs) {
      uint8View.set(buf, offset);
      offset += buf.byteLength;
    }

    this.bufs = [];
    return acc;
  }

  // like a stack machine, you push bytes in until the machine pops
  // them all, turns them in to a msg, and pushes this on to the stack
  // to be popped. push returns true when a new msg is ready to be
  // popped.
  push(msg: ArrayBuffer): boolean {
    const dv = new DataView(msg);
    const type = dv.getUint8(0);
    switch (type) {
      // credentials response
      case 0x80: {
        const accessKeyFixedWidthBytes = new Uint8Array(msg, 1, 20);
        // access key is a fixed-width but potentially zero-terminated string
        const zeroIndex = accessKeyFixedWidthBytes.findIndex((x) => x == 0);
        const accessKeyBytes = accessKeyFixedWidthBytes.slice(0, zeroIndex < 0 ? 20 : zeroIndex)
        const decoder = new TextDecoder();
        const accessKey = decoder.decode(accessKeyBytes)
        this.msgs.push({
          type: "credentials",
          accessKey: accessKey,
          privateKey: new Uint8Array(msg, 21, 32),
        })
        return true;
      }
      // streaming data
      case 0x0: {
        const flags = dv.getUint8(1);
        const fin = (flags & 0x01) === 1;
        this.bufs.push(new Uint8Array(msg, 2))
        if (fin) {
          this.msgs.push({
            type: "data",
            payload: this.popBufs(),
          });
          return true;
        }
        return false;
      }
      default: {
        this.msgs.push(null);
        return true;
      }
    }
  }

  // returns the last message assembled and clears it off the stack.
  // null represents a message from a future schema that we don't understand
  pop(): ProtoMsg | null {
    const msg = this.msgs.pop();
    if (msg === undefined) {
      throw new Error("Popping an empty stack.");
    }
    return msg;
  }
}

/* ***************************************************************************/
/* Stream MUX protocol */
/* ***************************************************************************/

enum MuxedSocketState {
  IDLE,
  AUTH_SENT,
  CLOSING,                      // can receive data
  CLOSEWAIT,                    // can send data
  CLOSED,
}

type MuxAuth = {
  type: "auth";
}
type MuxGoaway = {
  type: "goaway";
  lastStream: number;
  errorCode: number;
  msg: string;
}
type MuxStreamData = {
  type: "data";
  stream: number;
  payload: ArrayBuffer;
}
type MuxStreamClose = {
  type: "close";
  stream: number;
}
type MuxStreamReset = {
  type: "reset";
  stream: number;
  errorCode: number;
  msg: string;
}
type MuxMessage = MuxAuth | MuxGoaway | MuxStreamData | MuxStreamClose | MuxStreamReset;

interface Creds {
  accessKey: string,
  privateKey: CryptoKey,
  deviceUuid: string,
}

export class MuxedSocket {
  // constants
  private socket: WebSocket;

  // state
  private state: MuxedSocketState = MuxedSocketState.IDLE
  // streams in the open or closing state
  private activeStreams: Map<number, Stream> = new Map()
  private serverStreamWatermark = 0
  private nextStream = 1

  // user facing interface /////////////////////////////////////////////////////

  onStream?: (stream: Stream) => void;
  onClose?: () => void;
  onError?: (errorCode: number, msg: string) => void;

  private constructor(socket: WebSocket) {
    // pre-condition: socket is open
    this.socket = socket;
  }

  openStream(): Stream {
    switch (this.state) {
    case MuxedSocketState.AUTH_SENT: {
      const streamId = this.nextStream;
      this.nextStream = this.nextStream + 2; // client uses odd-numbered streams
      const stream = new Stream(this, streamId);
      this.activeStreams.set(streamId, stream);
      return stream;
    }
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSEWAIT:
      throw new Error("Connection closing");
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSED:
      throw new Error("Connection not established");
    }
  }

  closeSocket(): void {
    switch (this.state) {
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.IDLE:
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
      this.socket.close();
      break;
    case MuxedSocketState.CLOSEWAIT: {
      for (const stream of this.activeStreams.values()) {
        stream.close();
      }
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
      this.socket.close();
      break;
    }
    case MuxedSocketState.AUTH_SENT: {
      for (const stream of this.activeStreams.values()) {
        stream.close();
      }
      this.state = MuxedSocketState.CLOSING;
      this.socket.close();
      break;
    }
    }
  }

  errorSocket(errorCode: number, msg: string): void {
    switch (this.state) {
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSED:
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
      break;
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSEWAIT: {
      for (const stream of this.activeStreams.values()) {
        stream.error(errorCode, msg);
      }
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
      const lastStream = Math.max(this.nextStream - 2, this.serverStreamWatermark);
      this.socket.send(this.encodeGoawayMsg(lastStream, errorCode, msg));
      this.socket.close(1002);
      break;
    }
    }
  }

  static async connect(uri: string, creds: Creds): Promise<MuxedSocket> {
    const auth = await MuxedSocket.encodeAuthMsg(creds);
    return new Promise((resolve, reject) => {
      const socket = new WebSocket(uri)
      socket.binaryType = "arraybuffer";
      socket.onclose = (_event) => reject(new Error("Socket closed before open"));
      socket.onerror = (event) => reject(event);
      socket.onmessage = (_event) => reject(new Error("Socket messaged before open"));
      socket.onopen = (_event) => {
        const muxSocket = new MuxedSocket(socket)
        socket.onclose = (event) => muxSocket.onSocketClose(event)
        socket.onerror = (_event) => muxSocket.onSocketError(0, "socket error")
        socket.onmessage = (event) => muxSocket.onSocketMessage(event)
        resolve(muxSocket)
        muxSocket.sendAuth(auth)
      };
    });
  }

  // interface used by Stream //////////////////////////////////////////////////

  streamClose(stream: number, nowClosed: boolean): void {
    switch (this.state) {
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSEWAIT: {
      this.socket.send(this.encodeStreamCloseMsg(stream));
      if (nowClosed) {
        this.activeStreams.delete(stream);
      }
      break;
    }
    }
  }

  streamError(stream: number, errorCode: number, msg: string): void {
    switch (this.state) {
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSEWAIT:
      this.socket.send(this.encodeStreamResetMsg(stream, errorCode, msg));
      this.activeStreams.delete(stream);
      break;
    }
  }

  streamSend(stream: number, data: ArrayBuffer): void {
    switch (this.state) {
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSEWAIT:
      this.socket.send(this.encodeStreamDataMsg(stream, data));
    }
  }

  // private ///////////////////////////////////////////////////////////////////

  private onSocketClose(_event: CloseEvent): void {
    switch (this.state) {
    case MuxedSocketState.CLOSEWAIT:
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.IDLE:
    case MuxedSocketState.AUTH_SENT:
      for (const stream of this.activeStreams.values()) {
        stream.onStreamClose();
      }
      if (this.onClose) {
        this.onClose();
      }
      this.state = MuxedSocketState.CLOSEWAIT;
      break;
    case MuxedSocketState.CLOSING:
      for (const stream of this.activeStreams.values()) {
        stream.onStreamClose();
      }
      if (this.onClose) {
        this.onClose();
      }
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
      break;
    }
  }

  private onSocketError(errorCode: number, msg: string): void {
    switch (this.state) {
    case MuxedSocketState.CLOSED:
      break;
    case MuxedSocketState.IDLE:
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSING:
    case MuxedSocketState.CLOSEWAIT:
      for (const stream of this.activeStreams.values()) {
        stream.onStreamError(0, msg);
      }
      if (this.onError) {
        this.onError(errorCode, msg);
      }
      this.activeStreams.clear()
      this.state = MuxedSocketState.CLOSED;
    }
  }

  private onSocketMessage(event: MessageEvent<any>): void {
    switch (this.state) {
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSING:
      if (!(event.data instanceof ArrayBuffer)) {
        throw new Error("Received unexpected text data");
      }
      const msg = this.decode(event.data);
      if (msg === null) {
        // for robustness we ignore messages we don't understand
        return;
      }
      switch (msg.type) {
      case "auth":
        throw new Error("Unexepected auth message from server");
      case "goaway":
        this.onSocketError(msg.errorCode, msg.msg);
        break;
      case "data": {
        let stream = this.activeStreams.get(msg.stream);

        if (stream == undefined && this.state == MuxedSocketState.CLOSING) {
          // we don't accept new streams while closing
          break;
        }

        // TODO: is the watermark condition necesary? we don't want to
        // reuse streams but this doesn't allow for creating them with
        // non-deterministic scheduling. if we don't accept them,
        // should probably send a stream reset
        if (stream === undefined && msg.stream % 2 == 0 && msg.stream > this.serverStreamWatermark) {
          // new server-initiated stream
          this.serverStreamWatermark = msg.stream;
          stream = new Stream(this, msg.stream);
          this.activeStreams.set(msg.stream, stream);
          if (this.onStream) {
            this.onStream(stream);
          }
        }
        stream?.onStreamData(msg.payload);
        break;
      }
      case "close":
        const closed = this.activeStreams.get(msg.stream)?.onStreamClose();
        if (closed) {
          this.activeStreams.delete(msg.stream);
        }
        break;
      case "reset":
        this.activeStreams.get(msg.stream)?.onStreamError(msg.errorCode, msg.msg);
        this.activeStreams.delete(msg.stream);
        break;
      default:
        throw new Error("Unexpected message type");
      }
      break;
    case MuxedSocketState.IDLE:
    case MuxedSocketState.CLOSEWAIT:
    case MuxedSocketState.CLOSED:
      break;
    }
  }

  private sendAuth(msg: ArrayBuffer): void {
    switch (this.state) {
    case MuxedSocketState.IDLE:
      this.state = MuxedSocketState.AUTH_SENT;
      this.socket.send(msg);
      break;
    case MuxedSocketState.AUTH_SENT:
    case MuxedSocketState.CLOSING:
      throw new Error("Tried to auth an established connection");
    case MuxedSocketState.CLOSEWAIT:
    case MuxedSocketState.CLOSED:
      break;
    }
  }

  private static async encodeAuthMsg(creds: Creds): Promise<ArrayBuffer> {
    const enc = new TextEncoder();
    const buf = new ArrayBuffer(96);
    const uint8View = new Uint8Array(buf);
    const dataView = new DataView(buf);

    const now = (new Date()).toISOString()
    const nonce = uint8View.subarray(28, 36);
    crypto.getRandomValues(nonce)
    const b64nonce = btoa(String.fromCharCode(...nonce));
    const bytesToSign = enc.encode("auth" + creds.accessKey + now + b64nonce)
    const sig = await crypto.subtle.sign(
      "HMAC",
      creds.privateKey,
      bytesToSign
    )

    dataView.setUint8(0, 0x0);  // type
    dataView.setUint8(4, 0x0);  // version
    const encodeAccessKey = enc.encodeInto(creds.accessKey, uint8View.subarray(8));
    if (!encodeAccessKey.written || encodeAccessKey.written > 20) {
      throw new Error("Unable to encode access key")
    }
    uint8View.set(new Uint8Array(sig), 36);
    const encodeIsoDate = enc.encodeInto(now, uint8View.subarray(69));
    switch (encodeIsoDate.written) {
    case 24:
      return buf.slice(0, 93);
    case 27:
      dataView.setUint8(68, 0x1);
      return buf;
    default:
      throw new Error("Unexpected ISO date length");
    }
  }

  private encodeGoawayMsg(lastStream: number, errorCode: number, msg: string): ArrayBuffer {
    if (lastStream >= 2**24) {
      throw new Error("Cannot encode lastStream");
    }
    const buf = new ArrayBuffer(16 + msg.length * 3); // avoid resizing
    const uint8View = new Uint8Array(buf);
    const textEncoder = new TextEncoder();
    const encodeResult = textEncoder.encodeInto(msg, uint8View.subarray(16));
    const dataView = new DataView(buf);
    dataView.setUint8(0, 0x1);  // type
    dataView.setUint32(4, lastStream, false);
    dataView.setUint32(8, errorCode, false);
    dataView.setUint32(12, encodeResult.written || 0, false);
    return buf.slice(0, 16 + (encodeResult.written || 0));
  }

  private encodeStreamDataMsg(stream: number, data: ArrayBuffer): ArrayBuffer {
    if (stream >= 2**24) {
      throw new Error("Cannot encode stream");
    }
    const buf = new ArrayBuffer(4 + data.byteLength);
    const dataView = new DataView(buf);
    const uint8View = new Uint8Array(buf);
    dataView.setUint32(0, 0x2 << 24 | stream, false);  // type and stream id
    uint8View.set(new Uint8Array(data), 4);
    return buf;
  }

  private encodeStreamCloseMsg(stream: number): ArrayBuffer {
    if (stream >= 2**24) {
      throw new Error("Cannot encode stream");
    }
    const buf = new ArrayBuffer(4);
    const dataView = new DataView(buf);
    dataView.setUint32(0, 0x3 << 24 | stream, false);  // type and stream id
    return buf;
  }

  private encodeStreamResetMsg(stream: number, errorCode: number, msg: string): ArrayBuffer {
    if (stream >= 2**24) {
      throw new Error("Cannot encode stream");
    }
    const textEncoder = new TextEncoder();
    const buf = new ArrayBuffer(12 + msg.length * 3); // avoid resizing
    const uint8View = new Uint8Array(buf);
    const dataView = new DataView(buf);

    dataView.setUint32(0, 0x4 << 24 | stream, false);  // type and stream id
    dataView.setUint32(4, errorCode, false);
    const encodeResult = textEncoder.encodeInto(msg, uint8View.subarray(12));
    dataView.setUint32(8, encodeResult.written || 0, false);
    return buf.slice(0, 12 + (encodeResult.written || 0));
  }

  private decode(msg: ArrayBuffer): MuxMessage|null {
    const dv = new DataView(msg);
    const typeAndStream = dv.getUint32(0, false);
    const type = typeAndStream >>> 24;
    const stream = typeAndStream & 0xFFFFFF;
    switch (type) {
    case 0: {                   // auth
      return {
        type: "auth",
      };
    }
    case 1: {                   // goaway
      const msgLength = dv.getUint32(12, false);
      const errorMsgBytes = new Uint8Array(msg, 16, msgLength);
      const td = new TextDecoder();
      const errorMsg = td.decode(errorMsgBytes);
      return {
        type: "goaway",
        lastStream: dv.getUint32(4, false),
        errorCode: dv.getUint32(8, false),
        msg: errorMsg,
      };
    }
    case 2: {                   // stream data
      return {
        type: "data",
        stream: stream,
        payload: msg.slice(4),
      };
    }
    case 3: {                   // stream close
      return {
        type: "close",
        stream: stream,
      };
    }
    case 4: {                   // stream reset
      const msgLength = dv.getUint32(8, false);
      const errorMsgBytes = new Uint8Array(msg, 12, msgLength);
      const td = new TextDecoder();
      const errorMsg = td.decode(errorMsgBytes);
      return {
        type: "reset",
        stream: stream,
        errorCode: dv.getUint32(4, false),
        msg: errorMsg,
      };
    }
    default:
      return null;
    }
  }
}

enum StreamState {
  OPEN,
  CLOSING,
  CLOSEWAIT,
  CLOSED,
}

class Stream {
  // constants
  private socket: MuxedSocket
  private streamId: number

  // state
  private state: StreamState = StreamState.OPEN;

  // user facing interface ///////////////////////////////////

  onClose?: () => void
  onError?: (errorCode: number, msg: string) => void
  onData?: (data: ArrayBuffer) => void

  close(): void {
    switch (this.state) {
    case StreamState.CLOSING:
    case StreamState.CLOSED:
      break;
    case StreamState.OPEN:
      this.state = StreamState.CLOSING;
      this.socket.streamClose(this.streamId, false);
      break;
    case StreamState.CLOSEWAIT:
      this.state = StreamState.CLOSED;
      this.socket.streamClose(this.streamId, true);
      break;
    }
  }

  error(errorCode: number, msg: string): void {
    switch (this.state) {
    case StreamState.CLOSED:
    case StreamState.CLOSING:
      this.state = StreamState.CLOSED;
      break;
    case StreamState.OPEN:
    case StreamState.CLOSEWAIT:
      this.state = StreamState.CLOSED;
      this.socket.streamError(this.streamId, errorCode, msg);
      break;
    }
  }

  send(data: ArrayBuffer): void {
    switch (this.state) {
    case StreamState.CLOSING:
    case StreamState.CLOSED:
      break;
    case StreamState.OPEN:
    case StreamState.CLOSEWAIT:
      this.socket.streamSend(this.streamId, data);
    }
  }

  // interface used by MuxedSocket ///////////////////////////

  constructor(socket: MuxedSocket, streamId: number) {
    this.socket = socket
    this.streamId = streamId
  }

  onStreamClose(): boolean {
    switch (this.state) {
    case StreamState.CLOSED:
      return true;
    case StreamState.CLOSEWAIT:
      return false;
    case StreamState.OPEN:
      this.state = StreamState.CLOSEWAIT;
      if (this.onClose) {
        this.onClose();
      }
      return false;
    case StreamState.CLOSING:
      this.state = StreamState.CLOSED;
      if (this.onClose) {
        this.onClose();
      }
      return true;
    }
  }

  onStreamError(errorCode: number, msg: string): void {
    switch (this.state) {
    case StreamState.CLOSED:
      break;
    case StreamState.CLOSING:
    case StreamState.OPEN:
    case StreamState.CLOSEWAIT:
      this.state = StreamState.CLOSED;
      if (this.onError) {
        this.onError(errorCode, msg);
      }
    }
  }

  onStreamData(data: ArrayBuffer): void {
    switch (this.state) {
    case StreamState.CLOSED:
    case StreamState.CLOSEWAIT:
      break;
    case StreamState.CLOSING:
    case StreamState.OPEN:
      if (this.onData) {
        this.onData(data);
      }
    }
  }
}

/* ***************************************************************************/
/* Server-side database. */
/* ***************************************************************************/

class SKDBServer {
  private client: SKDB;
  private connection: MuxedSocket;
  private creds: Creds;
  private replicationUid: string = "";
  private mirroredTables: Set<string> = new Set()

  private constructor(
    client: SKDB,
    connection: MuxedSocket,
    creds: Creds,
  ) {
    this.client = client;
    this.connection = connection;
    this.creds = creds;
  }

  static async connect(
    client: SKDB,
    endpoint: string,
    db: string,
    creds: Creds,
  ): Promise<SKDBServer> {
    const uri = SKDBServer.getDbSocketUri(endpoint, db);
    const conn = await MuxedSocket.connect(uri, creds);
    const server = new SKDBServer(client, conn, creds);
    server.replicationUid = client.runLocal(["uid"], "").trim();
    return server
  }

  close(): void {
    this.connection.closeSocket();
  }

  private static getDbSocketUri(endpoint: string, db: string) {
    return `${endpoint}/dbs/${db}/connection`;
  }

  private strictCastData(response: ProtoMsg|null): ProtoData {
    if (response === null) {
      throw new Error(`Unexpected response: ${response}`);
    }
    if (response.type === "data") {
      return response;
    }
    throw new Error(`Unexpected response: ${response}`);
  }

  private async makeRequest(request: ProtoCtrlMsg): Promise<ProtoResponse|null> {
    const stream = this.connection.openStream();
    const decoder = new ProtoMsgDecoder();
    return new Promise((resolve, reject) => {
      stream.onData = function (data) {
        decoder.push(data);
      };
      stream.onClose = () => {
        const msg = decoder.pop();
        if (msg === null || msg.type !== "credentials" && msg.type !== "data") {
          resolve(null);
          return;
        }
        resolve(msg);
      };
      stream.onError = (_code, msg) => reject(msg);
      stream.send(encodeProtoMsg(request));
      stream.close();
    });
  }

  private async establishServerTail(tableName: string): Promise<void> {
    const stream = this.connection.openStream();
    const client = this.client;
    const decoder = new ProtoMsgDecoder();

    const objThis = this;
    let resolved = false;

    return new Promise((resolve, reject) => {
      stream.onError = (code, msg) => {
        // will go away when we re-introduce the resiliency abstraction
        console.error("server tail", tableName, "stream errored", code, msg);
        if (!resolved) {
          resolved = true;
          reject(msg);
        }
      }

      stream.onClose = () => {
        // will go away when we re-introduce the resiliency abstraction
        console.error("server tail", tableName, "stream closed");
      }

      stream.onData = (data) => {
        if (decoder.push(data)) {
          const msg = decoder.pop();
          const txtPayload = decodeUTF8(objThis.strictCastData(msg).payload);
          client.runLocal(["write-csv", tableName, "--source", objThis.replicationUid], txtPayload + '\n');
          if (!resolved) {
            resolved = true;
            resolve();
          }
        }
      }

      stream.send(encodeProtoMsg({
        type: "tail",
        table: tableName,
        since: objThis.client.watermark(tableName),
      }));
    });
  }

  private establishLocalTail(tableName: string): void {
    const stream = this.connection.openStream();
    const client = this.client;
    const decoder = new ProtoMsgDecoder();

    stream.onError = (code, msg) => {
      // will go away when we re-introduce the resiliency abstraction
      console.error("local tail", tableName, "stream errored", code, msg);
    }

    stream.onClose = () => {
      // will go away when we re-introduce the resiliency abstraction
      console.error("local tail", tableName, "stream closed");
    }

    stream.onData = (data) => {
      if (decoder.push(data)) {
        const msg = decoder.pop();
        const txtPayload = decodeUTF8(this.strictCastData(msg).payload);
        // we only expect acks back in the form of checkpoints.
        // let's store these as a watermark against the table.
        client.runLocal(["write-csv", metadataTable(tableName)], txtPayload + '\n');
      }
    }

    const request: ProtoPushPromise = {
       type: "pushPromise",
       table: tableName,
    };

    stream.send(encodeProtoMsg(request));

    let fileName = tableName + "_" + this.creds.accessKey;

    client.watchFile(fileName, change => {
      if (change == "") {
        return;
      }
      stream.send(encodeProtoMsg({
        type: "data",
        payload: encodeUTF8Str(change),
      }));
    });

    const _session = client.runLocal(
      [
        "subscribe", tableName, "--connect", "--format=csv",
        "--updates", fileName, "--ignore-source", this.replicationUid
      ],
      ""
    ).trim();
  }

  async mirrorTable(tableName: string): Promise<void> {
    if (this.mirroredTables.has(tableName)) {
      return;
    }
    this.mirroredTables.add(tableName);

    // TODO: just assumes that if it exists the schema is the same
    if (!this.client.tableExists(tableName)) {
      let createTable = await this.tableSchema(tableName);

      this.client.runLocal([], createTable);
      this.client.runLocal([],
        `CREATE TABLE ${metadataTable(tableName)} (
         key STRING PRIMARY KEY,
         value STRING
       )`);
    }

    this.establishLocalTail(tableName);
    return this.establishServerTail(tableName);
  }

  // TODO: this currently just replicates the schema locally assuming
  // you have all source tables setup. is this what we want? we should
  // error if this doesn't succeed. it might be easier for the user
  // just to create this themselves - no need for mirroring. or we
  // could mirror down a read-only table and have the server keep it
  // in sync?
  async mirrorView(viewName: string): Promise<void> {
    if (!this.client.viewExists(viewName)) {
      let createRemoteTable = await this.viewSchema(viewName);
      this.client.runLocal([], createRemoteTable);
    }
  }

  async sqlRaw(stdin: string): Promise<string> {
    let result = await this.makeRequest({
      type: "query",
      query: stdin,
      format: "raw",
    });

    return decodeUTF8(this.strictCastData(result).payload);
  }

  async sql(stdin: string): Promise<any[]> {
    let result = await this.makeRequest({
      type: "query",
      query: stdin,
      format: "json",
    });
    return decodeUTF8(this.strictCastData(result).payload)
      .split("\n")
      .filter((x) => x != "")
      .map((x) => JSON.parse(x));
  }

  async tableSchema(tableName: string): Promise<string> {
    const resp = await this.makeRequest({
      type: "schema",
      name: tableName,
      scope: "table",
    });
    return decodeUTF8(this.strictCastData(resp).payload)
  }

  async viewSchema(viewName: string): Promise<string> {
    const resp = await this.makeRequest({
      type: "schema",
      name: viewName,
      scope: "view",
    });
    return decodeUTF8(this.strictCastData(resp).payload)
  }

  async schema(): Promise<string> {
    const resp = await this.makeRequest({
      type: "schema",
      scope: "all",
    });
    return decodeUTF8(this.strictCastData(resp).payload)
  }

  async createDatabase(dbName: string): Promise<ProtoResponseCreds> {
    let result = await this.makeRequest({
      type: "createDatabase",
      name: dbName,
    });
    if (result === null || result.type !== "credentials") {
      throw new Error("Unexpected response.");
    }
    return result;
  }

  async createUser(): Promise<ProtoResponseCreds> {
    let result = await this.makeRequest({
      type: "createUser",
    });
    if (result === null || result.type !== "credentials") {
      throw new Error("Unexpected response.");
    }
    return result;
  }
}
