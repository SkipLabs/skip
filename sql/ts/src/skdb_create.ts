import { runUrl, type ModuleInit } from "#std/sk_types.js";
import type { SKDBShared } from "./skdb_types.js";
import { getWasmUrl } from "./skdb_wasm_locator.js";

export async function createOnThisThread(
  disableWarnings: boolean,
  modules: ModuleInit[],
  dbName?: string,
  getWasmSource?: () => Promise<Uint8Array>,
) {
  let data = await runUrl(
    getWasmUrl,
    // @ts-ignore
    modules,
    [],
    "SKDB_factory",
    getWasmSource,
  );
  data.environment.disableWarnings = disableWarnings;
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}
