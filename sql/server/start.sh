#!/bin/bash

DB=/tmp/test.db
SKDB_BIN=/skfs_build/build/skdb
SKDB="$SKDB_BIN --data $DB"

rm -f $DB

$SKDB_BIN --init $DB

cat ../privacy/init.sql | $SKDB

cat initdb.sql | $SKDB

source "/root/.sdkman/bin/sdkman-init.sh"
cd skgw && gradle --console plain run
