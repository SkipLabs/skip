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
    echo "Run departures with native platform"
    LD_LIBRARY_PATH=$(realpath ../../build/skipruntime) SKIP_PLATFORM="native" node dist/departures.js >/dev/null &
else
    echo "Run departures with wasm platform"
    node dist/departures.js >/dev/null &
fi

sleep 1 # give a moment for service to spin up
node dist/departures-client.js >"$1" 2>"$2"

