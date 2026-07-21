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
    echo "Running 'remote' example on @skipruntime/native"
    SKIP_PLATFORM="native" node dist/sum.js >/dev/null &
    SKIP_PLATFORM="native" node dist/remote.js >/dev/null &
else
    echo "Running 'remote' example on @skipruntime/wasm"
    node dist/sum.js >/dev/null &
    node dist/remote.js >/dev/null &
fi

sleep 1 # give a moment for services to spin up
node dist/remote-client.js >"$1" 2>"$2"
