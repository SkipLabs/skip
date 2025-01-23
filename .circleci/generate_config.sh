#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.

BASE="$(git merge-base main HEAD)"

# shellcheck disable=SC2046 # We actually want splitting in jq command output
git diff --quiet HEAD "$BASE" -- $(jq --raw-output ".workspaces[]" package.json)
check_ts=$?
git diff --quiet HEAD "$BASE" -- skiplang/compiler/ skiplang/prelude/ :^skiplang/prelude/ts
skc=$?
git diff --quiet HEAD "$BASE" -- skiplang/prelude/src/skstore/ skiplang/prelude/runtime/
skstore=$?
git diff --quiet HEAD "$BASE" -- skiplang/skjson
skjson=$?
git diff --quiet HEAD "$BASE" -- sql/ skiplang/sqlparser/ skiplang/skbuild/
skdb=$?
git diff --quiet HEAD "$BASE" -- skipruntime-ts/
skipruntime=$?
git diff --quiet HEAD "$BASE" -- skiplang/prelude/ts/
ts_prelude=$?

cat .circleci/base.yml

echo "workflows:"

    cat <<EOF
  check-format:
    jobs:
      - check-format
EOF

if (( check_ts != 0 ))
then
    cat <<EOF
  check-ts:
    jobs:
      - check-ts
EOF
fi

if (( skc != 0 ))
then
   cat <<EOF
  compiler:
    jobs:
      - compiler
EOF
fi

if (( skstore != 0 ))
then
    cat <<EOF
  skstore:
    jobs:
      - skstore
EOF
fi

if (( skjson != 0 ))
then
    cat <<EOF
  skjson:
    jobs:
      - skjson
EOF
fi

if (( skdb != 0 || skstore != 0 ))
then
    cat <<EOF
  skdb:
    jobs:
      - skdb
EOF
fi

if (( skdb != 0 || skstore != 0 || ts_prelude != 0 || skjson != 0 ))
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm
EOF
fi

if (( skstore != 0 || skipruntime != 0 || ts_prelude != 0 || skjson != 0 ))
then
    cat <<EOF
  skipruntime:
    jobs:
      - skipruntime
EOF
fi
