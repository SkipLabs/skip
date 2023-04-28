#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd /skfs || exit 1
make npm

rm -f /var/db/test.db

node "$SCRIPT_DIR"/index.mjs "$1"
