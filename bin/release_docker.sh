#!/bin/bash

# Build and push Docker images to Docker Hub (multi-arch)
# Usage: release_docker.sh [--push-only] [--dry-run] IMAGE [IMAGE...]

set -euo pipefail

SCRIPT_DIR=$(dirname -- "${BASH_SOURCE[0]}")

# Default to both architectures (override with --arch)
has_arch=false
for arg in "$@"; do
    [[ "$arg" = "--arch" || "$arg" == --arch=* ]] && has_arch=true
done
if ! $has_arch; then
    set -- --arch amd64,arm64 "$@"
fi

# --push-only replaces --push (they are mutually exclusive in docker_build.sh)
for arg in "$@"; do
    if [[ "$arg" = "--push-only" ]]; then
        exec "$SCRIPT_DIR"/docker_build.sh "$@"
    fi
done

exec "$SCRIPT_DIR"/docker_build.sh --push "$@"
