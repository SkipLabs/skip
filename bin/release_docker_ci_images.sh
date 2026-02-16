#!/bin/bash

# Build and push Docker images used in CI.
# Image names are extracted from .circleci/base.yml so the two stay in sync.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."

# Extract unique skiplabs/ image names from CI config
mapfile -t images < <(
    grep -oP 'image:\s+skiplabs/\K[^:\s]+' "$REPO/.circleci/base.yml" | sort -u
)

if [[ ${#images[@]} -eq 0 ]]; then
    echo "Error: no skiplabs/ images found in .circleci/base.yml" >&2
    exit 1
fi

set -x
"$SCRIPT_DIR"/release_docker.sh "${images[@]}"
