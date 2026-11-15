import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
);
for (let pass = 0; pass < 3; pass++) {
  assert.equal(instance.exports.check_regions(), 0);
}
console.log("Wasm region evacuation, sharing, cycles and alignment passed.");
