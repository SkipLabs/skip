#!/bin/bash

# Build all Docker images locally
# Usage: build_docker_images.sh [--arch PLATFORMS]

set -euo pipefail

exec "$(dirname -- "${BASH_SOURCE[0]}")"/docker_build.sh "$@"
