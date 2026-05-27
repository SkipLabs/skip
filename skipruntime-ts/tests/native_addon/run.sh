#! /bin/bash

set -euo pipefail

# build, run, and remove the test container
TEMP_FILE=$(mktemp)
docker build --iidfile "$TEMP_FILE" .
docker run --rm -e SKIP_CAPACITY "$(cat "$TEMP_FILE")"
rm "$TEMP_FILE"
