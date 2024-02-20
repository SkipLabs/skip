import { run } from "#std/sk_types.js";
import type { SKDBShared } from "./skdb_types.js";

var wasm64 = "skdb";

export async function createOnThisThread(
  disableWarnings: boolean,
  modules: Array<string>,
  envs: Map<string, Array<string>>,
  dbName?: string,
  getWasmSource?: () => Promise<Uint8Array>,
) {
  let data = await run(
    wasm64,
    // @ts-ignore
    modules,
    envs,
    "SKDB_factory",
    getWasmSource,
  );
  data.environment.disableWarnings = disableWarnings;
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}
