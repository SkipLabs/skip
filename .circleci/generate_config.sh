#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.
git diff --quiet HEAD main -- compiler/ prelude/ skfs/
skc=$?
git diff --quiet HEAD main -- skfs/
skfs=$?
git diff --quiet HEAD main -- sql/
skdb=$?

if (($skc == 0 && $skfs == 0 && $skdb == 0))
then
    circleci-agent step halt
fi

cat .circleci/base.yml

echo "workflows:"

if (( $skc != 0 ))
then
    cat <<EOF
  compiler:
    jobs:
      - compiler
EOF
fi

if (( $skfs != 0 ))
then
    cat <<EOF
  skfs:
    jobs:
      - skfs
EOF
fi

if (( $skdb != 0 ))
then
    cat <<EOF
  skdb:
    jobs:
      - skdb
      - skdb-wasm
EOF
fi
