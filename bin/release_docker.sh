#!/bin/bash

# Build and push Docker images to Docker Hub (multi-arch)
# Usage: release_docker.sh [--push-only] [--dry-run] IMAGE [IMAGE...]

set -euo pipefail

SCRIPT_DIR=$(dirname -- "${BASH_SOURCE[0]}")

export DOCKER_DEFAULT_ARCH="${DOCKER_DEFAULT_ARCH:-amd64,arm64}"

# --push-only replaces --push (they are mutually exclusive in docker_build.sh)
for arg in "$@"; do
    if [[ "$arg" = "--push-only" ]]; then
        exec "$SCRIPT_DIR"/docker_build.sh "$@"
    fi
done

exec "$SCRIPT_DIR"/docker_build.sh --push "$@"
