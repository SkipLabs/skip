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

# Persistent mutex recovery

On Linux, the first process reopening a persistent mapping resets its shared
mutex under an exclusive file lock. Later concurrent processes hold shared file
locks and use the same mutex. This test poisons the persisted owner field,
checks that reopening recovers, and checks that a second live process waits for
the first to release the mutex.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread \
  skiplang/prelude/runtime/tests/persistent_mutex_recovery.c \
  -o /tmp/test-persistent-mutex-recovery
/tmp/test-persistent-mutex-recovery
```

# Reference masks

The object traversals use 64-bit reference masks. This regression exercises
copying, interning, freeing, hashing and structural equality at slots 0, 31, 32,
63, 64 and 70, for a class and a two-element array. It checks the actual traversal
stacks, including scalar fields between references and mask-word boundaries.

```sh
clang -std=c2x -O2 -g -Wall -Wextra -Werror \
  -ffunction-sections -fdata-sections -Wl,--gc-sections \
  -fsanitize=undefined -fno-sanitize-recover=all \
  skiplang/prelude/runtime/tests/reference_masks.c -o /tmp/reference-masks
/tmp/reference-masks
```

Repeat with `-O0` to cover the diagnostic build. The old `1 << i` expression
shifts a signed 32-bit integer and fails UBSan at bit 31. Testing the selected
bit by shifting the unsigned 64-bit mask avoids both signed overflow and
out-of-range shifts. Allocator/target-following stubs keep this test focused on
the real traversal routines; it is not an end-to-end allocator or Wasm test.
