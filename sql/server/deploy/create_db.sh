#! /bin/bash

#
# create and setup a database
#

set -e

# allow passing a memorable name otherwise generate a random one
if [[ -z $1 ]]
then
    DB_NAME=$(openssl rand -hex 8)
    echo $DB_NAME
else
    DB_NAME=$1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DB_PREFIX=/var/db/
DB_SUFFIX=.db

DB_FILE=$DB_PREFIX$DB_NAME$DB_SUFFIX

mkdir -p $DB_PREFIX

if [[ -e $DB_FILE ]]
then
    echo "Error: $DB_FILE exists." >&2
    exit 1
fi

SKDB_BIN=/skfs_build/build/skdb
SKDB="$SKDB_BIN --data $DB_FILE"

$SKDB_BIN --init $DB_FILE

# setup the base tables used for access-control
cat $SCRIPT_DIR/../../privacy/init.sql | $SKDB

# setup some test tables
cat $SCRIPT_DIR/initdb.sql | $SKDB

