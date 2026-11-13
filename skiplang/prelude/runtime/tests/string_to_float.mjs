import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
);
const { memory, input_buffer, parse, result } = instance.exports;
const SUCCESS = 0;

function s2d(str) {
  const bytes = new TextEncoder().encode(str);
  assert.ok(bytes.length <= 64, str);
  new Uint8Array(memory.buffer, input_buffer(), bytes.length).set(bytes);
  return { status: parse(bytes.length), value: result() };
}

// Number() is correctly rounded, so s2d must agree with it bit for bit
// (Object.is also tells 0 from -0).
function check(str) {
  const { status, value } = s2d(str);
  assert.equal(status, SUCCESS, `s2d status for ${str}`);
  assert.ok(
    Object.is(value, Number(str)),
    `${str}: ${value} != ${Number(str)}`,
  );
}

for (const str of [
  "0",
  "-0",
  "0.3",
  "0.1",
  "1e-1",
  "3.14",
  "-3.14",
  "3.141592653589793",
  "0.30000000000000004",
  "1e+21",
  "1E-7",
  "9007199254740993", // 2^53 + 1: ties to even
  "5e-324", // smallest subnormal
  "4.9406564584124654e-324",
  "2.4703282292062328e-324", // just above half of it: rounds up
  "2.2250738585072011e-308", // largest subnormal
  "2.2250738585072014e-308", // smallest normal
  "1.7976931348623157e308", // DBL_MAX
  "1.7976931348623158e308", // rounds down to DBL_MAX
  "1.8e308", // overflows to infinity
  "1e-400", // underflows to zero
]) {
  check(str);
}

// More than 17 significant digits is unsupported; the runtime asks the host.
assert.notEqual(s2d("123456789012345678").status, SUCCESS);

// xorshift64, so failures are reproducible.
let state = 0x9e3779b97f4a7c15n;
function next() {
  state ^= (state << 13n) & 0xffffffffffffffffn;
  state ^= state >> 7n;
  state ^= (state << 17n) & 0xffffffffffffffffn;
  return state;
}
const below = (n) => Number(next() % BigInt(n));

// Random decimal strings with up to 17 digits and exponents across, and
// beyond, the double range.
for (let i = 0; i < 100000; i++) {
  const ndigits = 1 + below(17);
  const dot = below(ndigits);
  let str = below(2) ? "-" : "";
  for (let d = 0; d < ndigits; d++) {
    if (d === dot && d > 0) str += ".";
    str += below(10);
  }
  if (below(3)) str += `e${below(700) - 350}`;
  check(str);
}

// Shortest round-trip digits of random doubles, in exponent form: s2d counts
// trailing zeros as significant digits, so String(1e20) would be too long.
const bits = new DataView(new ArrayBuffer(8));
for (let i = 0; i < 100000; i++) {
  bits.setBigUint64(0, next());
  const value = bits.getFloat64(0);
  if (Number.isFinite(value)) check(value.toExponential());
}

console.log("Wasm s2d agrees with Number() on all inputs.");
