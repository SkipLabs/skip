import { float, int, Environment, Wrk, Shared } from "#std/sk_types";
import { MemFS, MemSys } from "#std/sk_mem_utils";

import * as fs from "fs";
import * as util from "util";
import * as perf_hooks from "perf_hooks";
import * as crypto from "crypto";
import { Worker } from "worker_threads";
import { WebSocket } from "ws";

class WrkImpl implements Wrk {
  worker: Worker;

  constructor(filename: string | URL, options?: WorkerOptions) {
    this.worker = new Worker(filename, options);
  }

  postMessage = (message: any) => {
    this.worker.postMessage(message);
  };

  onMessage = (listener: (value: any) => void) => {
    this.worker.on("message", listener);
  };
}

var decoder = new util.TextDecoder("utf8");
var encoder = new util.TextEncoder();

class Env implements Environment {
  shared: Map<string, Shared>;
  fileSystem: MemFS;
  disableWarnings: boolean = false;
  system: MemSys;
  timestamp: () => float;
  window: () => Window;
  canvas: () => HTMLCanvasElement;
  clipboard: () => Clipboard;
  decodeUTF8: (utf8: ArrayBuffer) => string;
  encodeUTF8: (str: string) => Uint8Array;
  storage: () => Storage;
  onException: () => void;
  base64Decode: (base64: string) => Uint8Array;
  update: () => void;
  environment: Array<string>;
  throwRuntime: (code: int) => void;
  createSocket: (uri: string) => WebSocket;
  createWorker: (filename: string | URL, options?: WorkerOptions) => Wrk;
  crypto: () => Crypto;
  fs() {
    return this.fileSystem;
  }
  sys() {
    return this.system;
  }
  name() {
    return "node";
  }
  fetch(path: string) {
    if (path.startsWith("file://")) {
      path = path.substring(7);
    }
    return new Promise<Uint8Array>(function (resolve, reject) {
      fs.readFile(path, {}, (err, data) => {
        err ? reject(err) : resolve(data);
      });
    });
  }
  rootPath() {
    let processPath = process.cwd();
    if (!processPath.startsWith("file://")) {
      processPath = "file://" + processPath;
    }
    return processPath;
  }

  constructor(environment?: Array<string>) {
    this.shared = new Map<string, Shared>();
    this.fileSystem = new MemFS();
    this.system = new MemSys();
    this.timestamp = () => perf_hooks.performance.now();
    this.decodeUTF8 = (v) => decoder.decode(v);
    this.encodeUTF8 = (v) => encoder.encode(v);
    this.environment = environment ?? [];
    this.base64Decode = (base64) => Buffer.from(base64, "base64");
    this.throwRuntime = (code: int) => {
      this.onException();
      process.exit(code);
    };
    this.createSocket = (uri: string) => new WebSocket(uri);
    this.createWorker = (filename: string | URL, options?: WorkerOptions) =>
      new WrkImpl(filename, options);
    this.crypto = () => crypto as Crypto;
  }
}

export function environment(environment?: Array<string>) {
  return new Env(environment);
}
