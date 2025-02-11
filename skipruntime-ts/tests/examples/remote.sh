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
    echo "Run remote with native platform"
    LD_LIBRARY_PATH=$(realpath ../../build/skipruntime) SKIP_PLATFORM="native" node dist/sum.js >/dev/null &
    LD_LIBRARY_PATH=$(realpath ../../build/skipruntime) SKIP_PLATFORM="native" node dist/remote.js >/dev/null &
else
    echo "Run remote with wasm platform"
    node dist/sum.js >/dev/null &
    node dist/remote.js >/dev/null &
fi

sleep 1 # give a moment for services to spin up
node dist/remote-client.js >"$1" 2>"$2"
