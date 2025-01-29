#!/bin/bash
set -e
cd ../../examples

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <stdout target> <stderr target>"
fi

node dist/groups.js >/dev/null &
node dist/groups-server.js >/dev/null &

sleep 0.25 # give a moment for service to spin up
node dist/groups-client.js >"$1" 2>"$2"

kill $(jobs -p)
