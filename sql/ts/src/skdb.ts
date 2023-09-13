import { run, loadEnv, isNode} from "#std/sk_types";
import { SKDBShared } from "#skdb/skdb_types";
import { SKDBWorker } from "#skdb/skdb_wdatabase";
export {SKDB} from "#skdb/skdb_types";

var wasm64 = "skdb";
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/ 

export async function createSkdb(options: {
  dbName ?: string,
  asWorker?: boolean,
  getWasmSource?: () => Promise<Uint8Array>
} = {}) {
  const asWorker = (options.asWorker != undefined) ? options.asWorker : !options.getWasmSource;
  if (!asWorker) {
    return await createOnMain(options.dbName, options.getWasmSource);
  } else {
    if (options.getWasmSource) {
      throw new Error("getWasmSource is not compatible with worker")
    }
    return await createWorker(options.dbName);
  }
}

async function createOnMain(dbName ?: string, getWasmSource?: () => Promise<Uint8Array>) {
  let data = await run(wasm64, modules, extensions, "SKDB_factory", getWasmSource);
  return await (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}

async function createWorker(dbName ?: string) {
  let env = await loadEnv(extensions);
  let path : string;
  if (isNode()) {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_nodeworker.mjs');
    // @ts-ignore
    path = "./" + path.substring(process.cwd().length + 8);
  } else {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_worker.mjs');
  }
  let worker = env.createWorker(path, {type: 'module'});
  let skdb = new SKDBWorker(worker);
  await skdb.create(dbName);
  return skdb;
}
