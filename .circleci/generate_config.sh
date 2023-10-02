#!/bin/bash

# TODO: This is flaky as it relies on the fork's master branch state.
git diff --quiet HEAD master -- compiler/ prelude/ skfs/
skc=$?
git diff --quiet HEAD master -- skfs/
skfs=$?
git diff --quiet HEAD master -- sql/
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
