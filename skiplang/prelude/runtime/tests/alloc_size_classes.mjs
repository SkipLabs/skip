import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';

const { instance } = await WebAssembly.instantiate(readFileSync(process.argv[2]));
assert.equal(instance.exports.check_size_classes(), 0);
assert.throws(() => instance.exports.check_overflow(), WebAssembly.RuntimeError);
console.log('Wasm size classes, free-list reuse, accounting, and overflow passed.');
