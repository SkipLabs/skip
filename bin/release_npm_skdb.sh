#! /bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

current_version=$(npm view skdb version)

if grep -q "$current_version" "$SCRIPT_DIR"/../sql/npm.json
then
    echo "ERROR: Found the current published version specified in npm.json, did you bump the version and commit?" >&2
    exit 1
fi

cd "$SCRIPT_DIR/../" || exit 1

make build/sknpm

(cd sql/ts && ../../build/sknpm build --release)

make test-wasm

(cd sql/ts && ../../build/sknpm publish --release)
