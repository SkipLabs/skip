#!/bin/bash

# Unified Docker image build script
# Usage: docker_build.sh [--push] [--prod] [--dry-run] [IMAGE...]
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
#   --dry-run    Modifier: build without actually pushing/loading (for testing)
#
# Images (if none specified, builds all applicable images):
#   skiplang             Dockerfile --target skiplang
#   skiplang-bin-builder skiplang/Dockerfile
#   skip                 Dockerfile (full)
#   skdb-base            sql/Dockerfile --target base
#   skdb                 sql/Dockerfile
#   server-core          sql/server/core/Dockerfile (local/prod only)
#   skdb-dev-server      sql/server/dev/Dockerfile
#
# Build definitions live in docker-bake.hcl.  Independent targets are built
# in parallel automatically by BuildKit.

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
DRY_RUN=false
PROD=false
IMAGES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --push) PUSH=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
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

# Assemble bake arguments
BAKE_ARGS=(--no-cache --progress=plain -f docker-bake.hcl)

if $PUSH; then
    BUILDX_BUILDER=$(docker buildx create --use)
    BAKE_ARGS+=(--set '*.platform=linux/amd64,linux/arm64')
    if ! $DRY_RUN; then
        BAKE_ARGS+=(--push)
    fi
elif $PROD; then
    BAKE_ARGS+=(--load --set '*.platform=linux/amd64')
elif ! $DRY_RUN; then
    BAKE_ARGS+=(--load)
fi

# Determine which bake targets to build
BAKE_TARGETS=()

if [[ ${#IMAGES[@]} -gt 0 ]]; then
    for img in "${IMAGES[@]}"; do
        case "$img" in
            skdb-dev-server:quickstart)
                BAKE_ARGS+=(--set "skdb-dev-server.tags=skiplabs/skdb-dev-server:quickstart")
                BAKE_TARGETS+=(skdb-dev-server)
                ;;
            *)
                target="${img%%:*}"
                if $PUSH && [[ "$target" = "server-core" ]]; then
                    echo "Warning: server-core is not published, skipping" >&2
                    continue
                fi
                BAKE_TARGETS+=("$target")
                ;;
        esac
    done
    if [[ ${#BAKE_TARGETS[@]} -eq 0 ]]; then
        echo "Nothing to build." >&2
        exit 0
    fi
else
    # No images specified: build the appropriate group
    if $PUSH; then
        BAKE_TARGETS=(default)
    else
        BAKE_TARGETS=(local)
    fi
fi

set -x

docker buildx bake "${BAKE_ARGS[@]}" "${BAKE_TARGETS[@]}"

{ set +x; } 2>/dev/null

# Local build: also build user Dockerfile if present
if ! $PUSH && ! $PROD && [[ ${#IMAGES[@]} -eq 0 ]] && [[ -f "$USER/Dockerfile" ]]; then
    set -x
    docker build . --no-cache --progress=plain --file "$USER/Dockerfile" --tag "$USER-skdb"
    { set +x; } 2>/dev/null
fi

if ! $PUSH; then
    echo "disk usage:"
    docker system df
    echo "images:"
    docker images
fi
