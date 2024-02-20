import { runUrl } from "#std/sk_types.js";
import type { SKDBShared } from "./skdb_types.js";
import { getWasmUrl } from "./skdb_wasm_locator.js";

export async function createOnThisThread(
  disableWarnings: boolean,
  modules: Array<string>,
  envs: Map<string, Array<string>>,
  dbName?: string,
  getWasmSource?: () => Promise<Uint8Array>,
) {
  let data = await runUrl(
    getWasmUrl,
    // @ts-ignore
    modules,
    envs,
    "SKDB_factory",
    getWasmSource,
  );
  data.environment.disableWarnings = disableWarnings;
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}
