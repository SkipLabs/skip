import { run, loadEnv, isNode} from "#std/sk_types";
import { SKDBShared, SKDBMain } from "#skdb/skdb_types";
import { SKDBWorker } from "#skdb/skdb_wdatabase";


var wasm64 = "skdb";
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/ 

export async function createDatabase(dbName ?: string, asWorker: boolean = true) {
  if (!asWorker) {
    return await createOnMain(dbName);
  } else {
    return await createWorker(dbName);
  }
}

export async function createOnMain(dbName ?: string, getWasmSource?: () => Promise<Uint8Array>) {
  let data = await run(wasm64, modules, extensions, "SKDB_factory", getWasmSource);
  return await (data.environment.shared.get("SKDB") as SKDBShared).create(dbName) as SKDBMain;
}

export async function createWorker(dbName ?: string) {
  let env = await loadEnv(extensions);
  let path : string;
  if (isNode()) {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_nodeworker.mjs');
    path = "./" + path.substring(process.cwd().length + 8);
  } else {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_worker.mjs');
  }
  let worker = env.createWorker(path, {type: 'module'});
  let skdb = new SKDBWorker(worker);
  await skdb.create(dbName);
  return skdb;
}

export class SKDB {
  static async create(
    dbName ?:string,
    getWasmSource?: () => Promise<Uint8Array>
  ) {
    return await createOnMain(dbName, getWasmSource)
  }
}
