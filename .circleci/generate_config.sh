#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.
git diff --quiet HEAD $(git merge-base main HEAD) -- $(jq --raw-output ".workspaces[]" package.json)
check_ts=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skiplang/compiler/ skiplang/prelude/ :^skiplang/prelude/ts
skc=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skiplang/prelude/src/skstore/ skiplang/compiler/runtime/
skstore=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- sql/ skiplang/sqlparser/ skiplang/skbuild/
skdb=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skipruntime-ts/
skipruntime=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skiplang/prelude/ts/
ts_prelude=$?

cat .circleci/base.yml

echo "workflows:"

    cat <<EOF
  check-format:
    jobs:
      - check-format
EOF

if (( $check_ts != 0 ))
then
    cat <<EOF
  check-ts:
    jobs:
      - check-ts
EOF
fi

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

if (( $skdb != 0 || $skstore != 0 || $ts_prelude != 0 ))
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm
EOF
fi

if (( $skdb != 0 || $skstore != 0 || $skipruntime != 0 || $ts_prelude != 0 ))
then
    cat <<EOF
  skipruntime:
    jobs:
      - skipruntime
EOF
fi
