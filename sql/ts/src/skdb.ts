import { run, loadEnv, isNode } from "#std/sk_types.js";
import type { SKDB, SKDBSync, SKDBShared } from "./skdb_types.js";
import { SKDBWorker } from "./skdb_wdatabase.js";
export { SKDBTable as SKDBTable } from "./skdb_util.js";
export type { SKDB, RemoteSKDB } from "./skdb_types.js";
export type { Creds, MuxedSocket } from "./skdb_orchestration.js";
export type { Environment } from "#std/sk_types.js";

var wasm64 = "skdb";
// sknpm searches for the modules line verbatim
// prettier-ignore
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/

export async function createSkdb(
  options: {
    dbName?: string;
    asWorker?: boolean;
    getWasmSource?: () => Promise<Uint8Array>;
    disableWarnings?: boolean;
  } = {},
): Promise<SKDB> {
  const asWorker =
    options.asWorker != undefined ? options.asWorker : !options.getWasmSource;
  const disableWarnings = options.disableWarnings ?? false;
  if (!asWorker) {
    return createOnMain(disableWarnings, options.dbName, options.getWasmSource);
  } else {
    if (options.getWasmSource) {
      throw new Error("getWasmSource is not compatible with worker");
    }
    return createWorker(disableWarnings, options.dbName);
  }
}

async function createSkdbSync(
  options: {
    dbName?: string;
    getWasmSource?: () => Promise<Uint8Array>;
  } = {},
): Promise<SKDBSync> {
  let data = await run(
    wasm64,
    modules,
    extensions,
    "SKDB_factory",
    options.getWasmSource,
  );
  return (data.environment.shared.get("SKDB") as SKDBShared).createSync(
    options.dbName,
  );
}

async function createOnMain(
  disableWarnings: boolean,
  dbName?: string,
  getWasmSource?: () => Promise<Uint8Array>,
) {
  let data = await run(
    wasm64,
    modules,
    extensions,
    "SKDB_factory",
    getWasmSource,
  );
  data.environment.disableWarnings = disableWarnings;
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}

async function createWorker(disableWarnings: boolean, dbName?: string) {
  let env = await loadEnv(extensions);
  env.disableWarnings = disableWarnings;
  let path: string;
  if (isNode()) {
    path = import.meta.url.replace("/skdb.mjs", "/skdb_nodeworker.mjs");
    // @ts-ignore
    path = "./" + path.substring(process.cwd().length + 8);
  } else {
    path = import.meta.url.replace("/skdb.mjs", "/skdb_worker.mjs");
  }
  let worker = env.createWorker(path, { type: "module" });
  let skdb = new SKDBWorker(worker);
  await skdb.create(dbName);
  return skdb;
}
