#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.
git diff --quiet HEAD $(git merge-base main HEAD) -- compiler/ prelude/ skfs/
skc=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- skfs/ compiler/runtime/
skfs=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- sql/ sqlparser/ skbuild/
skdb=$?
git diff --quiet HEAD $(git merge-base main HEAD) -- sknpm/
sknpm=$?

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

if (( $skfs != 0 ))
then
    cat <<EOF
  skfs:
    jobs:
      - skfs
EOF
fi

if (( $skdb != 0 || $skfs != 0 ))
then
    cat <<EOF
  skdb:
    jobs:
      - skdb
EOF
fi

if (( $skdb != 0 || $skfs != 0 || $sknpm != 0))
then
    cat <<EOF
  skdb-wasm:
    jobs:
      - skdb-wasm
EOF
fi
