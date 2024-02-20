import { isNode, relativeto, resolve } from "#std/sk_types.js";
import type { Environment } from "#std/sk_types.js";

export async function getWasmUrl(env: Environment): Promise<string> {
  if (isNode()) {
    return relativeto(resolve("./skdb.wasm"), env.rootPath())
  } else {
    //@ts-ignore
    const url = await import("./skdb.wasm?url");
    return url.default;
  }
}
