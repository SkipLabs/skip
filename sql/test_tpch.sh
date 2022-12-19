#!/bin/bash

DB="/home/julienv/tnt-tpch/TPC-H.db"
SKDB=/skfs_build/build/skdb

rm -f /tmp/test.db

$SKDB --init /tmp/test.db

echo ".dump" | sqlite3 $DB | grep -v BEGIN | head -n 2661000 | $SKDB --data /tmp/test.db
