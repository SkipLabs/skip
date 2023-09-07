import { float, int, Environment, Wrk, Shared } from "#std/sk_types";
import { MemFS, MemSys } from "#std/sk_mem_utils";

class WrkImpl implements Wrk {
  worker: Worker;

  constructor(filename: string | URL, options?: WorkerOptions) {
    this.worker = new Worker(filename, options);
  }

  postMessage = (message: any) => {
    this.worker.postMessage(message);
  }

  onMessage = (listener: (value: any) => void) => {
    this.worker.onmessage = listener;
  }
}

class Env implements Environment {
  shared: Map<string, Shared>;
  fileSystem: MemFS;
  system: MemSys;
  timestamp: () => float;
  canvas: () => HTMLCanvasElement;
  clipboard: () => Clipboard;
  decodeUTF8: (utf8: ArrayBuffer) => string;
  encodeUTF8: (str: string) => Uint8Array;
  storage: () => Storage;
  onException: () => void;
  base64Decode: (base64: string) => Uint8Array;
  createSocket: (uri: string) => WebSocket;
  createWorker: (filename: string | URL, options?: WorkerOptions) => Wrk;
  crypto: () => Crypto;
  environment: Array<string>;

  throwRuntime = (code: int) => {
    this.onException();
    if (code != 0) {
      throw new Error("Error with code: " + code);
    }
  }
  fs() {
    return this.fileSystem;
  }
  sys() {
    return this.system;
  }
  name() {
    return "browser";
  }

  constructor(environment?: Array<string>) {
    this.shared = new Map<string, Shared>();
    this.fileSystem = new MemFS();
    this.system = new MemSys();
    this.environment = environment ?? [];
    let global = (typeof window == "undefined") ? self : window;
    this.timestamp = () => global.performance.now();
    var decoder = new TextDecoder('utf8');
    this.decodeUTF8 = (utf8: ArrayBuffer) => decoder.decode(utf8);
    var encoder = new TextEncoder(); // always utf-8
    this.encodeUTF8 = (str: string) => encoder.encode(str);
    this.base64Decode = (base64: string) => Uint8Array.from(atob(base64), c => c.charCodeAt(0));;
    this.storage = () => localStorage;
    this.onException = () => { };
    this.createSocket = (uri: string) => new WebSocket(uri);
    this.createWorker = (filename: string | URL, options?: WorkerOptions) => new WrkImpl(filename, options);
    this.crypto = () => crypto;
  };
}

export function environment(environment?: Array<string>) {
  return new Env(environment)
}