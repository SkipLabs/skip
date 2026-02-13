#!/bin/bash

# Unified Docker image build script
# Usage: docker_build.sh [--push] [--prod] [IMAGE...]
#
# If hitting space issues, try:
#   docker system df
#   docker system prune
#   docker system prune -a
#   docker volume rm $(docker volume ls -qf dangling=true)
#   docker image rm $(docker image ls -qf dangling=true)
#
# Modes:
#   (default)    Local build, native architecture, no push
#   --push       Multi-arch (amd64+arm64) build and push to Docker Hub
#   --prod       Local build forced to linux/amd64
#
# Images (if none specified, builds all applicable images):
#   skiplang             Dockerfile --target skiplang
#   skiplang-bin-builder skiplang/Dockerfile
#   skip                 Dockerfile (full)
#   skdb-base            sql/Dockerfile --target base
#   skdb                 sql/Dockerfile
#   server-core          sql/server/core/Dockerfile (local --prod only)
#   skdb-dev-server      sql/server/dev/Dockerfile

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."
cd "$REPO"

# The script appends to .dockerignore and restores it with `git restore` on
# exit, which would silently discard uncommitted changes to that file.
if ! git diff --quiet -- .dockerignore || ! git diff --cached --quiet -- .dockerignore; then
    echo "Error: .dockerignore has uncommitted changes" >&2
    echo "       (this script modifies it and restores it with git restore)" >&2
    exit 1
fi

# Parse flags
PUSH=false
PROD=false
IMAGES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --push) PUSH=true; shift ;;
        --prod) PROD=true; shift ;;
        *) IMAGES+=("$1"); shift ;;
    esac
done

# Validate flag combinations
if $PUSH && $PROD; then
    echo "Error: --push and --prod are mutually exclusive" >&2
    exit 1
fi

if $PUSH && [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo "Error: --push requires explicit image names" >&2
    echo "Usage: $0 --push IMAGE [IMAGE...]" >&2
    exit 1
fi

# Validate image names
KNOWN_IMAGES=(skiplang skiplang-bin-builder skip skdb-base skdb server-core skdb-dev-server)
for img in "${IMAGES[@]}"; do
    name="${img%%:*}"
    found=false
    for known in "${KNOWN_IMAGES[@]}"; do
        [[ "$name" = "$known" ]] && { found=true; break; }
    done
    if ! $found; then
        echo "Error: unknown image '$img'" >&2
        echo "Known images: ${KNOWN_IMAGES[*]}" >&2
        exit 1
    fi
done

# Validate submodules
# shellcheck disable=SC2016  # single quotes intentional: expanded by subshell
git submodule foreach \
    '[ "$(git rev-parse HEAD)" = "$sha1" ] || \
     (echo "Submodule $name needs update" && exit 1)'

# Prepare .dockerignore
git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

# Clean up on exit: restore .dockerignore and (if --push) tear down the
# buildx builder.  A single cleanup function avoids the fragile pattern of
# one trap overwriting another.
BUILDX_BUILDER=""
cleanup() {
    if [[ -n "$BUILDX_BUILDER" ]]; then
        docker buildx stop "$BUILDX_BUILDER"
        docker buildx rm "$BUILDX_BUILDER"
    fi
    git restore .dockerignore
}
trap cleanup EXIT

# Set up build command based on mode
if $PUSH; then
    BUILDX_BUILDER=$(docker buildx create --use)

    dockerbuild() {
        docker buildx build \
            . \
            --no-cache \
            --progress=plain \
            --platform linux/amd64,linux/arm64 \
            --push \
            "$@"
    }
else
    PLATFORM_ARGS=()
    if $PROD; then
        PLATFORM_ARGS=(--platform=linux/amd64)
    fi

    dockerbuild() {
        docker build . --no-cache --progress=plain "${PLATFORM_ARGS[@]}" "$@"
    }
fi

# Helper to check if an image should be built
should_build() {
    local name="$1"
    # If no images specified, build all
    [[ ${#IMAGES[@]} -eq 0 ]] && return 0
    # Check if this image is in the list
    for img in "${IMAGES[@]}"; do
        [[ "${img%:latest}" = "$name" || "$img" = "$name:"* ]] && return 0
    done
    return 1
}

# Collect extra tags for skdb-dev-server (supports :latest and :quickstart)
DEV_SERVER_TAGS=()
for img in "${IMAGES[@]}"; do
    case "$img" in
        skdb-dev-server|skdb-dev-server:latest)
            DEV_SERVER_TAGS+=(--tag skiplabs/skdb-dev-server:latest) ;;
        skdb-dev-server:quickstart)
            DEV_SERVER_TAGS+=(--tag skiplabs/skdb-dev-server:quickstart) ;;
    esac
done
# Default to :latest if building all
if [[ ${#IMAGES[@]} -eq 0 ]]; then
    DEV_SERVER_TAGS=(--tag skiplabs/skdb-dev-server:latest)
fi

set -x

# Build images
if should_build skiplang; then
    dockerbuild --file Dockerfile --target skiplang --tag skiplabs/skiplang:latest
fi

if should_build skiplang-bin-builder; then
    dockerbuild --file skiplang/Dockerfile --tag skiplabs/skiplang-bin-builder:latest
fi

if should_build skip; then
    dockerbuild --file Dockerfile --tag skiplabs/skip:latest
fi

if should_build skdb-base; then
    dockerbuild --file sql/Dockerfile --target base --tag skiplabs/skdb-base:latest
fi

if should_build skdb; then
    dockerbuild --file sql/Dockerfile --tag skiplabs/skdb:latest
fi

if should_build server-core; then
    if $PUSH; then
        echo "Warning: server-core is not published, skipping" >&2
    else
        dockerbuild --file sql/server/core/Dockerfile --tag skiplabs/server-core:latest
    fi
fi

if should_build skdb-dev-server; then
    if $PUSH; then
        dockerbuild --file sql/server/dev/Dockerfile "${DEV_SERVER_TAGS[@]}"
    else
        dockerbuild --file sql/server/dev/Dockerfile --tag skiplabs/skdb-dev-server:latest
    fi
fi

# Local build: also build user Dockerfile if present
if ! $PUSH && ! $PROD && [[ ${#IMAGES[@]} -eq 0 ]] && [[ -f "$USER/Dockerfile" ]]; then
    dockerbuild --file "$USER/Dockerfile" --tag "$USER-skdb"
fi

if ! $PUSH; then
    echo "disk usage:"
    docker system df
    echo "images:"
    docker images
fi
