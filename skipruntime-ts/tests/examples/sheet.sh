#!/bin/bash
set -e
cd ../../examples

cleanup() {
    jobs -p | xargs kill
}

trap cleanup EXIT

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <stdout target> <stderr target> <platform>"
fi

if [ "$3" = "native" ]; then
    echo "Running 'sheet' example on @skipruntime/native"
    SKIP_PLATFORM="native" node dist/sheet.js >/dev/null &
else
    echo "Running 'sheet' example on @skipruntime/wasm"
    node dist/sheet.js >/dev/null &
fi

sleep 1 # give a moment for service to spin up
node dist/sheet-client.js >"$1" 2>"$2"
