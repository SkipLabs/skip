#!/usr/bin/env bash
set -euo pipefail

runtime_test_sources=$(cd "$(dirname "$0")" && pwd)
runtime_test_dir=$(mktemp -d "${TMPDIR:-/tmp}/skip-runtime-tests.XXXXXXXX")
trap 'rm -rf "$runtime_test_dir"' EXIT

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
  # Keep every UBSan check, using traps so the optional diagnostic runtime is
  # not required by minimal LLVM installations such as the CI image.
  clang -std=c2x "$runtime_test_opt" -g -Wall -Wextra -Werror \
    -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -fsanitize=undefined -fsanitize-trap=all \
    "$runtime_test_sources/reference_masks.c" -o "$runtime_test_dir/reference-masks"
  "$runtime_test_dir/reference-masks"
done

runtime_test_linker=$(command -v wasm-ld || command -v wasm-ld-20)
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
