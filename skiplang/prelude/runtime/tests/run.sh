#!/usr/bin/env bash
set -euo pipefail

runtime_test_sources=$(cd "$(dirname "$0")" && pwd)
runtime_test_dir=$(mktemp -d "${TMPDIR:-/tmp}/skip-runtime-tests.XXXXXXXX")
trap 'rm -rf "$runtime_test_dir"' EXIT

# Portable native check: runs on every platform.
clang -std=c2x -O2 -g -Wall -Wextra -Werror \
  -I"$runtime_test_sources/.." \
  -fsanitize=undefined -fsanitize-trap=all \
  "$runtime_test_sources/to_float_raw_native.c" -o "$runtime_test_dir/to-float-raw-native"
"$runtime_test_dir/to-float-raw-native"

# The checks below are Linux-specific (glibc mutex internals, GNU ld flags).
if [ "$(uname -s)" = Darwin ]; then
  clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
    -Wl,-dead_strip -pthread "$runtime_test_sources/macos_persistent_heap.c" \
    -o "$runtime_test_dir/macos-persistent-heap"
  "$runtime_test_dir/macos-persistent-heap"

  clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
    -Wl,-dead_strip -pthread "$runtime_test_sources/mapping_growth.c" \
    -o "$runtime_test_dir/mapping-growth"
  "$runtime_test_dir/mapping-growth"
fi

if [ "$(uname -s)" != Darwin ]; then
clang -Wall -Wextra -Werror "$runtime_test_sources/alloc_size_classes.c" \
  -o "$runtime_test_dir/size-classes"
"$runtime_test_dir/size-classes"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/persistent_mutex_recovery.c" \
  -o "$runtime_test_dir/mutex"
"$runtime_test_dir/mutex"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/no_file_mapping_noreserve.c" \
  -o "$runtime_test_dir/noreserve"
"$runtime_test_dir/noreserve"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/mapping_growth.c" \
  -o "$runtime_test_dir/mapping-growth"
"$runtime_test_dir/mapping-growth"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/persistent_flock_eintr.c" \
  -o "$runtime_test_dir/flock-eintr"
"$runtime_test_dir/flock-eintr"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/persistent_mapping_exists.c" \
  -o "$runtime_test_dir/mapping-exists"
"$runtime_test_dir/mapping-exists"

clang -O0 -g -Wall -Wextra -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections -pthread "$runtime_test_sources/persistent_mapping_identity.c" \
  -o "$runtime_test_dir/mapping-identity"
"$runtime_test_dir/mapping-identity"

for runtime_test_opt in -O0 -O2; do
  clang -std=c2x "$runtime_test_opt" -g -Wall -Wextra -Werror \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -fsanitize=undefined -fsanitize-trap=all \
    "$runtime_test_sources/region_checkpoint.c" -o "$runtime_test_dir/region-checkpoint"
  "$runtime_test_dir/region-checkpoint"
  # Keep every UBSan check, using traps so the optional diagnostic runtime is
  # not required by minimal LLVM installations such as the CI image.
  clang -std=c2x "$runtime_test_opt" -g -Wall -Wextra -Werror \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -fsanitize=undefined -fsanitize-trap=all \
    "$runtime_test_sources/reference_masks.c" -o "$runtime_test_dir/reference-masks"
  "$runtime_test_dir/reference-masks"
done
fi

runtime_test_linker=$(command -v wasm-ld || command -v wasm-ld-20 || true)
if [ -z "$runtime_test_linker" ]; then
  if [ "$(uname -s)" = Darwin ]; then
    exit 0
  fi
  echo "wasm-ld not found" >&2
  exit 1
fi
clang --target=wasm32 -std=c2x -O2 -nostdlib -nostdlibinc -fno-builtin \
  -Wall -Wextra -Werror -I"$runtime_test_sources/.." \
  -c "$runtime_test_sources/region_checkpoint_wasm.c" \
  -o "$runtime_test_dir/region-checkpoint.o"
"$runtime_test_linker" --no-entry --initial-memory=16777216 \
  --export=check_regions "$runtime_test_dir/region-checkpoint.o" \
  -o "$runtime_test_dir/region-checkpoint.wasm"
node "$runtime_test_sources/region_checkpoint_wasm.mjs" \
  "$runtime_test_dir/region-checkpoint.wasm"

clang --target=wasm32 -DSKIP32 -O2 -nostdlib -c \
  "$runtime_test_sources/alloc_size_classes.c" -o "$runtime_test_dir/size-classes.o"
"$runtime_test_linker" --no-entry --initial-memory=16777216 \
  --export=check_size_classes --export=check_overflow \
  "$runtime_test_dir/size-classes.o" -o "$runtime_test_dir/size-classes.wasm"
node "$runtime_test_sources/alloc_size_classes.mjs" "$runtime_test_dir/size-classes.wasm"

clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -I"$runtime_test_sources/.." -c "$runtime_test_sources/string_to_float.c" \
  -o "$runtime_test_dir/string-to-float.o"
"$runtime_test_linker" --no-entry \
  --export=input_buffer --export=parse --export=result \
  "$runtime_test_dir/string-to-float.o" -o "$runtime_test_dir/string-to-float.wasm"
node "$runtime_test_sources/string_to_float.mjs" "$runtime_test_dir/string-to-float.wasm"

printf 'SKIP_js_parse_float\n' > "$runtime_test_dir/to-float-raw.imports"
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -I"$runtime_test_sources/.." -c "$runtime_test_sources/to_float_raw.c" \
  -o "$runtime_test_dir/to-float-raw.o"
"$runtime_test_linker" --no-entry --export-memory \
  --allow-undefined-file="$runtime_test_dir/to-float-raw.imports" \
  --export=input_string --export=SKIP_String__toFloat_raw \
  "$runtime_test_dir/to-float-raw.o" -o "$runtime_test_dir/to-float-raw.wasm"
node "$runtime_test_sources/to_float_raw.mjs" "$runtime_test_dir/to-float-raw.wasm"

clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -I"$runtime_test_sources/.." -c "$runtime_test_sources/float_to_string.c" \
  -o "$runtime_test_dir/float-to-string.o"
"$runtime_test_linker" --no-entry --export-memory \
  --export=SKIP_Float_toStringShortest \
  "$runtime_test_dir/float-to-string.o" -o "$runtime_test_dir/float-to-string.wasm"
node "$runtime_test_sources/float_to_string.mjs" "$runtime_test_dir/float-to-string.wasm"

clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -I"$runtime_test_sources/.." -c "$runtime_test_sources/../runtime32_specific.c" \
  -o "$runtime_test_dir/runtime32-specific.o"
clang --target=wasm32 -DSKIP32 -O2 -nostdlib -nostdlibinc \
  -Wall -Wextra -Werror -Wno-c2x-extensions \
  -I"$runtime_test_sources/.." -c "$runtime_test_sources/int128_helpers.c" \
  -o "$runtime_test_dir/int128-helpers.o"
"$runtime_test_linker" --no-entry --export-memory --gc-sections \
  --export=result_buf \
  --export=test_mul --export=test_ashl --export=test_lshr --export=test_ashr \
  --export=test_udiv --export=test_umod --export=test_div --export=test_mod \
  "$runtime_test_dir/int128-helpers.o" "$runtime_test_dir/runtime32-specific.o" \
  -o "$runtime_test_dir/int128-helpers.wasm"
node "$runtime_test_sources/int128_helpers.mjs" "$runtime_test_dir/int128-helpers.wasm"
