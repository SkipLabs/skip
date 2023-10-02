#! /bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

current_version=$(npm view skdb-dev version)

cd "$SCRIPT_DIR/../packages/dev" || exit 1

if grep -q "version.*$current_version" package.json
then
    echo "ERROR: Found the current published version specified in package.json, did you bump the version and commit?" >&2
    exit 1
fi

skdb_current_version=$(npm view skdb version)

if ! grep -q "skdb.*$skdb_current_version" package.json
then
    echo "ERROR: Did not find the current published skdb version specified in package.json as a dep" >&2
    exit 1
fi

npm publish
