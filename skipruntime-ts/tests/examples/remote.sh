#!/bin/bash
set -e
cd ../../examples

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <stdout target> <stderr target>"
fi

node dist/sum.js >/dev/null &
node dist/remote.js >/dev/null &

sleep 0.25 # give a moment for services to spin up
node dist/remote-client.js >"$1" 2>"$2"

kill $(jobs -p)
