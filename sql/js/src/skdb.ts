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
/* Protocol schema. */
/* ***************************************************************************/

type ProtoAuth = {
  request: "auth";
  accessKey: string;
  date: string;
  nonce: string;
  signature: string;
  deviceUuid: string,
}

type ProtoQuery = {
  request: "query";
  query: string;
  format?: "json"|"raw";
}

type ProtoTail = {
  request: "tail";
  table: string;
  since: number;
}

type ProtoSchemaQuery = {
  request: "schema";
  table?: string;
  view?: string;
  suffix?: string;
}

type ProtoWrite = {
  request: "write";
  table: string;
}

type ProtoCreateDb = {
  request: "createDatabase";
  name: string;
}

type ProtoCreateUser = {
  request: "createUser";
}

type ProtoData = {
  request: "pipe";
  data: string;
}

type ProtoError = {
  request: "error";
  code: string;
  msg: string;
}

type ProtoCredentials = {
  request: "credentials";
  accessKey: String;
  privateKey: String;
}

type ProtoRequest = ProtoQuery | ProtoSchemaQuery | ProtoCreateDb | ProtoTail | ProtoWrite | ProtoCreateUser

type ProtoResponse = ProtoData | ProtoError | ProtoCredentials

type ProtoMessage = ProtoRequest | ProtoResponse

interface Creds {
  accessKey: string,
  privateKey: CryptoKey,
  deviceUuid: string,
}

async function createAuthMsg(creds: Creds): Promise<ProtoAuth> {
  const enc = new TextEncoder();
  const reqType = "auth"
  const now = (new Date()).toISOString()
  const nonce = new Uint8Array(8);
  crypto.getRandomValues(nonce)
  const b64nonce = btoa(String.fromCharCode(...nonce));
  const bytesToSign = enc.encode(reqType + creds.accessKey + now + b64nonce)
  const sig = await crypto.subtle.sign(
    "HMAC",
    creds.privateKey,
    bytesToSign
  )
  return {
    request: reqType,
    accessKey: creds.accessKey,
    date: now,
    nonce: b64nonce,
    signature: btoa(String.fromCharCode(...new Uint8Array(sig))),
    deviceUuid: creds.deviceUuid,
  };
}

function metadataTable(tableName: string): string {
  return `skdb__${tableName}_sync_metadata`;
}

/* ***************************************************************************/
/* Resilient connection abstraction
/* ***************************************************************************/

class ResilientConnection {

  // connection params
  private uri: string;
  private creds: Creds;
  private failureThresholdMs = 60000;
  private onMessage: (data: ProtoData) => void;

  onReconnect?: () => void;

  // state
  private socket?: WebSocket;
  private failureTimeout?: number;
  private reconnectTimeout?: number;
  // key invariants:
  // 1. only one failure timeout in flight
  // 2. only one reconnect attempt in flight at any one time
  // 3. the socket is either connected and healthy, or we're actively
  //    attempting a reconnect

  private constructor(
    uri: string,
    creds: Creds,
    onMessage: (data: ProtoData) => void,
  ) {
    this.uri = uri;
    this.creds = creds;
    this.onMessage = onMessage;

    this.socket = undefined;
    this.failureTimeout = undefined;
    this.reconnectTimeout = undefined;
  }

  private setFailureTimeout(timeout?: number): void {
    clearTimeout(this.failureTimeout);
    this.failureTimeout = timeout;
  }

  private setReconnectTimeout(timeout?: number): void {
    clearTimeout(this.reconnectTimeout);
    this.reconnectTimeout = timeout;
  }

  private connectionHealthy(): void {
    this.setFailureTimeout(undefined);
  }

  private async connect(): Promise<WebSocket> {
    if (this.socket) {
      throw new Error("Connecting a connected socket")
    }

    const authMsg = await createAuthMsg(this.creds)
    const objThis = this;

    let opened = false;
    return new Promise((resolve, reject) => {
      const socket = new WebSocket(this.uri);

      socket.onclose = _event => {
        if (opened) {
          objThis.kickOffReconnect();
        } else {
          reject();
        }
      };
      socket.onerror = _event => {
        if (opened) {
          objThis.kickOffReconnect();
        } else {
          reject();
        }
      };

      socket.onmessage = function (event) {
        objThis.connectionHealthy();

        const deliver = (data: ProtoResponse) => {
          if (data.request !== "pipe") {
            console.error("Unexpected message received", data);
            objThis.kickOffReconnect();
            return;
          }

          objThis.onMessage(data);
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

      socket.onopen = function (_event) {
        socket.send(JSON.stringify(authMsg));
        opened = true;
        resolve(socket);
      };
    });
  }

  private kickOffReconnect(): void {
    if (this.reconnectTimeout) {
      // debounce. e.g. socket onclose and onerror can both be called
      return
    }

    if (this.socket) {
      this.socket.onmessage = null;
      this.socket.onclose = null;
      this.socket.onerror = null;
      this.socket.onopen = null;
      this.socket.close();
    }

    this.socket = undefined;
    this.setFailureTimeout(undefined);

    const backoffMs = 500 + Math.random() * 1000;
    const objThis = this;
    const reconnectTimeout = setTimeout(() => {
      objThis.connect().then(socket => {
        objThis.socket = socket;
        objThis.setReconnectTimeout(undefined)
        if (objThis.onReconnect) {
          objThis.onReconnect();
        }
      }).catch(() => {
        objThis.setReconnectTimeout(undefined)
        objThis.kickOffReconnect()
      });
    }, backoffMs);

    this.setReconnectTimeout(reconnectTimeout);

    return;
  }

  static async connect(
    uri: string, creds: Creds,
    onMessage: (data: ProtoData) => void
  ): Promise<ResilientConnection> {

    const conn = new ResilientConnection(uri, creds, onMessage);

    const socket = await conn.connect();
    conn.socket = socket;

    return conn;
  }

  expectingData(): void {
    if (this.failureTimeout) {
      // already expecting a response
      return;
    }

    if (!this.socket) {
      // can't receive data. we're re-establishing anyway
      return;
    }

    const objThis = this;
    const timeout = setTimeout(() => objThis.kickOffReconnect(), this.failureThresholdMs);
    this.setFailureTimeout(timeout);
  }

  write(data: ProtoMessage): void {
    if (!this.socket) {
      // black hole the data. we're reconnecting and will call
      // onReconnect that should address the gap
      return;
    }
    this.socket.send(JSON.stringify(data));
  }
}

/* ***************************************************************************/
/* Stream MUX protocol
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

  constructor(socket: WebSocket) {
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
    let c = bytes[i++]!;
    if (c > 127) {
      if (c > 191 && c < 224) {
        if (i >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 2-byte sequence");
        c = ((c & 31) << 6) | (bytes[i++]! & 63);
      } else if (c > 223 && c < 240) {
        if (i + 1 >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 3-byte sequence");
        c = ((c & 15) << 12) | ((bytes[i++]! & 63) << 6) | (bytes[i++]! & 63);
      } else if (c > 239 && c < 248) {
        if (i + 2 >= bytes.length)
          throw new Error("UTF-8 decode: incomplete 4-byte sequence");
        c =
          ((c & 7) << 18) |
          ((bytes[i++]! & 63) << 12) |
          ((bytes[i++]! & 63) << 6) |
          (bytes[i++]! & 63);
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
  private stdout_objects: Array<any> = new Array();
  private onRootChangeFuns: Array<(rootName: string) => void> = new Array();
  private externalFuns: Array<(any) => any> = [];
  private fileDescrs: Map<string, number> = new Map();
  private fileDescrNbr: number = 2;
  private files: Array<Array<String>> = new Array();
  private changed_files: Array<number> = new Array();
  private execOnChange: Array<(change: string) => void> = new Array();
  private servers: Array<SKDBServer> = [];
  private lineBuffer: Array<number> = [];
  private storeName: string | null;
  private nbrInitPages: number = -1;
  private roots: Map<string, number> = new Map();
  private pageSize: number = -1;
  private db: IDBDatabase | null = null;
  private dirtyPagesMap: Array<number> = [];
  private dirtyPages: Array<number> = [];
  private mirroredTables: Map<string, number> = new Map();
  // @ts-expect-error
  private exports: WasmExports;
  private localToServerSyncConnections: Map<string, ResilientConnection> = new Map();
  private serverToLocalSyncConnections: Map<string, ResilientConnection> = new Map();
  private replication_uid: string = "";
  private client_uuid: string = "";

  private constructor(storeName: string | null) {
    this.storeName = storeName;
  }

  static async clear(dbName: string, storeName: string): Promise<void> {
    await clearSKDBStore(dbName, storeName);
  }

  static async create(
    dbName: string | null = null
  ): Promise<SKDB> {
    let storeName: string | null = null;
    if(dbName != null) {
      storeName = "SKDBStore";
    }
    let client = new SKDB(storeName);
    let pageBitSize = 20;
    client.pageSize = 1 << pageBitSize;
    // NOTE the `new URL` is required for bundlers like Vite to find the wasm file
    let wasmModule = await fetch(new URL("../skdb.wasm", import.meta.url));
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

    client.replication_uid = client.runLocal(["uid"], "").trim();
    client.client_uuid = crypto.randomUUID();

    return client;
  }

  setMirroredTable(tableName: string, sessionID: number): void {
    this.mirroredTables[tableName] = sessionID;
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
  ): Promise<number> {
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
      deviceUuid: this.client_uuid,
    };

    let result = await this.makeRequest(SKDBServer.getDbSocketUri(endpoint, db), creds, {
      request: "query",
      query: "select id();",
    });
    if (result.request !== "pipe") {
      throw new Error("Unexpected response.");
    }
    const [sessionID] = result.data.split("|").map((x) => parseInt(x));
    let serverID = this.servers.length;
    let server = new SKDBServer(
      this,
      serverID,
      endpoint,
      db,
      creds,
      sessionID!
    );
    this.servers.push(server);
    return serverID;
  }

  server(serverID?: number): SKDBServer {
    if (serverID === undefined) {
      serverID = this.servers.length - 1;
    }
    return this.servers[serverID]!;
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

  watermark(table: string): number {
    return parseInt(this.runLocal(["watermark", table], ""));
  }

  async makeRequest(uri: string, creds: Creds, request: ProtoRequest): Promise<ProtoResponse> {
    let socket = new WebSocket(uri);

    const authMsg = await createAuthMsg(creds)

    return new Promise((resolve, reject) => {
      socket.onmessage = function (event) {
        const data = event.data;
        resolve(JSON.parse(data));
        socket.close();
      };
      socket.onclose = () => {
        reject();
      };
      socket.onerror = (err) => reject(err);
      socket.onopen = function (_event) {
        socket.send(JSON.stringify(authMsg));
        socket.send(JSON.stringify(request));
      };
    });
  }

  async connectReadTable(
    uri: string,
    creds: Creds,
    tableName: string,
  ): Promise<void> {
    let objThis = this;

    const conn = this.serverToLocalSyncConnections[tableName];
    if (conn) {
      throw new Error("Trying to connect an already connected table");
    }

    const newConn = await ResilientConnection.connect(uri, creds, (data: ProtoData) => {
      let msg = data.data;
      objThis.runLocal(["write-csv", tableName, "--source", objThis.replication_uid], msg + '\n');
      newConn.expectingData()
    });
    this.localToServerSyncConnections[tableName] = newConn;

    newConn.write({
      request: "tail",
      table: tableName,
      since: objThis.watermark(tableName),
    })
    newConn.expectingData();

    newConn.onReconnect = () => {
      newConn.write({
        request: "tail",
        table: tableName,
        since: objThis.watermark(tableName),
      });
      newConn.expectingData();
    }
  }

  async connectWriteTable(
    uri: string,
    creds: Creds,
    tableName: string,
  ): Promise<void> {
    let objThis = this;

    const conn = this.localToServerSyncConnections[tableName];

    if (conn) {
      throw new Error("Trying to connect an already connected table");
    }

    const newConn = await ResilientConnection.connect(uri, creds, (data: ProtoData) => {
      let msg = data.data;
      // we only expect acks back in the form of checkpoints.
      // let's store these as a watermark against the table.
      objThis.runLocal(["write-csv", metadataTable(tableName)], msg + '\n');
    });
    this.localToServerSyncConnections[tableName] = newConn;

    const request: ProtoWrite = {
       request: "write",
       table: tableName,
    };
    newConn.write(request)
    newConn.expectingData()

    let fileName = tableName + "_" + creds.accessKey;
    objThis.watchFile(fileName, change => {
      if (change == "") {
        return;
      }
      newConn.write({
        request: "pipe",
        data: change,
      });
      newConn.expectingData();
    });
    const session = objThis.runLocal(
      [
        "subscribe", tableName, "--connect", "--format=csv",
        "--updates", fileName, "--ignore-source", objThis.replication_uid
      ],
      ""
    ).trim();

    newConn.onReconnect = () => {
      newConn.write(request);

      const diff = objThis.runLocal(
        [
          "diff", "--format=csv",
          "--since", objThis.watermark(metadataTable(tableName)).toString(),
          session,
        ], "");

      if (diff == "") {
        return;
      }

      newConn.write({
        request: "pipe",
        data: diff,
      });

      newConn.expectingData();
    }
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
    let stdout = this.runLocal(["--format=js"], stdin);
    if(stdout == "") {
      let result = this.stdout_objects;
      this.stdout_objects = new Array();
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

  private getID(): number {
    return parseInt(this.runLocal(["--gensym"], ""));
  }
}

class SKDBServer {
  private client: SKDB;
  private serverID: number;
  private uri: string;
  private creds: Creds;
  private sessionID: number;

  constructor(
    client: SKDB,
    serverID: number,
    endpoint: string,
    db: string,
    creds: Creds,
    sessionID: number
  ) {
    this.client = client;
    this.serverID = serverID;
    this.uri = SKDBServer.getDbSocketUri(endpoint, db);
    this.creds = creds;
    this.sessionID = sessionID;
  }

  static getDbSocketUri(endpoint: string, db: string) {
    return `${endpoint}/dbs/${db}/connection`;
  }

  private castData(response: ProtoResponse): ProtoData {
    if (response.request === "pipe") {
      return response;
    }
    if (response.request == "error") {
      console.error(response.msg);
    } else {
      console.error("Unexpected response", response);
    }
    throw new Error(`Unexpected response: ${response}`);
  }

  async sqlRaw(stdin: string): Promise<string> {
    let result = await this.client.makeRequest(this.uri, this.creds, {
      request: "query",
      query: stdin,
      format: "raw",
    });

    return this.castData(result).data;
  }

  async sql(stdin: string): Promise<any[]> {
    let result = await this.client.makeRequest(this.uri, this.creds, {
      request: "query",
      query: stdin,
      format: "json",
    });
    return this.castData(result)
      .data
      .split("\n")
      .filter((x) => x != "")
      .map((x) => JSON.parse(x));
  }

  async tableSchema(tableName: string, renameSuffix: string = ""): Promise<string> {
    const resp = await this.client.makeRequest(this.uri, this.creds, {
      request: "schema",
      table: tableName,
      suffix: renameSuffix,
    });
    return this.castData(resp).data
  }

  async viewSchema(viewName: string, renameSuffix: string = ""): Promise<string> {
    const resp = await this.client.makeRequest(this.uri, this.creds, {
      request: "schema",
      view: viewName,
      suffix: renameSuffix,
    });
    return this.castData(resp).data
  }

  async schema(): Promise<string> {
    const resp = await this.client.makeRequest(this.uri, this.creds, {
      request: "schema",
    });
    return this.castData(resp).data
  }

  async mirrorTable(tableName: string): Promise<void> {
    // TODO: just assumes that if it exists the schema is the same
    if (!this.client.tableExists(tableName)) {
      let createTable = await this.tableSchema(tableName, "");

      this.client.runLocal([], createTable);
      this.client.runLocal([],
        `CREATE TABLE ${metadataTable(tableName)} (
         key STRING PRIMARY KEY,
         value STRING
       )`);
    }

    await this.client.connectWriteTable(
      this.uri,
      this.creds,
      tableName,
    );

    await this.client.connectReadTable(
      this.uri,
      this.creds,
      tableName,
    );

    this.client.setMirroredTable(tableName, this.sessionID);
  }

  async mirrorView(viewName: string, suffix?: string): Promise<void> {
    if (!this.client.viewExists(viewName + suffix)) {
      suffix = suffix || "";
      let createRemoteTable = await this.viewSchema(viewName, suffix);
      this.client.runLocal([], createRemoteTable);
    }

    await this.client.connectReadTable(
      this.uri,
      this.creds,
      viewName + suffix,
    );

    this.client.setMirroredTable(viewName, this.sessionID);
  }

  async createDatabase(dbName: string): Promise<ProtoCredentials> {
    let result = await this.client.makeRequest(this.uri, this.creds, {
      request: "createDatabase",
      name: dbName,
    });
    if (result.request !== "credentials") {
      throw new Error("Unexpected response.");
    }
    return result;
  }

  async createUser(): Promise<ProtoCredentials> {
    let result = await this.client.makeRequest(this.uri, this.creds, {
      request: "createUser",
    });
    if (result.request !== "credentials") {
      throw new Error("Unexpected response.");
    }
    return result;
  }
}
