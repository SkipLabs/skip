import { run } from "#std/sk_types";

var wasm64 = "test";
var modules = [
  /*--MODULES--*/
];
var extensions = new Map();
/*--EXTENSIONS--*/

export async function load() {
  let data = await run(wasm64, modules, extensions);
  return data.main;
}
