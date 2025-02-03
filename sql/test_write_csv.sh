#!/bin/bash

if [ -z "$SKARGO_PROFILE" ]; then
    SKARGO_PROFILE=dev
fi

DB=/tmp/write-csv.db
SKDB="skargo run --profile $SKARGO_PROFILE -- "
WRITE_CSV="$SKDB write-csv --always-allow-joins --data $DB"

$SKDB --init $DB

echo "CREATE TABLE no_pk_inserts (id INTEGER, client INTEGER, value INTEGER, skdb_access TEXT NOT NULL);" | $SKDB --always-allow-joins --data $DB
$WRITE_CSV < "test/write-csv.csv"

rm $DB



