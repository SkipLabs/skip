import { run } from "#std/sk_types";

var wasm64 = "test";
// sknpm searches for the modules line verbatim
// prettier-ignore
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/

export async function load() {
  let data = await run(wasm64, modules, extensions);
  return data.main;
}
