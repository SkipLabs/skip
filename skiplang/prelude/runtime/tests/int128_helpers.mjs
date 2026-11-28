import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const { instance } = await WebAssembly.instantiate(
  readFileSync(process.argv[2]),
);
const {
  memory,
  result_buf,
  test_mul,
  test_ashl,
  test_lshr,
  test_ashr,
  test_udiv,
  test_umod,
  test_div,
  test_mod,
} = instance.exports;

const MASK64 = (1n << 64n) - 1n;
const MASK128 = (1n << 128n) - 1n;
const SIGN128 = 1n << 127n;

function toSigned128(u) {
  const m = u & MASK128;
  return m >= SIGN128 ? m - (1n << 128n) : m;
}

function toUnsigned128(s) {
  return BigInt.asUintN(128, s);
}

function split(u) {
  const m = u & MASK128;
  return [m & MASK64, (m >> 64n) & MASK64];
}

function readResult() {
  const ptr = result_buf();
  const view = new BigUint64Array(memory.buffer, ptr, 2);
  return view[0] | (view[1] << 64n);
}

const edgeValues = [
  0n,
  1n,
  2n,
  3n,
  7n,
  10n,
  0xffffffffn,
  0x100000000n,
  0x7fffffffffffffffn,
  0x8000000000000000n,
  0xffffffffffffffffn,
  1n << 64n,
  (1n << 64n) + 1n,
  (1n << 64n) - 1n,
  (1n << 96n) + 0x123456789abcdef0n,
  (1n << 127n) - 1n, // INT128_MAX
  1n << 127n, // INT128_MIN
  MASK128 - 1n,
  MASK128, // -1 / UINT128_MAX
  0x0123456789abcdef_fedcba9876543210n,
  0xdeadbeefcafebabe_1337c0de42424242n,
];

// Deterministic PRNG for broader coverage.
let rng = 0x9e3779b97f4a7c15n;
function nextU64() {
  rng = (rng + 0x9e3779b97f4a7c15n) & MASK64;
  let z = rng;
  z = ((z ^ (z >> 30n)) * 0xbf58476d1ce4e5b9n) & MASK64;
  z = ((z ^ (z >> 27n)) * 0x94d049bb133111ebn) & MASK64;
  return (z ^ (z >> 31n)) & MASK64;
}
function nextU128() {
  return nextU64() | (nextU64() << 64n);
}

const values = [...edgeValues];
for (let i = 0; i < 20; i++) {
  values.push(nextU128());
}

// 1. Shifts across all counts (including 0, 1, 63, 64, 65, 127, 128, negative).
const shiftCounts = [
  -129, -128, -65, -64, -1, 0, 1, 2, 31, 32, 63, 64, 65, 95, 126, 127, 128, 129,
];
for (const a of edgeValues) {
  const [alo, ahi] = split(a);
  const sa = toSigned128(a);
  for (const s of shiftCounts) {
    const sh = BigInt(s & 127);

    test_ashl(alo, ahi, s);
    assert.equal(readResult(), (a << sh) & MASK128, `ashl(${a}, ${s})`);

    test_lshr(alo, ahi, s);
    assert.equal(readResult(), a >> sh, `lshr(${a}, ${s})`);

    test_ashr(alo, ahi, s);
    assert.equal(readResult(), toUnsigned128(sa >> sh), `ashr(${sa}, ${s})`);
  }
}

// 2. Multiply, udiv, umod, sdiv, smod across all value pairs.
for (const a of values) {
  const [alo, ahi] = split(a);
  const sa = toSigned128(a);
  for (const b of values) {
    const [blo, bhi] = split(b);
    const sb = toSigned128(b);

    test_mul(alo, ahi, blo, bhi);
    assert.equal(readResult(), (a * b) & MASK128, `mul(${a}, ${b})`);

    if (b !== 0n) {
      test_udiv(alo, ahi, blo, bhi);
      assert.equal(readResult(), a / b, `udiv(${a}, ${b})`);

      test_umod(alo, ahi, blo, bhi);
      assert.equal(readResult(), a % b, `umod(${a}, ${b})`);

      // Signed division/remainder (skip INT128_MIN / -1 overflow).
      if (!(a === SIGN128 && b === MASK128)) {
        test_div(alo, ahi, blo, bhi);
        assert.equal(readResult(), toUnsigned128(sa / sb), `div(${sa}, ${sb})`);

        test_mod(alo, ahi, blo, bhi);
        assert.equal(readResult(), toUnsigned128(sa % sb), `mod(${sa}, ${sb})`);
      }
    }
  }
}

// 3. Direct zero-divisor calls trap consistently (both narrow and wide dividends).
for (const [fn, name] of [
  [test_udiv, "udiv"],
  [test_umod, "umod"],
  [test_div, "div"],
  [test_mod, "mod"],
]) {
  for (const a of [0n, 1n, (1n << 64n) + 7n, MASK128]) {
    const [alo, ahi] = split(a);
    assert.throws(
      () => fn(alo, ahi, 0n, 0n),
      WebAssembly.RuntimeError,
      `${name}(${a}, 0) must trap`,
    );
  }
}

console.log("Wasm i128 compiler-rt helpers passed.");
