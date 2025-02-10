import {
  run,
  type EnvCreator,
  type EnvInit,
  type ModuleInit,
} from "../skipwasm-std/index.js";
import type { SKDBShared } from "./skdb_types.js";
import { getWasmUrl } from "./skdb_wasm_locator.js";

export async function createOnThisThread(
  disableWarnings: boolean,
  modules: ModuleInit[],
  extensions: EnvInit[],
  createEnvironment: EnvCreator,
  dbName?: string,
) {
  const data = await run(
    getWasmUrl,
    modules,
    extensions,
    createEnvironment,
    "SKDB_factory",
  );
  data.environment.disableWarnings = disableWarnings;
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}
