import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

// Mirrors SKIP_js_parse_float in skiplang/prelude/ts/wasm/src/sk_runtime.ts,
// and counts calls to tell the s2d path from the fallback.
let memory;
let fallbacks = 0;
const SKIP_js_parse_float = (ptr) => {
  fallbacks++;
  const size = new Uint32Array(memory.buffer, ptr - 8, 1)[0];
  return Number(
    new TextDecoder().decode(new Uint8Array(memory.buffer, ptr, size)),
  );
};

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
  { env: { SKIP_js_parse_float } },
);
({ memory } = instance.exports);
const { input_string, SKIP_String__toFloat_raw } = instance.exports;

function toFloat(str) {
  const bytes = new TextEncoder().encode(str);
  const ptr = input_string(bytes.length);
  new Uint8Array(memory.buffer, ptr, bytes.length).set(bytes);
  return SKIP_String__toFloat_raw(ptr);
}

// Number() is correctly rounded, so String.toFloat must agree with it bit for
// bit (Object.is also tells 0 from -0).
function check(str, expectFallback) {
  const before = fallbacks;
  const value = toFloat(str);
  assert.ok(
    Object.is(value, Number(str)),
    `${str}: ${value} != ${Number(str)}`,
  );
  assert.equal(fallbacks - before, expectFallback ? 1 : 0, `path for ${str}`);
}

// Up to 17 significant digits: parsed in Wasm by s2d.
for (const str of ["-1.5", "0.3", "-0", "3.141592653589793", "-1e-7"]) {
  check(str, false);
}

// More digits than s2d supports: parsed by the host. The previous in-tree
// atof returned 0 for negative ones and was a few ulps off for the others.
for (const str of [
  "-123456789012345678",
  "-0.30000000000000000001",
  "3.14159265358979323846",
  "2.718281828459045235360287",
  "123456789.123456789",
  "0.1000000000000000055511151231257827",
  "0.300000000000000000",
  "100000000000000000000",
  `-1.${"7".repeat(200)}e-300`,
]) {
  check(str, true);
}

console.log("Wasm String.toFloat matches Number() on s2d and fallback inputs.");
