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
        let i;
        let cursor = 0;
        for (i = 0; i < memorySize / pageSize; i++) {
          const content = memory.slice(cursor, cursor + pageSize);
          store.put({ pageid: i, content: content });
          cursor = cursor + pageSize;
        }
      } else {
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
          for (let pageIdx = 0; pageIdx < pages.length; pageIdx++) {
            let page = pages[pageIdx];
            const pageid = page.pageid;
            if (pageid < 0) continue;
            let pageBuffer = new Uint32Array(page.content);
            const start = pageid * (pageSize / 4);
            for (let i = 0; i < pageBuffer.length; i++) {
              memory32[start + i] = pageBuffer[i];
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
  since: number;
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
  let socket = new WebSocket(uri);

  return new Promise((resolve, _reject) => {
    socket.onmessage = function (event) {
      const data = event.data;
      const reader = new FileReader();
      if(typeof data === "string") {
        onmessage(data)
      } else {
        reader.addEventListener(
          "load",
          () => {
            // we know it will be a string because we called readAsText
            onmessage((reader.result || "") as string);
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

export class SKDB {
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
  private roots: Map<string, number> = new Map();
  private pageSize: number = -1;
  private db: IDBDatabase | null = null;
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
    let pageBitSize = 20;
    client.pageSize = 1 << pageBitSize;
    let wasmModule = await fetch(new URL("out32.wasm", import.meta.url));
    let wasmBuffer = await wasmModule.arrayBuffer();
    let typedArray = new Uint8Array(wasmBuffer);
    let env = client.makeWasmImports();
    let wasm = await WebAssembly.instantiate(typedArray, { env: env });
    let exports = wasm.instance.exports as unknown as WasmExports;
    client.exports = exports;
    exports.SKIP_skfs_init();
    exports.SKIP_initializeSkip();
    exports.SKIP_skfs_end_of_init();
    client.nbrInitPages = exports.SKIP_get_persistent_size() / client.pageSize + 1;
    let version = exports.SKIP_get_version();
    let dbName = "SKDBIndexedDB";
    if(reboot) {
      await clearSKDBStore(dbName, storeName);
    }
    client.db = await makeSKDBStore(
      dbName,
      storeName,
      version,
      exports.memory.buffer,
      exports.SKIP_get_persistent_size(),
      reboot,
      client.pageSize
    );

    client.exports.SKIP_init_jsroots();
    client.runSubscribeRoots(reboot);

    return client;
  }

  setMirroredTable(tableName: string, sessionID: number): void {
    this.mirroredTables[tableName] = sessionID;
  }

  attach(f: (change: string) => void): void {
    this.execOnChange[this.fileDescrNbr] = f;
  }

  async connect(
    db: string,
    user: string,
    password: string,
    endpoint?: string,
  ): Promise<number> {
    if (!endpoint) {
      if (typeof window === 'undefined') {
        throw new Error("No endpoint passed to connect and no window object to infer from.");
      }
      const loc = window.location;
      const scheme = loc.protocol === "https:" ? "wss://" : "ws://"
      endpoint = `${scheme}${loc.host}`
    }

    let result = await makeRequest(SKDBServer.getDbSocketUri(endpoint, db), {
      request: "query",
      query: "select id();",
    });
    const [sessionID] = result.split("|").map((x) => parseInt(x));
    let serverID = this.servers.length;
    let server = new SKDBServer(
      this,
      serverID,
      endpoint,
      db,
      user,
      password,
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
      let db = this.db;
      if(db == null) {
        return;
      }
      let tx = db.transaction(this.storeName, "readwrite");
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

  runSubscribeRoots(reboot: boolean): void {
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
    if(reboot) {
      this.runLocal(
        ["subscribe", "jsroots", "--format=json", "--updates", fileName],
        ""
      );
    }
  }

  watermark(table: string): number {
    return parseInt(this.runLocal(["watermark", table], ""));
  }

  connectReadTable(
    uri: string,
    user: string,
    password: string,
    tableName: string,
    suffix: string,
  ): Promise<void> {
    let objThis = this;

    const request: ProtoTail = {
      request: "tail",
      user: user,
      password: password,
      table: tableName,
      since: objThis.watermark(tableName + suffix),
    };

    return new Promise((resolve, _reject) => {
      const socket = new WebSocket(uri);
      const failureThresholdMs = 60000;
      let failureTimeout: number|undefined = undefined;

      const reconnect = (_event: Event) => {
        socket.onmessage = null;
        socket.onclose = null;
        socket.onerror = null;
        socket.close();
        clearTimeout(failureTimeout);

        const backoffMs = 500 + Math.random() * 1000;
        setTimeout(() => {
          objThis.connectReadTable(uri, user, password, tableName, suffix);
        }, backoffMs)
      };

      socket.onmessage = function (event) {
        clearTimeout(failureTimeout);

        const deliver = (data: ProtoData) => {
          let msg = data.data;
          if (msg != "") {
            objThis.runLocal(["write-csv", tableName + suffix], msg + '\n');
          }
          failureTimeout = setTimeout(reconnect, failureThresholdMs);
        };

        const data = event.data;

        if(typeof data === "string") {
          deliver(JSON.parse(data))
        } else {
          const reader = new FileReader();
          reader.addEventListener(
            "load",
            () => {
              let msg = JSON.parse((reader.result || "") as string);
              // we know it will be a string because we called readAsText
              deliver(msg);
            },
            false
          );
          reader.readAsText(data);
        }
      };

      socket.onclose = reconnect;
      socket.onerror = reconnect;

      socket.onopen = function (_event) {
        socket.send(JSON.stringify(request));
        failureTimeout = setTimeout(reconnect, failureThresholdMs);
        resolve();
      };
    });
  }

  async connectWriteTable(
    uri: string,
    user: string,
    password: string,
    tableName: string,
    suffix: string,
    session: string | undefined = undefined,
  ): Promise<void> {
    let objThis = this;

    const request: ProtoWrite = {
       request: "write",
       user: user,
       password: password,
       table: tableName,
    };

    return new Promise((resolve, _reject) => {
      let sessionId = session;
      const socket = new WebSocket(uri);
      const failureThresholdMs = 60000;
      let failureTimeout: number|undefined = undefined;

      const reconnect = (_event: Event) => {
        socket.onmessage = null;
        socket.onclose = null;
        socket.onerror = null;
        socket.close();
        clearTimeout(failureTimeout);

        const backoffMs = 500 + Math.random() * 1000;
        setTimeout(() => {
          objThis.connectWriteTable(uri, user, password, tableName, suffix, sessionId);
        }, backoffMs)
      };

      socket.onmessage = function (event) {
        clearTimeout(failureTimeout);

        const deliver = (data: ProtoData) => {
          let msg = data.data;
          if (msg != "") {
            // we only expect acks back in the form of checkpoints.
            // let's store these as a watermark against the table.
            objThis.runLocal(["write-csv", tableName + suffix], msg + '\n');
          }
        };

        const data = event.data;

        if(typeof data === "string") {
          deliver(JSON.parse(data))
        } else {
          const reader = new FileReader();
          reader.addEventListener(
            "load",
            () => {
              let msg = JSON.parse((reader.result || "") as string);
              // we know it will be a string because we called readAsText
              deliver(msg);
            },
            false
          );
          reader.readAsText(data);
        }
      };

      socket.onclose = reconnect;
      socket.onerror = reconnect;

      const write = (data: string) => {
        socket.send(JSON.stringify({
          request: "pipe",
          data: data,
        }));
        // we expect an ack within a reasonable amount of time
        failureTimeout = setTimeout(reconnect, failureThresholdMs);
      };

      socket.onopen = function (_event) {
        socket.send(JSON.stringify(request));

        if (!session) {
          let fileName = tableName + "_" + user;
          objThis.attach(change => {
            write(change);
          });
          sessionId = objThis.runLocal(
            [
              "subscribe", tableName + suffix, "--connect", "--format=csv", "--updates", fileName
            ],
            ""
          ).trim();
        } else {
          const diff = objThis.runLocal(
            [
              "diff", "--format=csv",
              "--since", objThis.watermark(tableName + suffix).toString(),
              session,
            ], "");

          write(diff);
        }

        resolve();
      };
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
      ["subscribe", viewName, "--format=csv", "--updates", fileName],
      ""
    );
  }

  sqlRaw(stdin: string): string {
    return this.runLocal([], stdin);
  }

  sql(stdin: string): Array<any> {
    return this.runLocal(["--format=json"], stdin)
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
  private sessionID: number;

  constructor(
    client: SKDB,
    serverID: number,
    endpoint: string,
    db: string,
    user: string,
    password: string,
    sessionID: number
  ) {
    this.client = client;
    this.serverID = serverID;
    this.uri = SKDBServer.getDbSocketUri(endpoint, db);
    this.db = db;
    this.user = user;
    this.password = password;
    this.sessionID = sessionID;
  }

  static getDbSocketUri(endpoint: string, db: string) {
    return `${endpoint}/dbs/${db}/connection`;
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

    await this.client.connectWriteTable(
      this.uri,
      this.user,
      this.password,
      tableName,
      localSuffix
    );

    await this.client.connectReadTable(
      this.uri,
      this.user,
      this.password,
      tableName,
      remoteSuffix,
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
    suffix = suffix || "";
    let createRemoteTable = await makeRequest(this.uri, {
      request: "dumpTable",
      table: tableName,
      suffix: suffix,
    });
    this.client.runLocal([], createRemoteTable);

    await this.client.connectReadTable(
      this.uri,
      this.user,
      this.password,
      tableName,
      suffix,
    );

    this.client.setMirroredTable(tableName, this.sessionID);
  }
}
