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

# Wasm string-to-float

Without libc, the Wasm runtime parses floats with Ryu's `s2d` (`ryu/s2d.c`)
when it can, and otherwise asks the JS host (see "Wasm String.toFloat" below).
This test builds `s2d` with the Wasm runtime's flags and checks
that it matches JavaScript's correctly rounded `Number()` bit for bit. It covers
fixed cases (subnormals, `DBL_MAX`, overflow and underflow), 100,000 random
decimal strings and the shortest representations of 100,000 random doubles. The
test links without `--allow-undefined`, so the link fails if `s2d` needs
compiler-rt helpers such as `__multi3` that the Wasm module cannot import.

```sh
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Iskiplang/prelude/runtime -c skiplang/prelude/runtime/tests/string_to_float.c \
  -o /tmp/string-to-float.o
wasm-ld --no-entry --export=input_buffer --export=parse --export=result \
  /tmp/string-to-float.o -o /tmp/string-to-float.wasm
node skiplang/prelude/runtime/tests/string_to_float.mjs /tmp/string-to-float.wasm
```

# Wasm String.toFloat

`SKIP_String__toFloat_raw` parses with `s2d` when it can and otherwise calls the
JS host's `SKIP_js_parse_float` (`Number()`). This test builds the real
`string.c` for Wasm, provides that import as `sk_runtime.ts` does, and checks
both paths against `Number()`: inputs `s2d` handles must not call the host, and
longer ones (negative numbers, more than 17 significant digits) must be parsed
exactly. The in-tree `atof` that the host call replaces returned `0` for
negative numbers and was a few ulps off for long inputs.

```sh
printf 'SKIP_js_parse_float\n' > /tmp/to-float-raw.imports
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -Iskiplang/prelude/runtime -c skiplang/prelude/runtime/tests/to_float_raw.c \
  -o /tmp/to-float-raw.o
wasm-ld --no-entry --export-memory \
  --allow-undefined-file=/tmp/to-float-raw.imports \
  --export=input_string --export=SKIP_String__toFloat_raw \
  /tmp/to-float-raw.o -o /tmp/to-float-raw.wasm
node skiplang/prelude/runtime/tests/to_float_raw.mjs /tmp/to-float-raw.wasm
```

# Wasm Float.toString

`Float.toString` formats with `SKIP_Float_toStringShortest` (`string.c`), which
lays out Ryu's shortest round-trip digits in Skip's conventions: fixed notation
for 1e-4 <= value < 1e15, `.0` for integers, and exponents `e+N`, `e-0N` and
`e-NN`. This test builds it for Wasm and checks it against the digits of JS
`Number.prototype.toString` laid out the same way, for fixed edge cases
(boundaries, subnormals, `DBL_MAX`) and 200,000 random values. Each result must
also round-trip through `Number()`.

```sh
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -Iskiplang/prelude/runtime -c skiplang/prelude/runtime/tests/float_to_string.c \
  -o /tmp/float-to-string.o
wasm-ld --no-entry --export-memory --export=SKIP_Float_toStringShortest \
  /tmp/float-to-string.o -o /tmp/float-to-string.wasm
node skiplang/prelude/runtime/tests/float_to_string.mjs /tmp/float-to-string.wasm
```
