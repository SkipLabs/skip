#!/bin/bash

SOURCE=sql/js/src/skdb.ts
WASM=sql/target/wasm32-unknown-unknown/skdb.wasm
TMP=$(mktemp /tmp/SRC.XXXXXX)

(echo -n "let wasmBase64 = \`"
 base64 -w0 $WASM
 echo "\`;"
 sed "s/let wasmBase64.*;//" $SOURCE) > $TMP
mv $TMP $SOURCE
