#!/bin/bash

# Script to run the type-checker in all directories in the npm workspaces list

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

cd "$REPO"
DIRS=$( jq --raw-output ".workspaces[]" package.json )

for dir in $DIRS
do
    if jq -e '.scripts.typecheck' "$dir/package.json" > /dev/null 2>&1; then
        "$SCRIPT_DIR"/cd_sh "$dir" "npm run typecheck && npm run lint --if-present"
    else
        "$SCRIPT_DIR"/cd_sh "$dir" "npm run build --if-present && npm run lint --if-present"
    fi
done
