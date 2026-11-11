# Allocator size-class checks

Run every standalone native and Wasm check on Linux with
`bash skiplang/prelude/runtime/tests/run.sh`. It requires Clang, a Wasm linker,
and Node, and removes its temporary outputs on exit. Individual commands follow.

Run from the repository root. These checks cover every byte size through 1 MiB,
all representable class boundaries, and Wasm allocation/free reuse and accounting.
The Wasm overflow check must trap rather than wrap to an undersized allocation.

```sh
clang -Wall -Wextra -Werror skiplang/prelude/runtime/tests/alloc_size_classes.c -o /tmp/size-classes
/tmp/size-classes
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -c \
  skiplang/prelude/runtime/tests/alloc_size_classes.c -o /tmp/size-classes.o
wasm-ld --no-entry --initial-memory=16777216 \
  --export=check_size_classes --export=check_overflow \
  /tmp/size-classes.o -o /tmp/size-classes.wasm
node skiplang/prelude/runtime/tests/alloc_size_classes.mjs /tmp/size-classes.wasm
```

The standalone Wasm check compiles the real `memory.c` allocator. Its 16 MiB
linear memory holds one reusable block for each class exercised by the test.

Use a versioned linker name such as `wasm-ld-20` if that is how LLVM is installed.
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

# Sparse heap without a persistent file

Without a persistent file, the runtime reserves its whole capacity (64 GiB by
default) as one anonymous mapping. It must use `MAP_NORESERVE`, or heuristic
overcommit refuses it on hosts with less RAM plus swap (#1589). This test
checks the kernel's `nr` flag on the mapping, which does not depend on the
host's overcommit policy.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread \
  skiplang/prelude/runtime/tests/no_file_mapping_noreserve.c \
  -o /tmp/test-no-file-mapping-noreserve
/tmp/test-no-file-mapping-noreserve
```

# Persistent file lock under signals

A process opening a mapping while another holds its exclusive file lock blocks
in `flock(LOCK_SH)`. A signal handler installed without `SA_RESTART` makes that
call fail with `EINTR`; the runtime must retry rather than exit with
`ERROR_LOCKING`. This test interrupts the waiting process every 5 ms until the
lock is released.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread \
  skiplang/prelude/runtime/tests/persistent_flock_eintr.c \
  -o /tmp/test-persistent-flock-eintr
/tmp/test-persistent-flock-eintr
```

# Existing persistent mapping

Creating a mapping over an existing file must exit with `ERROR_MAPPING_EXISTS`
(40), which tells "already initialized" apart from a real I/O failure
(`ERROR_FILE_IO`, 45). The runtime reports the error with `perror`, which may
change `errno`; with glibc and stderr redirected, it sets `EINVAL`. This test
redirects stderr, creates a mapping twice, and checks the second exit code.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread \
  skiplang/prelude/runtime/tests/persistent_mapping_exists.c \
  -o /tmp/test-persistent-mapping-exists
/tmp/test-persistent-mapping-exists
```

# Persistent mapping identity

A persistent heap records the GNU build-id of the executable that created it,
and only an executable with the same build-id may reopen it (#1606). This test
checks the header, reopens with the same executable, then rejects a header with
a different build-id and one in the previous (version-stamp) format with
`ERROR_MAPPING_VERSION`.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread \
  skiplang/prelude/runtime/tests/persistent_mapping_identity.c \
  -o /tmp/test-persistent-mapping-identity
/tmp/test-persistent-mapping-identity
```

# Reference masks

The object traversals use 64-bit reference masks. This regression exercises
copying, interning, freeing, hashing and structural equality at slots 0, 31, 32,
63, 64 and 70, for a class and a two-element array. It checks the actual traversal
stacks, including scalar fields between references and mask-word boundaries.

```sh
clang -std=c2x -O2 -g -Wall -Wextra -Werror \
  -ffunction-sections -fdata-sections -Wl,--gc-sections \
  -fsanitize=undefined -fsanitize-trap=all \
  skiplang/prelude/runtime/tests/reference_masks.c -o /tmp/reference-masks
/tmp/reference-masks
```

Repeat with `-O0` to cover the diagnostic build. The old `1 << i` expression
shifts a signed 32-bit integer and fails UBSan at bit 31. Testing the selected
bit by shifting the unsigned 64-bit mask avoids both signed overflow and
out-of-range shifts. Allocator/target-following stubs keep this test focused on
the real traversal routines; it is not an end-to-end allocator or Wasm test.

[UBSan trap mode](https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html#usage)
keeps the enabled checks and terminates on a failure without linking the optional
compiler-rt diagnostic library. This also works in minimal LLVM installations.

# Persistent heap on macOS

A persistent heap holds absolute pointers into the executable. arm64 macOS
cannot link non-PIE executables, so the runtime re-executes itself with ASLR
disabled before mapping a heap, keys the heap on the executable's `LC_UUID`,
and, lacking robust mutexes, takes the global lock with an `flock` on
`<file>.lock`, which the kernel releases when its holder dies. This test checks
that a stored code pointer survives a later run, that a dead lock holder does
not block later users while a live one does, and that a heap from another
executable is rejected. `run.sh` runs only this check on macOS.

```sh
clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,-dead_strip -pthread \
  skiplang/prelude/runtime/tests/macos_persistent_heap.c \
  -o /tmp/test-macos-persistent-heap
/tmp/test-macos-persistent-heap
```
