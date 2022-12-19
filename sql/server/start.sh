#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

cat initdb.sql | $SKDB

cd ~/websockify && ./run 3048 -v  -- /home/julienv/skfs/sql/server/start_tcp_server.sh
