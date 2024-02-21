import { isNode, relativeto, resolve } from "#std/sk_types.js";
import type { Environment } from "#std/sk_types.js";

export async function getWasmUrl(env: Environment): Promise<string> {
  //@ts-ignore
  if (import.meta.env || import.meta.webpack) {
    //@ts-ignore
    const url = await import("./skdb.wasm?url");
    return url.default;
  }

  return relativeto(resolve("./skdb.wasm"), env.rootPath());
}
