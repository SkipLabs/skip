#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.

BASE="$(git merge-base main HEAD)"

git diff --quiet HEAD "$BASE" -- examples/
examples=$?

shopt -s globstar
declare -A SK_CHANGED
for skargo_toml in **/Skargo.toml; do
  dir=$(dirname "$skargo_toml")
  git diff --quiet HEAD "$BASE" -- "$dir" :^"$dir/ts" \
    && SK_CHANGED["$dir"]=false || SK_CHANGED["$dir"]=true
done

check_ts=false
declare -A TS_CHANGED
# shellcheck disable=SC2046 # We actually want splitting in jq command output
for dir in $(jq --raw-output ".workspaces[]" package.json); do
  git diff --quiet HEAD "$BASE" -- "$dir" \
    && TS_CHANGED["$dir"]=false || TS_CHANGED["$dir"]=true
  ${TS_CHANGED["$dir"]} && check_ts=true
done

for dir in "${!TS_CHANGED[@]}"; do
  changed=${TS_CHANGED["$dir"]}
  while [ "$dir" != "." ] && [ "$dir" != "/" ]; do
    if ${TS_CHANGED["$dir"]:-false} && ! $changed; then break; fi
    TS_CHANGED["$dir"]=$changed
    dir=$(dirname "$dir")
  done
done

if ${SK_CHANGED[skiplang/prelude]}; then
  SK_CHANGED[skiplang/compiler]=true
  SK_CHANGED[sql]=true
  TS_CHANGED[sql]=true
  TS_CHANGED[skipruntime-ts]=true
fi
if ${SK_CHANGED[skiplang/sqlparser]}; then
  SK_CHANGED[sql]=true
fi
if ${SK_CHANGED[skiplang/skjson]}; then
  TS_CHANGED[sql]=true
  TS_CHANGED[skipruntime-ts]=true
fi
if ${TS_CHANGED[skiplang/prelude]}; then
  TS_CHANGED[sql]=true
  TS_CHANGED[skipruntime-ts]=true
fi

cat .circleci/base.yml

echo "workflows:"

    cat <<EOF
  fast-checks:
    jobs:
      - fast-checks
EOF

if $check_ts
then
    cat <<EOF
  check-ts:
    jobs:
      - check-ts
EOF
fi

for dir in "${!SK_CHANGED[@]}"; do
  if ${SK_CHANGED["$dir"]}; then
    case "$dir" in
      skipruntime-ts/* )
        TS_CHANGED[skipruntime-ts]=true
        ;;
      sql)
        cat <<EOF
  skdb:
    jobs:
      - skdb
EOF
        ;;
      skiplang/compiler)
   cat <<EOF
  compiler:
    jobs:
      - compiler
EOF
        ;;
      skiplang/prelude)
    cat <<EOF
  skstore:
    jobs:
      - skstore
EOF
        ;;
      *)
        if [ -d "$dir/tests" ]; then
          name=$(basename "$dir")
          echo "  $name-tests:"
          echo "    jobs:"
          echo "      - skip-package-tests:"
          echo "          dir: $dir"
          echo "          name: $name"
        fi
    esac
  fi
done

if ${TS_CHANGED[sql]}
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm
EOF
fi

if ${TS_CHANGED[skipruntime-ts]}
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
