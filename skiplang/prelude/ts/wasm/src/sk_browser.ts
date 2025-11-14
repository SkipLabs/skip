import type { float, int } from "../skiplang-std/index.js";
import type { Environment, Shared } from "./sk_types.js";
import { MemFS, MemSys } from "./sk_mem_utils.js";

class Env implements Environment {
  shared: Map<string, Shared>;
  disableWarnings: boolean = false;
  fileSystem: MemFS;
  system: MemSys;
  timestamp: () => float;
  decodeUTF8: (utf8: ArrayBuffer | Uint8Array) => string;
  encodeUTF8: (str: string) => Uint8Array;
  storage: () => Storage;
  onException: () => void;
  base64Decode: (base64: string) => Uint8Array;
  base64Encode: (toEncode: string, url?: boolean) => string;
  crypto: () => Crypto;
  environment: string[];

  throwRuntime = (code: int) => {
    this.onException();
    if (code != 0) {
      throw new Error(`Error with code: ${code}`);
    }
  };

  fs() {
    return this.fileSystem;
  }

  sys() {
    return this.system;
  }

  name() {
    return "browser";
  }

  async fetch(url: URL | string) {
    let fUrl;
    if (url instanceof URL) {
      fUrl = url;
    } else {
      fUrl = new URL(url, import.meta.url);
    }
    return fetch(fUrl).then((res) => res.arrayBuffer());
  }

  constructor(environment?: string[]) {
    this.shared = new Map<string, Shared>();
    this.fileSystem = new MemFS();
    this.system = new MemSys();
    this.environment = environment ?? [];
    const global = typeof window == "undefined" ? self : window;
    this.timestamp = () => global.performance.now();
    const decoder = new TextDecoder("utf8");
    this.decodeUTF8 = (utf8: ArrayBuffer) => decoder.decode(utf8);
    const encoder = new TextEncoder(); // always utf-8
    this.encodeUTF8 = (str: string) => encoder.encode(str);
    this.base64Decode = (base64: string) =>
      Uint8Array.from(atob(base64), (c) => c.charCodeAt(0));
    this.base64Encode = (toEncode: string, url: boolean = false) => {
      const base64 = btoa(toEncode);
      return url ? base64.replaceAll("+", "-").replaceAll("/", "_") : base64;
    };
    this.storage = () => localStorage;
    this.onException = () => {
      /* default nop hook */
    };
    this.crypto = () => crypto;
  }
}

export function environment(environment?: string[]) {
  return new Env(environment);
}
