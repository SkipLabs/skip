import { run, type ModuleInit } from "#std/sk_types.js";

const modules: ModuleInit[] = [];
/*--MODULES--*/

const wasmurl = new URL("./test.wasm", import.meta.url);

export async function load() {
  let data = await run(wasmurl, modules, []);
  return data.main;
}
