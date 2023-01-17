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

let output = function (str) {
  // @ts-expect-error
  process.stdout.write(str);
};

let error = function (str) {
  // @ts-expect-error
  process.stderr.write(str + "\n");
};

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

function makeSKDBStore(
  dbName: string,
  storeName: string,
  version: number,
  memory: ArrayBuffer,
  memorySize: number,
  init: boolean,
  pageSize: number
): Promise<IDBDatabase> {
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

      if (init) {
        // First, let's empty the store.
        store.getAllKeys().onsuccess = (event) => {
          let pageidx;
          // @ts-expect-error
          for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
            // @ts-expect-error
            store.delete(event.target.result[pageidx]);
          }
        };

        let i;
        let cursor = 0;
        for (i = 0; i < memorySize / pageSize; i++) {
          const content = memory.slice(cursor, cursor + pageSize);
          store.put({ pageid: i, content: content });
          cursor = cursor + pageSize;
        }
      } else {
        store.getAll().onsuccess = (event) => {
          let pageidx;
          // @ts-expect-error
          for (pageidx = 0; pageidx < event.target.result.length; pageidx++) {
            // @ts-expect-error
            let page = event.target.result[pageidx];
            const pageid = page.pageid;
            if (pageid < 0) continue;
            page = new Uint32Array(page.content);
            const start = pageid * (pageSize / 4);
            for (let i = 0; i < page.length; i++) {
              memory32[start + i] = page[i];
            }
          }
        };
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
/* Primitives to connect to websockets. */
/* ***************************************************************************/

// protocol schema

type ProtoQuery = {
  request: "query";
  query: string;
  format?: "json";
}

type ProtoTail = {
  request: "tail";
  table: string;
  user: string;
  password: string;
}

type ProtoDumpTable = {
  request: "dumpTable";
  table: string;
  suffix: string;
}

type ProtoWrite = {
  request: "write";
  table: string;
  user: string;
  password: string;
}

// control plane
type ProtoRequest = ProtoQuery | ProtoTail | ProtoDumpTable | ProtoWrite;

// data plane
type ProtoData = {
  request: "pipe";
  data: string;
}

type ProtoMessage = ProtoRequest | ProtoData;

function makeWebSocket(
  uri: string,
  onopen: () => void,
  onmessage: (msg: string ) => void,
  onclose: (e: Event) => void,
  onerror: (e: Event) => void
): Promise<(data: ProtoMessage) => void> {
  let socket: WebSocket;
  if (typeof window === "undefined") {
    // @ts-expect-error
    let W3CWebSocket = require("websocket").w3cwebsocket;

    socket = new W3CWebSocket(uri);
  } else {
    socket = new WebSocket(uri);
  }

  return new Promise((resolve, _reject) => {
    socket.onmessage = function (event) {
      const data = event.data;
      const reader = new FileReader();
      if (typeof window === "undefined") {
        let string = new TextDecoder().decode(data);
        onmessage(string);
      } else if(typeof data === "string") {
        onmessage(data)
      } else {
        reader.addEventListener(
          "load",
          () => {
            // we know it will be a string because we called readAsText
            onmessage((reader.result ?? "") as string);
          },
          false
        );
        reader.readAsText(data);
      }
    };
    socket.onclose = onclose;
    socket.onerror = onerror;
    socket.onopen = function (_event) {
      onopen();
      resolve(function (data: object) {
        socket.send(JSON.stringify(data));
      });
    };
  });
}

async function makeRequest(uri: string, request: ProtoRequest): Promise<string> {
  let data = "";
  return new Promise((resolve, reject) => {
    makeWebSocket(
      uri,
      function () {},
      function (msg) {
        data += msg;
      },
      function (_) {
        resolve((JSON.parse(data) as ProtoData).data);
      },
      function (err) {
        reject(err);
      }
    ).then((write) => {
      write(request);
    });
  });
}

// socket that delivers
async function makeOutputStream(
  uri: string,
  request: ProtoRequest,
  onopen: () => void,
  onmessage: (msg: ProtoData) => void
): Promise<void> {
  return makeWebSocket(
    uri,
    onopen,
    function (msg) {
      // TODO: probably should have some schema check, but I hope we
      // don't keep json around long enough to warrant writing it.
      onmessage(JSON.parse(msg));
    },
    function (_) {
      console.log("Error connection lost");
    },
    function (_err) {
      console.log("Error connection lost");
    }
  ).then((write) => {
    write(request);
  });
}

// socket that can be written to
async function makeInputStream(
  uri: string,
  request: ProtoRequest
): Promise<(data: ProtoData) => void> {
  let write = await makeWebSocket(
    uri,
    function () {},
    function (change) {
      console.log("Error writing: " + change);
    },
    function (exn) {
      console.log("Error connection lost: " + request);
    },
    function (err) {
      console.log("Error connection lost");
    }
  );

  write(request);
  return write;
}

/* ***************************************************************************/
/* A few primitives to encode/decode utf8. */
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

function decodeUTF8(bytes: Uint8Array): string {
  let i = 0,
    s = "";
  while (i < bytes.length) {
    let c = bytes[i++];
    if (c > 127) {
      if (c > 191 && c < 224) {
        if (i >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 2-byte sequence");
        c = ((c & 31) << 6) | (bytes[i++] & 63);
      } else if (c > 223 && c < 240) {
        if (i + 1 >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 3-byte sequence");
        c = ((c & 15) << 12) | ((bytes[i++] & 63) << 6) | (bytes[i++] & 63);
      } else if (c > 239 && c < 248) {
        if (i + 2 >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 4-byte sequence");
        c =
          ((c & 7) << 18) |
          ((bytes[i++] & 63) << 12) |
          ((bytes[i++] & 63) << 6) |
          (bytes[i++] & 63);
      } else
        throw new Error(
          "UTF-8 decode: unknown multibyte start 0x" +
            c.toString(16) +
            " at index " +
            (i - 1)
        );
    }
    if (c <= 0xffff) s += String.fromCharCode(c);
    else if (c <= 0x10ffff) {
      c -= 0x10000;
      s += String.fromCharCode((c >> 10) | 0xd800);
      s += String.fromCharCode((c & 0x3ff) | 0xdc00);
    } else
      throw new Error(
        "UTF-8 decode: code point 0x" + c.toString(16) + " exceeds UTF-16 reach"
      );
  }
  return s;
}

function wasmStringToJS(exports: WasmExports, wasmPointer: number): string {
  let data32 = new Uint32Array(exports.memory.buffer);
  let size = exports["SKIP_String_byteSize"](wasmPointer);
  let data = new Uint8Array(exports.memory.buffer);

  return decodeUTF8(data.slice(wasmPointer, wasmPointer + size));
}

/* ***************************************************************************/
/* A few primitives to encode/decode JSON. */
/* ***************************************************************************/

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
/* The function that creates the database. */
/* ***************************************************************************/

class SKDB {
  private subscriptionCount: number = 0;
  private args: Array<string> = [];
  private current_stdin: number = 0;
  private stdin: string = "";
  private stdout: Array<string> = new Array();
  private onRootChangeFuns: Array<(rootName: string) => void> = new Array();
  private externalFuns: Array<(any) => any> = [];
  private fileDescrs: Map<string, number> = new Map();
  private fileDescrNbr: number = 2;
  private files: Array<Array<String>> = new Array();
  private changed_files: Array<number> = new Array();
  private execOnChange: Array<(change: string) => void> = new Array();
  private servers: Array<SKDBServer> = [];
  private lineBuffer: Array<number> = [];
  private storeName: string;
  private nbrInitPages: number = -1;
  private rootsAreInitialized = false;
  private roots: Map<string, number> = new Map();
  private pageSize: number = -1;
  // @ts-expect-error
  private db: IDBDatabase;
  private dirtyPagesMap: Array<number> = [];
  private dirtyPages: Array<number> = [];
  private working: number = 0;
  private mirroredTables: Map<string, number> = new Map();
  // @ts-expect-error
  private exports: WasmExports;

  private constructor(storeName: string) {
    this.storeName = storeName;
  }

  static async create(reboot: boolean): Promise<SKDB> {
    let storeName = "SKDBStore";
    let client = new SKDB(storeName);
    if (typeof window === "undefined") {
      let pageBitSize = 16;
      client.pageSize = 1 << pageBitSize;
    } else {
      let pageBitSize = 20;
      client.pageSize = 1 << pageBitSize;
    }
    let source: ArrayBuffer;
    if (typeof window === "undefined") {
      // @ts-expect-error
      source = fs.readFileSync("build/out32.wasm");
    } else {
      let mod = await fetch("out32.wasm");
      source = await mod.arrayBuffer();
    }
    let typedArray = new Uint8Array(source);
    let env = client.makeWasmImports();
    let wasm = await WebAssembly.instantiate(typedArray, { env: env });
    let exports = wasm.instance.exports as unknown as WasmExports;
    client.exports = exports;
    exports.SKIP_skfs_init();
    exports.SKIP_initializeSkip();
    exports.SKIP_skfs_end_of_init();
    client.nbrInitPages = exports.SKIP_get_persistent_size() / client.pageSize + 1;
    let version = exports.SKIP_get_version();
    client.db = await makeSKDBStore(
      "SKDBIndexedDB",
      storeName,
      version,
      exports.memory.buffer,
      exports.SKIP_get_persistent_size(),
      reboot,
      client.pageSize
    );
    return client;
  }

  setMirroredTable(tableName: string, sessionID: number): void {
    this.mirroredTables[tableName] = sessionID;
  }

  attach(f: (change: string) => void): void {
    this.execOnChange[this.fileDescrNbr] = f;
  }

  async connect(
    uri: string,
    db: string,
    user: string,
    password: string
  ): Promise<number> {
    let result = await makeRequest(uri, {
      request: "query",
      query: "select id();",
    });
    const [sessionID] = result.split("|").map((x) => parseInt(x));
    let serverID = this.servers.length;
    let server = new SKDBServer(
      this,
      serverID,
      uri,
      db,
      user,
      password,
      999,                      // TODO: user id needs to be discovered by query
      sessionID
    );
    this.servers.push(server);
    return serverID;
  }

  server(serverID?: number): SKDBServer {
    if (serverID === undefined) {
      serverID = this.servers.length - 1;
    }
    return this.servers[serverID];
  }

  private makeWasmImports(): {} {
    let data = this;
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
      SKIP_print_char: function (c) {
        output(String.fromCharCode(c));
      },
      printf: function (ptr) {},
      SKIP_call_external_fun: function (funId, str) {
        return encodeUTF8(
          data.exports,
          stringify(
            data.externalFuns[funId](
              JSON.parse(wasmStringToJS(data.exports, str))
            )
          )
        );
      },
      SKIP_print_error: function (str) {
        error(wasmStringToJS(data.exports, str));
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
      SKIP_print_raw: function (str) {
        data.stdout.push(wasmStringToJS(data.exports, str));
      },
      SKIP_getArgc: function (i) {
        return data.args.length;
      },
      SKIP_getArgN: function (n) {
        return encodeUTF8(data.exports, data.args[n]);
      },
      SKIP_unix_open: function (wasmFilename) {
        let filename = wasmStringToJS(data.exports, wasmFilename);
        if (data.fileDescrs[filename] !== undefined) {
          return data.fileDescrs[filename];
        }
        let fd = data.fileDescrNbr;
        data.files[fd] = new Array();
        data.fileDescrs[filename] = fd;
        data.fileDescrNbr++;
        return fd;
      },
      SKIP_write_to_file: function (fd, str) {
        let jsStr = wasmStringToJS(data.exports, str);
        if (jsStr == "") return;
        data.files[fd].push(jsStr);
        data.changed_files[fd] = fd;
        if (data.execOnChange[fd] !== undefined) {
          data.execOnChange[fd](data.files[fd].join(""));
          data.files[fd] = [];
        }
      },
      SKIP_glock: function () {},
      SKIP_gunlock: function () {},
    };
  }

  private storePages(): void {
    if (this.working == 0 && this.dirtyPages.length != 0) {
      this.working++;
      let pages = this.dirtyPages;
      this.dirtyPages = [];
      this.dirtyPagesMap = [];
      let tx = this.db.transaction(this.storeName, "readwrite");
      let store = tx.objectStore(this.storeName);
      for (let j = 0; j < pages.length; j++) {
        let page = pages[j];
        let memory = this.exports.memory.buffer;
        let start = page * this.pageSize;
        let end = page * this.pageSize + this.pageSize;
        let content = memory.slice(start, end);
        store.put({ pageid: page, content });
      }
      tx.onerror = (err) => console.log("Error sync db: " + err);
      tx.oncomplete = () => {
        this.working--;
        this.storePages();
      };
    }
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

  runLocal(new_args: Array<string>, new_stdin: string): string {
    console.assert(this.nbrInitPages >= 0);
    this.args = new_args;
    this.stdin = new_stdin;
    this.stdout = new Array();
    this.current_stdin = 0;
    this.exports.skip_main();

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

    this.storePages();
    return this.stdout.join("");
  }

  runSubscribeRoots(): void {
    this.roots = new Map();
    this.attach((text) => {
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
    let fileName = "/subscriptions/jsroots";
    this.runLocal(
      ["--json", "--subscribe", "jsroots", "--updates", fileName],
      ""
    );
  }

  connectReadTable(
    uri: string,
    db: string,
    user: string,
    password: string,
    tableName: string,
    suffix: string
  ): Promise<number> {
    let objThis = this;
    return new Promise((resolve, _reject) => {
      makeOutputStream(
        uri,
        {
          request: "tail",
          user: user,
          password: password,
          table: tableName,
        },
        function () {
          resolve(0);
        },
        function (data: ProtoData) {
          let msg = data.data;
          if (msg != "") {
            objThis.runLocal(["--write-csv", tableName + suffix], msg + '\n');
          }
        }
      );
    });
  }

  async connectWriteTable(
    uri: string,
    user: string,
    password: string,
    tableName: string
  ): Promise<(txt: string) => void> {
    let write = await makeInputStream(uri, {
      request: "write",
      user: user,
      password: password,
      table: tableName,
    });
    return (data) => write({
      request: "pipe",
      data: data,
    });
  }

  getSessionID(tableName: string): number {
    return this.mirroredTables[tableName];
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
    if (!this.rootsAreInitialized) {
      this.rootsAreInitialized = true;
      this.exports.SKIP_init_jsroots();
      this.runSubscribeRoots();
    }
    this.runAddRoot(rootName, callable.getId(), arg);
  }

  removeRoot(rootName: string): void {
    this.exports.SKIP_remove_root(encodeUTF8(this.exports, rootName));
  }

  getRoot(rootName: string): any {
    return this.roots.get(rootName);
  }

  subscribe(viewName: string, f: (change: string) => void): void {
    this.attach(f);
    let fileName = "/subscriptions/sub" + this.subscriptionCount;
    this.subscriptionCount++;
    this.runLocal(
      ["--csv", "--subscribe", viewName, "--updates", fileName],
      ""
    );
  }

  sqlRaw(stdin: string): string {
    return this.runLocal([], stdin);
  }

  sql(stdin: string): Array<any> {
    return this.runLocal(["--json"], stdin)
      .split("\n")
      .filter((x) => x != "")
      .map((x) => JSON.parse(x));
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

  private getID(): number {
    return parseInt(this.runLocal(["--gensym"], ""));
  }
}

class SKDBServer {
  private client: SKDB;
  private serverID: number;
  private uri: string;
  private db: string;
  private user: string;
  private password: string;
  private userID: number;
  private sessionID: number;

  constructor(
    client: SKDB,
    serverID: number,
    uri: string,
    db: string,
    user: string,
    password: string,
    userID: number,
    sessionID: number
  ) {
    this.client = client;
    this.serverID = serverID;
    this.uri = uri;
    this.db = db;
    this.user = user;
    this.password = password;
    this.userID = userID;
    this.sessionID = sessionID;
  }

  async sqlRaw(passwd: string, stdin: string): Promise<string> {
    if (passwd != "admin1234") {
      console.log("Error: wrong admin password");
      return "";
    }
    let result = await makeRequest(this.uri, {
      request: "query",
      query: stdin,
    });
    return result;
  }

  async sql(passwd: string, stdin: string): Promise<any[]> {
    if (passwd != "admin1234") {
      console.log("Error: wrong admin password");
      return [];
    }
    let result = await makeRequest(this.uri, {
      request: "query",
      query: stdin,
      format: "json",
    });
    return result
      .split("\n")
      .filter((x) => x != "")
      .map((x) => JSON.parse(x));
  }

  async mirrorTable(tableName: string): Promise<void> {
    let remoteSuffix = "_remote_" + this.serverID;
    let createRemoteTable = await makeRequest(this.uri, {
      request: "dumpTable",
      table: tableName,
      suffix: remoteSuffix,
    });
    this.client.runLocal([], createRemoteTable);

    let localSuffix = "_local";
    let createLocalTable = await makeRequest(this.uri, {
      request: "dumpTable",
      table: tableName,
      suffix: localSuffix,
    });
    this.client.runLocal([], createLocalTable);

    let write = await this.client.connectWriteTable(
      this.uri,
      this.user,
      this.password,
      tableName
    );

    let fileName = tableName + "_" + this.user;
    this.client.attach(change => {
      write(change);
    });
    this.client.runLocal(
      ["--csv", "--connect", tableName + localSuffix, "--updates", fileName],
      ""
    );

    await this.client.connectReadTable(
      this.uri,
      this.db,
      this.user,
      this.password,
      tableName,
      remoteSuffix
    );

    this.client.setMirroredTable(tableName, this.sessionID);

    this.client.runLocal(
      [],
      "create virtual view " +
        tableName +
        " as select * from " +
        tableName +
        localSuffix +
        " union select * from " +
        tableName +
        remoteSuffix +
        ";"
    );
  }

  async mirrorView(tableName: string, suffix?: string): Promise<void> {
    suffix ??= ""
    let createRemoteTable = await makeRequest(this.uri, {
      request: "dumpTable",
      table: tableName,
      suffix: suffix,
    });
    this.client.runLocal([], createRemoteTable);

    await this.client.connectReadTable(
      this.uri,
      this.db,
      this.user,
      this.password,
      tableName,
      suffix
    );

    this.client.setMirroredTable(tableName, this.sessionID);
  }
}

async function initDB(): Promise<void> {
  const skdb = await SKDB.create(true);
  skdb.sql("create table t1 (a INTEGER);");

  let sizeCount = 20;

  for (let i = 0; i < sizeCount; i++) {
    skdb.insert("t1", [i]);
  }

  let sumLessThan = skdb.registerFun((i) => {
    let result = skdb.trackedQuery(
      `select sum(a) as count from t1 where a < ${i};`
    );
    return result[0].count;
  });

  let first10 = skdb.registerFun((_) => {
    return skdb.trackedQuery(`select * from t1;`);
  });

  skdb.addRoot("first10", first10, null);
  console.log(skdb.getRoot("first10"));

  let buildRoot = skdb.registerFun((i) => {
    return { rootNbr: i, rootCount: skdb.trackedCall(sumLessThan, i) };
  });

  for (let i = 0; i < sizeCount; i++) {
    skdb.addRoot(`root${i}`, buildRoot, i);
  }

  for (let i = 0; i < sizeCount; i++) {
    console.log("Root value: " + skdb.getRoot(`root${i}`));
  }

  skdb.onRootChange((x) =>
    console.log(`Root ${x} changed: ${skdb.getRoot(x)}`)
  );

  for (let i = 0; i < sizeCount; i++) {
    skdb.cmd(["--backtrace"], `delete from t1 where a = ${i};`);
  }

  for (let i = 0; i < sizeCount; i++) {
    console.log("Root value: " + skdb.getRoot(`root${i}`));
  }

  //  skdb.insert('t1', [2]);
  //  console.log(skdb.getRoot('root2'));
  //  console.log('done');
}

async function testDB(): Promise<void> {
  const skdb = await SKDB.create(true);
  console.log(skdb.sql("select count(*) from tracks;")[0]);

  let then = performance.now();

  for (let i = 30000; i < 40000; i++) {
    skdb.insert("tracks", [i, "track" + i, 0, 0, i, "album" + i]);
  }
  console.log(performance.now() - then);
  console.log(skdb.sql("select count(*) from tracks;")[0]);
}

// initDB();
//testDB();

async function promptDB() {
  let skdb = await SKDB.create(true);
//  let sessionID = await skdb.connect(
//    "ws://127.0.0.1:9999/skgw",
//    "test.db",
//    "julienv",
//    "passjulienv"
//  );
//  await skdb.server().mirrorView("all_users");
  //  await skdb.server().mirrorView("all_groups");
  //  await skdb.server().mirrorTable("user_profiles");
  //  await skdb.server().mirrorTable("whitelist_skiplabs_employees");
  //  await skdb.server().mirrorTable("posts");
  //  await skdb.server().mirrorTable("all_access");

  //  skdb.newServer("ws://127.0.0.1:3048", "test.db", "user6");
  //  await skdb.server().mirrorTable('posts');
  //  skdb.sql('create virtual view posts2 as select * from posts where localID % 2 = 0;');
  //  skdb.subscribe('posts2', function(str) {
  //    console.log('Recieved a change: ' + str);
  //  });
  //  skdb.sql("insert into posts_local values (4,44,74,6,'The second post!');")
  //  console.log(skdb.sql('select * from posts2;'));
  //  console.log(skdb.sql('select * from posts;'));
  //  console.log(skdb.sql('insert into posts_local values(1,38,74,6, NULL);'));
  //  console.log(skdb.sql('select * from posts;'));

  // @ts-expect-error
  var rl = readline.createInterface({
    // @ts-expect-error
    input: process.stdin,
    // @ts-expect-error
    output: process.stdout,
  });

  var recursiveAsyncReadLine = function () {
    rl.question("js> ", function (query) {
      if (query == "quit") return rl.close();
      try {
        console.log(eval(query));
      } catch (exn) {
        console.log("Error: " + exn);
      }
      recursiveAsyncReadLine();
    });
  };

  recursiveAsyncReadLine();
}
//initDB();
//promptDB();
