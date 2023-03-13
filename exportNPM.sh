#!/bin/bash

cp sql/js/package.json $1/packages/skdb/package.json
cp sql/js/skdb.wasm $1/packages/skdb/skdb.wasm
cp sql/js/src/skdb.ts $1/packages/skdb/src/skdb-browser.ts

