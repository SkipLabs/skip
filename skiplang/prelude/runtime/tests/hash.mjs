import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
);
const { run_hash_tests } = instance.exports;

const rc = run_hash_tests();
assert.equal(rc, 0, `run_hash_tests failed with code ${rc}`);
console.log("SKIP_hash Wasm checks: OK");
