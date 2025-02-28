#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.

BASE="$(git merge-base main HEAD)"

# shellcheck disable=SC2046 # We actually want splitting in jq command output
git diff --quiet HEAD "$BASE" -- $(jq --raw-output ".workspaces[]" package.json)
check_ts=$?
git diff --quiet HEAD "$BASE" -- skiplang/prelude/ :^skiplang/prelude/ts
prelude=$?
git diff --quiet HEAD "$BASE" -- skiplang/compiler/
skc=$?
git diff --quiet HEAD "$BASE" -- skiplang/skjson
skjson=$?
git diff --quiet HEAD "$BASE" -- sql/ skiplang/sqlparser/
skdb=$?
git diff --quiet HEAD "$BASE" -- skipruntime-ts/
skipruntime=$?
git diff --quiet HEAD "$BASE" -- skiplang/prelude/ts/
ts_prelude=$?
git diff --quiet HEAD "$BASE" -- examples/
examples=$?

SKIPLANG_LIBS_CHANGED=()
for lib_tests in skiplang/*/tests; do
  lib=$(basename "$(dirname "$lib_tests")")
  if [ "$lib" != compiler ] && [ "$lib" != prelude ] && \
    ! git diff --quiet HEAD "$BASE" -- "skiplang/$lib"; then
      SKIPLANG_LIBS_CHANGED+=("$lib")
  fi
done

cat .circleci/base.yml

echo "workflows:"

    cat <<EOF
  fast-checks:
    jobs:
      - fast-checks
EOF

if (( check_ts != 0 ))
then
    cat <<EOF
  check-ts:
    jobs:
      - check-ts
EOF
fi

if (( skc != 0 || prelude != 0 ))
then
   cat <<EOF
  compiler:
    jobs:
      - compiler
EOF
fi

if (( prelude != 0 ))
then
    cat <<EOF
  skstore:
    jobs:
      - skstore
EOF
fi

for lib in "${SKIPLANG_LIBS_CHANGED[@]}"; do
  echo "  $lib-tests:"
  echo "    jobs:"
  echo "      - skiplang-lib-tests:"
  echo "          libname: $lib"
  echo "          name: $lib"
done

if (( skdb != 0 || prelude != 0 ))
then
    cat <<EOF
  skdb:
    jobs:
      - skdb
EOF
fi

if (( skdb != 0 || prelude != 0 || ts_prelude != 0 || skjson != 0 ))
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm
EOF
fi

if (( prelude != 0 || skipruntime != 0 || ts_prelude != 0 || skjson != 0 ))
then
    cat <<EOF
  skipruntime:
    jobs:
      - skipruntime
EOF
fi

if (( examples != 0 ))
then
    cat <<EOF
  examples:
    jobs:
      - check-examples
EOF
fi
