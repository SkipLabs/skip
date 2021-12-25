#!/bin/bash

DB="/home/julienv/tnt-tpch/TPC-H.db"

rm -f /tmp/test.db

skdb --init /tmp/test.db

echo ".dump" | sqlite3 $DB | grep -v BEGIN | head -n 2661000 | skdb --data /tmp/test.db
