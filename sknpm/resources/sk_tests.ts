import { run, type ToWasmManager } from "./sk_types.js";

var modules : (()=> Promise<ToWasmManager>)[];
/*--MODULES--*/

const wasmurl = new URL('./test.wasm', import.meta.url);

export async function load() {
  let data = await run(wasmurl, modules, []);
  return data.main;
}
