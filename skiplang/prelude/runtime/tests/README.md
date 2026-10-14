# Allocator size-class checks

Run from the repository root. These checks cover every byte size through 1 MiB,
all representable class boundaries, and Wasm allocation/free reuse and accounting.
The Wasm overflow check must trap rather than wrap to an undersized allocation.

```sh
clang -Wall -Wextra -Werror skiplang/prelude/runtime/tests/alloc_size_classes.c -o /tmp/size-classes
/tmp/size-classes
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -fuse-ld=wasm-ld \
  -Wl,--no-entry -Wl,--initial-memory=16777216 \
  -Wl,--export=check_size_classes -Wl,--export=check_overflow \
  skiplang/prelude/runtime/tests/alloc_size_classes.c -o /tmp/size-classes.wasm
node skiplang/prelude/runtime/tests/alloc_size_classes.mjs /tmp/size-classes.wasm
```

The standalone Wasm check compiles the real `memory.c` allocator. Its 16 MiB
linear memory holds one reusable block for each class exercised by the test.

Validated on 2026-10-13: native and Wasm release prelude builds passed;
all 83 native prelude tests passed; the standalone native and Node/Wasm checks
passed; the complete Wasm prelude test binary passed `wasm-validate`.
`skargo test --target wasm32-unknown-unknown` builds the suite but does not execute
it, so Wasm execution above refers to the standalone allocator regression checks.

## SKStore parallel-map checks in Wasm

After building the prelude test binary for `wasm32-unknown-unknown` and the existing
JS bindings, run:

```sh
node skiplang/prelude/runtime/tests/run_prelude_wasm.mjs \
  /path/to/wasm32-unknown-unknown/release/test.wasm testParallelMap
```

This executes the six Skip regression tests through the serial Wasm map bridge.
The same regressions in the native prelude suite additionally verify actual
worker threads and cross-thread arena transfer. The large-output test persists
and rereads outputs, covering page-chain ownership after adoption.
