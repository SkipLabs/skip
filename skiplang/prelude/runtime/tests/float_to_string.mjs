import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
);
const { memory, SKIP_Float_toStringShortest } = instance.exports;

function format(value) {
  const ptr = SKIP_Float_toStringShortest(value);
  const size = new Uint32Array(memory.buffer, ptr - 8, 1)[0];
  return new TextDecoder().decode(new Uint8Array(memory.buffer, ptr, size));
}

// The expected output from JS: the same shortest round-trip digits as
// Number.prototype.toString, laid out in Skip's conventions (fixed notation for
// 1e-4 <= value < 1e15, ".0" for integers, exponents e+N, e-0N and e-NN).
function expected(value) {
  if (value === 0) return "0.0";
  const [mantissa, exp] = value.toExponential().split("e");
  const digits = mantissa.replace(".", "");
  const e = Number(exp);
  if (e >= -4 && e <= 14) {
    if (e < 0) return `0.${"0".repeat(-e - 1)}${digits}`;
    const int = digits.slice(0, e + 1).padEnd(e + 1, "0");
    return `${int}.${digits.slice(e + 1) || "0"}`;
  }
  const exponent = e < 0 ? (e > -10 ? `e-0${-e}` : `e${e}`) : `e+${e}`;
  return `${digits[0]}.${digits.slice(1) || "0"}${exponent}`;
}

function check(value) {
  const got = format(value);
  assert.equal(got, expected(value), `formatting ${value}`);
  assert.ok(Object.is(Number(got), value), `${got} does not round-trip`);
}

for (const value of [
  0,
  1,
  0.1,
  0.3,
  0.1 + 0.2,
  1 / 3,
  100,
  123.456,
  999999999999999,
  1e15,
  9999999999999998,
  1e16,
  2 ** 53,
  2 ** 53 - 1,
  0.0001,
  0.00009999,
  0.00001,
  1e-7,
  1e21,
  1e100,
  1e-100,
  5e-324,
  2.225073858507201e-308,
  2.2250738585072014e-308,
  Number.MAX_VALUE,
]) {
  check(value);
}

// xorshift64, so failures are reproducible.
let state = 0x2545f4914f6cdd1dn;
function next() {
  state ^= (state << 13n) & 0xffffffffffffffffn;
  state ^= state >> 7n;
  state ^= (state << 17n) & 0xffffffffffffffffn;
  return state;
}

// Random positive doubles across the whole range, and random decimals near
// the fixed/scientific boundaries.
const bits = new DataView(new ArrayBuffer(8));
for (let i = 0; i < 100000; i++) {
  bits.setBigUint64(0, next() & 0x7fffffffffffffffn);
  const value = bits.getFloat64(0);
  if (Number.isFinite(value)) check(value);
  check(Number(next() % 100000000n) / 10 ** Number(next() % 24n));
}

console.log("Wasm Float.toString matches JS digits in Skip's layout.");
