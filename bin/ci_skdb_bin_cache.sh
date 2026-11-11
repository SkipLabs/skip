#!/bin/bash

# CircleCI cache for the skdb release binary, used by the skdb and skdb-wasm
# jobs through the skdb-bin-cache-restore / skdb-bin-cache-save commands in
# .circleci/base.yml:
#
#   ci_skdb_bin_cache.sh key    print a fingerprint of the binary's build inputs
#                               (base.yml snapshots it to /tmp/skdb-bin-key and
#                               uses it as the restore_cache/save_cache key)
#   ci_skdb_bin_cache.sh touch  after a restore, bump the cached binary's mtime
#                               so make skips the rebuild against the freshly
#                               checked-out sources
#
# The fingerprint covers everything `cd sql && skargo build --release --bin
# skdb` reads: the sources and Skargo.toml of sql and its transitive path
# dependencies (derived from the path = "..." entries like generate_config.sh
# derives them), the toolchain in /usr/bin and /usr/lib -- the image's stage0,
# or the candidate stage0 that use-candidate-toolchain installed (the key is
# computed after that step, so the two never share an entry) -- the native
# compiler versions, and the root Makefile's build rule. A PR that changes none
# of those (sql test scripts, sql/ts, sql/server, privacy SQL, ...) restores
# the binary and skips the multi-minute rebuild; any input change yields a new
# key and a full rebuild. The save step runs after the tests pass, so a broken
# binary is never cached.

set -euo pipefail

BIN=sql/target/host/release/skdb

# Print sql and its transitive path dependencies, one per line.
dep_dirs() {
  echo sql
  local -a queue=(sql)
  local seen=" sql "
  local cur dep resolved
  while [ "${#queue[@]}" -gt 0 ]; do
    cur="${queue[0]}"
    queue=("${queue[@]:1}")
    while IFS= read -r dep; do
      [ -n "$dep" ] || continue
      resolved=$(realpath -m --relative-to=. "$cur/$dep" 2>/dev/null) || continue
      [ -f "$resolved/Skargo.toml" ] || continue
      case "$seen" in *" $resolved "*) continue ;; esac
      seen="$seen$resolved "
      echo "$resolved"
      queue+=("$resolved")
    done < <(awk '/^\[(dev-|build-)?dependencies\]/{d=1;next} /^\[/{d=0} d && /path"? *=/{print}' "$cur/Skargo.toml" \
             | grep -oE '"?path"? *= *"[^"]+"' | sed 's/.*"\(.*\)"/\1/')
  done
}

key() {
  local dir f
  {
    for dir in $(dep_dirs); do
      if [ -f "$dir/Skargo.toml" ]; then sha256sum "$dir/Skargo.toml"; fi
      if [ -d "$dir/src" ]; then
        find "$dir/src" -type f -print0 | LC_ALL=C sort -z | xargs -0 -r sha256sum
      fi
    done
    sha256sum Makefile
    # The toolchain skc/skargo build and link with (image stage0, or the
    # candidate stage0 installed over it by use-candidate-toolchain).
    for f in /usr/bin/skc /usr/bin/skargo; do
      if [ -f "$f" ]; then sha256sum "$f"; else echo "missing: $f"; fi
    done
    find /usr/lib -maxdepth 1 \( -name '*.sklib' -o -name 'lib*.a' \) -type f -print0 \
      | LC_ALL=C sort -z | xargs -0 -r sha256sum
    # The native compiler and linker skargo invokes for the host binary.
    clang --version 2>/dev/null | head -n 1 || true
    ld.lld --version 2>/dev/null | head -n 1 || true
  } | sha256sum | cut -d' ' -f1
}

touch_bin() {
  if [ -f "$BIN" ]; then
    touch "$BIN"
    echo "restored cached $BIN; mtime bumped so make skips the rebuild"
  else
    echo "no cached $BIN for this key; building from source"
  fi
}

case "${1:-}" in
  key) key ;;
  touch) touch_bin ;;
  *)
    echo "usage: $0 key | touch" >&2
    exit 2
    ;;
esac
