#!/bin/bash

# Build and push the Docker images we publish, taken from the "ci" group in
# docker-bake.hcl.
#
# .github/workflows/docker-publish.yml publishes the same group automatically,
# and is the normal path. This is the manual escape hatch, for when the workflow
# is broken or unavailable.
#
# Defaults to amd64,arm64 (matching release_docker.sh); use --arch to
# override (e.g. --arch amd64).
# Usage: release_docker_ci_images.sh [--dry-run] [--arch PLATFORMS]

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."

export DOCKER_DEFAULT_ARCH="${DOCKER_DEFAULT_ARCH:-amd64,arm64}"

"$SCRIPT_DIR"/check_ci_images.sh

mapfile -t images < <(
    docker buildx bake -f "$REPO/docker-bake.hcl" --print ci |
        jq -r '.group.ci.targets[]' | sort -u
)

if [[ ${#images[@]} -eq 0 ]]; then
    echo 'Error: bake group "ci" is empty' >&2
    exit 1
fi

set -x
"$SCRIPT_DIR"/release_docker.sh "$@" "${images[@]}"
