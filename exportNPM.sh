#!/bin/bash

if [[ "$#" -ne 1 ]];
then
    echo "Pass the path to your public skdb repo as an argument" >&2
    exit 1
fi

PUBLIC_SKDB_REPO=$1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit 1

cp sql/js/package.json "$PUBLIC_SKDB_REPO"/packages/skdb/package.json
cp sql/js/tsconfig.json "$PUBLIC_SKDB_REPO"/packages/skdb/tsconfig.json

cp sql/js/skdb.wasm "$PUBLIC_SKDB_REPO"/packages/skdb/skdb.wasm

cp sql/js/src/skdb.ts "$PUBLIC_SKDB_REPO"/packages/skdb/src/skdb-browser.ts
cp sql/js/src/skdb-wasm-b64.ts "$PUBLIC_SKDB_REPO"/packages/skdb/src/skdb-wasm-b64.ts
cp sql/js/src/skdb-cli.js "$PUBLIC_SKDB_REPO"/packages/skdb/src/skdb-cli.js

# produced by makefile
cp sql/js/dist/skdb-node.js "$PUBLIC_SKDB_REPO"/packages/skdb/src/skdb-node.js
