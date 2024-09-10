#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.
git diff --quiet HEAD $(git merge-base main HEAD) -- compiler/ prelude/ :^prelude/ts
skc=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- prelude/src/skstore/ compiler/runtime/
skstore=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- sql/ sqlparser/ skbuild/
skdb=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- sknpm/
sknpm=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skipruntime-ts/
skipruntime_wasm=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- prelude/ts/
ts_prelude=$?

cat .circleci/base.yml

echo "workflows:"

    cat <<EOF
  check-format:
    jobs:
      - check-format
EOF

if (( $skc != 0 ))
then
    cat <<EOF
  compiler:
    jobs:
      - compiler
EOF
fi

if (( $skstore != 0 ))
then
    cat <<EOF
  skstore:
    jobs:
      - skstore
EOF
fi

if (( $skdb != 0 || $skstore != 0 ))
then
    cat <<EOF
  skdb:
    jobs:
      - skdb
EOF
fi

if (( $skdb != 0 || $skstore != 0 || $sknpm != 0 || $ts_prelude != 0 ))
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm-client
      - skdb-wasm-api
      - skdb-wasm-mux
EOF
fi

if (( $skdb != 0 || $skstore != 0 || $skipruntime_wasm != 0 || $sknpm != 0 || $ts_prelude != 0 ))
then
    cat <<EOF
  skipruntime-wasm:
    jobs:
      - skipruntime-wasm
EOF
fi
