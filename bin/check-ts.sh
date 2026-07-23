#!/bin/bash

# Script to run the type-checker in all directories in the npm workspaces list

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

cd "$REPO"
# Exclude the top-level examples/* apps: check-examples builds them in Docker
# against the published @skipruntime/core, not the local workspace, so
# type-checking them here against local source would impose two mutually
# exclusive API versions on the same file whenever the two diverge.
# skipruntime-ts/examples is unaffected (it doesn't start with "examples/")
# and has no other type-checking coverage, so it stays included.
DIRS=$( jq --raw-output '.workspaces[] | select(startswith("examples/") | not)' package.json )

LINT=""
if [ -z "${SKIP_LINT:-}" ]; then
    LINT=" && npm run lint --if-present"
fi

for dir in $DIRS
do
    if jq -e '.scripts.typecheck' "$dir/package.json" > /dev/null 2>&1; then
        "$SCRIPT_DIR"/cd_sh "$dir" "npm run typecheck$LINT"
    else
        "$SCRIPT_DIR"/cd_sh "$dir" "npm run build --if-present$LINT"
    fi
done
