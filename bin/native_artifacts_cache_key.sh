#!/bin/bash

# Print a content hash of the inputs that produce the native build artifacts
# cached by the skipruntime CircleCI jobs (see the native-cache-restore/save
# commands in .circleci/base.yml):
#
#   native     build/skipruntime/libskipruntime.so (host build),
#              skipruntime-ts/wasm/dist/src/libskipruntime.wasm (wasm build) and
#              skipruntime-ts/addon/build (node-gyp addon). All three are built
#              from the skiplang packages the ffi package transitively depends
#              on, with the image's stage0 toolchain, so the key covers the
#              dependency closure, the toolchain inputs (bootstrap IR, prelude
#              runtime, compiler Makefile), the addon sources and the pinned
#              image toolchain (Dockerfile, apt-install.sh, lockfile).
#   docker-so  build/libskipruntime.so-linux-<arch>, built by
#              bin/build_runtime.sh inside the skipruntime-ts/Dockerfile bake,
#              which copies the whole skiplang tree, so the key covers it all.
#
# The hash is taken over `git ls-files -s` output (git blob ids and paths), so
# it is content-based and independent of mtimes. Submodule contents are pinned
# by the gitlink entries ls-files prints for them, which is exact for the
# pristine checkouts CI runs on. For the native kind it additionally hashes the
# installed toolchain (/usr/bin/skc, /usr/bin/skargo, /usr/lib sklibs and
# archives) and the native compilers, like bin/ci_skdb_bin_cache.sh does, so
# the key step must run after use-candidate-toolchain (it does in both jobs):
# image-toolchain and candidate-toolchain builds then never share an entry.
#
# Usage: native_artifacts_cache_key.sh <native|docker-so>

set -eo pipefail

cd "$(dirname "$0")/.."

kind="${1:?usage: native_artifacts_cache_key.sh <native|docker-so>}"

# Transitive path-dependency closure of a Skargo.toml, printing package
# directories. Same parsing as .circleci/generate_config.sh.
closure() {
  seen=""
  queue="$1"
  while [ -n "$queue" ]; do
    cur="${queue%%$'\n'*}"
    queue="${queue#*$'\n'}"
    [ "$queue" = "$cur" ] && queue=""
    case "$seen" in *"$cur"$'\n'*) continue ;; esac
    seen="$seen$cur
"
    dir=$(dirname "$cur")
    while IFS= read -r dep_path; do
      [ -n "$dep_path" ] || continue
      resolved=$(realpath -m --relative-to=. "$dir/$dep_path" 2>/dev/null)
      [ -f "$resolved/Skargo.toml" ] && queue="$queue$resolved/Skargo.toml
"
    done < <(awk '/^\[(dev-|build-)?dependencies\]/{d=1;next} /^\[/{d=0} d && /path *=/{print}' "$cur" \
             | grep -oE 'path *= *"[^"]+"' | sed 's/.*"\(.*\)"/\1/')
  done
  printf '%s' "$seen" | sed 's|/Skargo.toml$||'
}

case "$kind" in
  native)
    inputs="$( { closure skipruntime-ts/skiplang/ffi/Skargo.toml
                 printf '%s\n' \
                   skiplang/compiler/bootstrap \
                   skiplang/compiler/Makefile \
                   Dockerfile bin/apt-install.sh bin/llvm-snapshot.gpg.key \
                   package-lock.json skipruntime-ts/addon
               } | sort -u)"
    ;;
  docker-so)
    inputs="$(printf '%s\n' \
      skiplang skipruntime-ts/skiplang \
      skiplang/Dockerfile skipruntime-ts/Dockerfile docker-bake.hcl \
      bin/apt-install.sh bin/llvm-snapshot.gpg.key)"
    ;;
  *)
    echo "unknown kind: $kind (want native|docker-so)" >&2
    exit 1
    ;;
esac

{ echo "skipruntime-$kind-v1"
  # shellcheck disable=SC2086 # inputs is a newline-separated path list
  xargs git ls-files -s -- <<< "$inputs"
  if [ "$kind" = native ]; then
    # The toolchain the builds run with -- the image's stage0, or the candidate
    # stage0 use-candidate-toolchain installed over it -- plus the native
    # compilers skargo invokes and the Node version the addon builds against.
    for f in /usr/bin/skc /usr/bin/skargo; do
      if [ -f "$f" ]; then sha256sum "$f"; else echo "missing: $f"; fi
    done
    find /usr/lib -maxdepth 1 \( -name '*.sklib' -o -name 'lib*.a' \) -type f -print0 \
      | LC_ALL=C sort -z | xargs -0 -r sha256sum
    clang --version 2>/dev/null | head -n 1 || true
    ld.lld --version 2>/dev/null | head -n 1 || true
    node --version 2>/dev/null || true
  fi
} | sha256sum | cut -d' ' -f1
