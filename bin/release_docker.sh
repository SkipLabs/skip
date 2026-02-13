#!/bin/bash

# Build and push Docker images to Docker Hub (multi-arch)
# Usage: release_docker.sh IMAGE [IMAGE...]

set -euo pipefail

exec "$(dirname -- "${BASH_SOURCE[0]}")"/docker_build.sh --push "$@"
