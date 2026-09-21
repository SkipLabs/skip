**JS↔Skip Bridge Edge Cases**

This document describes edge case tests added to verify the behavior of the JavaScript↔Skip bridge. These tests document current behavior, some of which is problematic.

## Overview

The Skip Runtime has two implementations:
- **WASM**: WebAssembly-based (`@skipruntime/wasm`)
- **Native**: Node.js C++ addon (`@skipruntime/native`)

Both share the same TypeScript interface and JSON serialization layer. The tests below verify that both implementations handle JavaScript edge cases consistently.

---

## Test: `testNaNHandling`

**What it tests**: How `NaN` (Not a Number) is handled when stored in collections.

**Current behavior**: NaN passes through unchanged.

**Why this is problematic**:
- `NaN` is **not a valid JSON value** per RFC 8259
- `JSON.stringify(NaN)` returns `"null"`, not `"NaN"`
- Passing NaN through could cause issues when data is serialized/deserialized
- Different systems may handle NaN inconsistently

**Recommendation**: Should throw an error: "Cannot export NaN: not a valid JSON value"

---

## Test: `testInfinityHandling`

**What it tests**: How `Infinity` and `-Infinity` are handled when stored in collections.

**Current behavior**: 🔴 **SILENT DATA CORRUPTION**
```
Infinity  → 9223372036854776000  (≈ 2^63)
-Infinity → -9223372036854776000
```

**Why this is problematic**:
- `Infinity` is **not a valid JSON value** per RFC 8259
- The current code path causes integer overflow:
  ```typescript
  // In exportJSON():
  if (value === Math.trunc(value)) {  // Math.trunc(Infinity) === Infinity → true!
    return binding.SKIP_SKJSON_createCJInt(value);  // Overflows!
  }
  ```
- Users store `Infinity`, get back a huge but finite number - **data corruption**
- No error is thrown, making this very hard to debug

**Recommendation**: Should throw an error: "Cannot export Infinity: not a valid JSON value"

---

## Test: `testLargeIntegerPrecision`

**What it tests**: How integers larger than `Number.MAX_SAFE_INTEGER` (2^53 - 1) are handled.

**Current behavior**: Large integers are preserved through the Skip runtime.

**Why this could be problematic**:
- JavaScript numbers lose precision beyond 2^53
- The value `9007199254740993` cannot be exactly represented in JS
- Skip uses 64-bit integers internally, which can represent larger values
- Round-tripping through JS could lose precision for values > 2^53

**Note**: This is a fundamental JavaScript limitation, not a Skip bug. Users working with large integers should be aware of this.

