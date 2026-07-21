import type { float, int } from "../skiplang-std/index.js";
import type { Environment, Shared } from "./sk_types.js";
import { MemFS, MemSys } from "./sk_mem_utils.js";

import * as path from "path";
import * as fsPromises from "fs/promises";
import * as util from "util";
import * as perf_hooks from "perf_hooks";
import * as crypto from "crypto";

const decoder = new util.TextDecoder("utf8");
const encoder = new util.TextEncoder();

class Env implements Environment {
  shared: Map<string, Shared>;
  fileSystem: MemFS;
  disableWarnings: boolean = false;
  system: MemSys;
  timestamp: () => float;
  decodeUTF8: (utf8: ArrayBuffer | Uint8Array) => string;
  encodeUTF8: (str: string) => Uint8Array;
  base64Decode: (base64: string) => Uint8Array;
  base64Encode: (toEncode: string, url?: boolean) => string;
  environment: string[];
  throwRuntime: (code: int) => void;
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

  fetch(url: URL | string) {
    let filename: string | URL;
    const cwd = process.cwd();
    if (url && url instanceof URL && url.pathname) {
      filename = "./" + path.relative(cwd, url.pathname);
    } else if (
      url != "" &&
      // @ts-expect-error: Property 'default' does not exist on type 'string | URL'.
      url.default
    ) {
      // @ts-expect-error: Property 'default' does not exist on type 'string | URL'.
      filename = "./" + path.relative(cwd, url.default as string);
    } else {
      filename = url;
    }
    return fsPromises.readFile(filename);
  }

  onException() {
    /* default nop hook */
  }

  constructor(environment?: string[]) {
    this.shared = new Map<string, Shared>();
    this.fileSystem = new MemFS();
    this.system = new MemSys();
    this.timestamp = () => perf_hooks.performance.now();
    this.decodeUTF8 = (v) => decoder.decode(v);
    this.encodeUTF8 = (v) => encoder.encode(v);
    this.environment = environment ?? [];
    this.base64Decode = (base64) => Buffer.from(base64, "base64");
    this.base64Encode = (toEncode: string, url: boolean = false) =>
      Buffer.from(toEncode).toString(url ? "base64url" : "base64");
    this.throwRuntime = (code: int) => {
      this.onException();
      process.exit(code);
    };
    this.crypto = () => crypto as Crypto;
  }
}

export function environment(environment?: string[]) {
  return new Env(environment);
}
