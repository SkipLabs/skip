#!/bin/bash

# Unified Docker image build script
# Usage: docker_build.sh [--push] [--push-only] [--prod] [--dry-run] [--arch PLATFORMS] [IMAGE...]
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
#   --push-only  Push previously built images (from --push --dry-run) without rebuilding
#   --prod       Local build forced to linux/amd64
#   --dry-run    Modifier: build without actually pushing/loading (for testing)
#   --arch PLAT  Override platform(s). Shorthands: amd, amd64, arm, arm64.
#                Comma-separated for multiple. Default depends on mode.
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

# Parse flags
PUSH=false
PUSH_ONLY=false
DRY_RUN=false
PROD=false
ARCH=""
IMAGES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --push) PUSH=true; shift ;;
        --push-only) PUSH_ONLY=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --prod) PROD=true; shift ;;
        --arch) ARCH="${ARCH:+$ARCH,}$2"; shift 2 ;;
        --arch=*) ARCH="${ARCH:+$ARCH,}${1#--arch=}"; shift ;;
        *) IMAGES+=("$1"); shift ;;
    esac
done

# Normalize --arch shorthands
if [[ -n "$ARCH" ]]; then
    normalized=()
    IFS=',' read -ra parts <<< "$ARCH"
    for p in "${parts[@]}"; do
        case "$p" in
            amd|amd64)       normalized+=(linux/amd64) ;;
            arm|arm64)       normalized+=(linux/arm64) ;;
            linux/amd64|linux/arm64) normalized+=("$p") ;;
            *) echo "Error: unknown architecture '$p'" >&2; exit 1 ;;
        esac
    done
    ARCH=$(IFS=,; echo "${normalized[*]}")
fi

# Validate flag combinations
if $PUSH && $PROD; then
    echo "Error: --push and --prod are mutually exclusive" >&2
    exit 1
fi
if $PUSH_ONLY && $PUSH; then
    echo "Error: --push-only and --push are mutually exclusive" >&2
    exit 1
fi
if $PUSH_ONLY && $PROD; then
    echo "Error: --push-only and --prod are mutually exclusive" >&2
    exit 1
fi
if $PUSH_ONLY && $DRY_RUN; then
    echo "Error: --push-only and --dry-run are mutually exclusive" >&2
    exit 1
fi

if ($PUSH || $PUSH_ONLY) && [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo "Error: --push/--push-only requires explicit image names" >&2
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

# --push-only reuses an existing builder and doesn't build, so skip
# submodule validation and .dockerignore manipulation.
if ! $PUSH_ONLY; then
    # The script appends to .dockerignore and restores it with `git restore`
    # on exit, which would silently discard uncommitted changes to that file.
    if ! git diff --quiet -- .dockerignore || ! git diff --cached --quiet -- .dockerignore; then
        echo "Error: .dockerignore has uncommitted changes" >&2
        echo "       (this script modifies it and restores it with git restore)" >&2
        exit 1
    fi

    # Validate submodules
    # shellcheck disable=SC2016  # single quotes intentional: expanded by subshell
    git submodule foreach \
        '[ "$(git rev-parse HEAD)" = "$sha1" ] || \
         (echo "Submodule $name needs update" && exit 1)'

    # Prepare .dockerignore
    git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
    echo ".git" >> .dockerignore
fi

# Clean up on exit: restore .dockerignore (unless --push-only) and tear down
# the buildx builder when appropriate.
NAMED_BUILDER="skip-builder"
BUILDX_BUILDER=""
cleanup() {
    if [[ -n "$BUILDX_BUILDER" ]]; then
        docker buildx stop "$BUILDX_BUILDER"
        docker buildx rm "$BUILDX_BUILDER"
    fi
    if ! $PUSH_ONLY; then
        git restore .dockerignore
    fi
}
trap cleanup EXIT

# Set up named builder for --push flows (persists between dry-run and push-only)
if $PUSH || $PUSH_ONLY; then
    if ! docker buildx inspect "$NAMED_BUILDER" &>/dev/null; then
        if $PUSH_ONLY; then
            echo "Error: no builder '$NAMED_BUILDER' found. Run --push --dry-run first." >&2
            exit 1
        fi
        docker buildx create --name "$NAMED_BUILDER"
    fi
    docker buildx use "$NAMED_BUILDER"
    # Clean up builder on exit unless this is a dry-run (keep for later --push-only)
    if ! $DRY_RUN; then
        BUILDX_BUILDER="$NAMED_BUILDER"
    fi
fi

# Assemble bake arguments
BAKE_ARGS=(--progress=plain -f docker-bake.hcl)

if $PUSH || $PUSH_ONLY; then
    BAKE_ARGS+=(--set "*.platform=${ARCH:-linux/amd64,linux/arm64}")
fi

if $PUSH_ONLY; then
    # Push existing layers — no --no-cache so BuildKit finds them in the builder
    BAKE_ARGS+=(--push)
elif $PUSH; then
    BAKE_ARGS+=(--no-cache)
    if ! $DRY_RUN; then
        BAKE_ARGS+=(--push)
    fi
elif $PROD; then
    BAKE_ARGS+=(--no-cache --load --set "*.platform=${ARCH:-linux/amd64}")
else
    BAKE_ARGS+=(--no-cache)
    if [[ -n "$ARCH" ]]; then
        BAKE_ARGS+=(--set "*.platform=$ARCH")
    fi
    if ! $DRY_RUN; then
        BAKE_ARGS+=(--load)
    fi
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
                if ($PUSH || $PUSH_ONLY) && [[ "$target" = "server-core" ]]; then
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
    if $PUSH || $PUSH_ONLY; then
        BAKE_TARGETS=(default)
    else
        BAKE_TARGETS=(local)
    fi
fi

set -x

docker buildx bake "${BAKE_ARGS[@]}" "${BAKE_TARGETS[@]}"

{ set +x; } 2>/dev/null

# Local build: also build user Dockerfile if present
if ! $PUSH && ! $PUSH_ONLY && ! $PROD && [[ ${#IMAGES[@]} -eq 0 ]] && [[ -f "$USER/Dockerfile" ]]; then
    set -x
    docker build . --no-cache --progress=plain --file "$USER/Dockerfile" --tag "$USER-skdb"
    { set +x; } 2>/dev/null
fi

if ! $PUSH && ! $PUSH_ONLY; then
    echo "disk usage:"
    docker system df
    echo "images:"
    docker images
fi
