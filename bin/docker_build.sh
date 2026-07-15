#!/bin/bash

# Unified Docker image build script
# Usage: docker_build.sh [--push] [--push-only] [--dry-run] [--arch PLATFORMS] [IMAGE...] [-- BAKE_ARGS...]
#
# If hitting space issues, try:
#   docker system df
#   docker system prune
#   docker system prune -a
#   docker volume rm $(docker volume ls -qf dangling=true)
#   docker image rm $(docker image ls -qf dangling=true)
#
# Modes:
#   (default)    Local build, loads into Docker daemon
#   --push       Build and push to Docker Hub
#   --push-only  Push previously built images (from --dry-run) without rebuilding
#   --dry-run    Build without pushing or loading (for testing)
#   --arch PLAT  Override platform(s). Shorthands: amd, amd64, arm, arm64.
#                Comma-separated for multiple. Default: native architecture.
#   -- ARGS      Pass remaining arguments directly to docker buildx bake.
#
# Environment variables:
#   STAGE              Compiler bootstrap stage (default: 0). Passed as STAGE
#                      build arg to the root Dockerfile (skiplang/skip targets).
#   SKIP_CAPACITY      If set, forwarded as SKIP_CAPACITY build arg to targets
#                      that invoke the Skip toolchain at build time, capping
#                      the runtime's mmap reservation. Required on hosts that
#                      enforce virtual memory limits (e.g. gen2 CI builders).
#   DOCKER_DEFAULT_ARCH  Default platform(s) when --arch is not given.
#                        Supports same shorthands as --arch.
#
# Images (if none specified, builds all applicable images):
#   skiplang             Dockerfile --target skiplang
#   skiplang-bin-builder skiplang/Dockerfile
#   skip                 Dockerfile (full)
#   skdb-base            sql/Dockerfile --target base
#   skdb                 sql/Dockerfile
#   server-core          sql/server/core/Dockerfile (local only)
#   skdb-dev-server      sql/server/dev/Dockerfile
#   skipruntime          skipruntime-ts/Dockerfile (libskipruntime.so)
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
ARCH=""
IMAGES=()
EXTRA_BAKE_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --push) PUSH=true; shift ;;
        --push-only) PUSH_ONLY=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --arch) ARCH="${ARCH:+$ARCH,}$2"; shift 2 ;;
        --arch=*) ARCH="${ARCH:+$ARCH,}${1#--arch=}"; shift ;;
        --) shift; EXTRA_BAKE_ARGS+=("$@"); break ;;
        *) IMAGES+=("$1"); shift ;;
    esac
done

# Apply default arch from environment if no --arch was given
if [[ -z "$ARCH" && -n "${DOCKER_DEFAULT_ARCH:-}" ]]; then
    ARCH="$DOCKER_DEFAULT_ARCH"
fi

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

# Validate flag combinations (--push-only overrides --push for caller convenience)
if $PUSH_ONLY; then
    PUSH=false
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
KNOWN_IMAGES=(skiplang skiplang-bin-builder skip skdb-base skdb server-core skdb-dev-server skipruntime)
for img in ${IMAGES[@]+"${IMAGES[@]}"}; do
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
# submodule validation.
if ! $PUSH_ONLY; then
    # shellcheck disable=SC2016  # single quotes intentional: expanded by subshell
    git submodule foreach \
        '[ "$(git rev-parse HEAD)" = "$sha1" ] || \
         (echo "Submodule $name needs update" && exit 1)'
fi

# Prepare the build context exclusions.
#
# The context must exclude everything git would clean (node_modules, target/,
# build/, ...), or every build ships hundreds of MB of local artifacts. This
# used to be done by appending to the tracked .dockerignore and restoring it
# with `git restore` on exit, which meant a killed build (SIGKILL, OOM, a
# stopped container -- none of which run the trap) left the file dirty and
# every later run refusing to start.
#
# Instead, generate untracked sibling files. BuildKit reads
# "<dockerfile>.dockerignore" *instead of* the root .dockerignore -- it is a
# precedence, not a merge -- and resolves it per bake target, so each target
# gets its own copy. Patterns are relative to the context root even when the
# file lives in a subdirectory, so one root-relative body works for all of
# them. The tracked file is never touched: nothing to restore, nothing to
# repair, and a local edit to .dockerignore no longer blocks builds.
#
# The tracked .dockerignore is cat'd in first, so its static exclusions
# (including .git) apply here just as they do for builds that bypass this
# script and read it directly.
#
# '**/*.dockerignore' excludes the generated files from the context, and they
# are filtered out of the body below (git clean lists them once they exist) so
# that the body is identical on every run -- which is what keeps --push-only
# hitting the cache from an earlier --dry-run.
ignore_body=$(
    cat .dockerignore
    printf '%s\n' '**/*.dockerignore'
    # sed -n '...p' (not grep) so a pristine tree, which prints nothing here,
    # does not fail the pipeline under `set -o pipefail`.
    git clean -xd --dry-run | sed -n 's|^Would remove |/|p' | sed '/\.dockerignore$/d'
)

# Ask bake which dockerfiles exist rather than hardcoding them. --print does
# not need a working daemon. stderr is left attached so an HCL error is
# visible instead of being swallowed.
mapfile -t DOCKERFILES < <(
    docker buildx bake -f docker-bake.hcl --print "${KNOWN_IMAGES[@]}" \
        | grep -oP '"dockerfile":\s*"\K[^"]+' | sort -u
)
if [[ ${#DOCKERFILES[@]} -eq 0 ]]; then
    echo "Error: could not enumerate dockerfiles from 'docker buildx bake --print'" >&2
    exit 1
fi
# The optional per-user image below is built directly, not through bake.
if [[ -f "${USER:-}/Dockerfile" ]]; then
    DOCKERFILES+=("${USER:-}/Dockerfile")
fi

for df in "${DOCKERFILES[@]}"; do
    printf '%s\n' "$ignore_body" > "$df.dockerignore.$$.tmp"
    mv -f "$df.dockerignore.$$.tmp" "$df.dockerignore"
done

# Clean up on exit: tear down the buildx builder when appropriate.
#
# The generated *.dockerignore files are deliberately left in place. Removing
# them would race a concurrent build that has generated but not yet read them,
# and several targets `COPY . /skdb`, so a missing exclusion file bakes local
# artifacts into the image rather than merely slowing the build. They are
# gitignored and rewritten on every run.
NAMED_BUILDER="skip-builder"
BUILDX_BUILDER=""
cleanup() {
    if [[ -n "$BUILDX_BUILDER" ]]; then
        docker buildx stop "$BUILDX_BUILDER"
        docker buildx rm "$BUILDX_BUILDER"
    fi
    # Only this process's temp files; concurrent builds own theirs.
    find . -name "*.dockerignore.$$.tmp" -delete 2>/dev/null || true
}
trap cleanup EXIT

# Native architecture for --load fallback
NATIVE_ARCH="linux/$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"

# Set up named builder for multi-arch or push flows
if $PUSH || $PUSH_ONLY || [[ "$ARCH" == *,* ]]; then
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

# Platform — uniform for all modes
if [[ -n "$ARCH" ]]; then
    BAKE_ARGS+=(--set "*.platform=$ARCH")
fi

# Provenance + SBOM attestations, for published images only.
#
# These are restricted to push flows on purpose: they require the
# docker-container driver, which is what the named builder below uses. Local
# builds go to the docker driver via --load, which rejects them outright
# ("Attestation is not supported for the docker driver"), so enabling these
# everywhere would break every local build.
#
# mode=max records the build's sources and materials, which is what lets
# consumers (and Docker Scout) identify the base image rather than guess it.
# It also records build args, so do not pass secrets as build args -- the ones
# used here (STAGE, SKIP_CAPACITY) are not sensitive.
ATTEST_ARGS=(--provenance=mode=max --sbom=true)

# Output mode
if $PUSH_ONLY; then
    # Push existing layers — no --no-cache so BuildKit finds them in the builder
    BAKE_ARGS+=(--push "${ATTEST_ARGS[@]}")
elif $PUSH; then
    BAKE_ARGS+=(--no-cache "${ATTEST_ARGS[@]}")
    if ! $DRY_RUN; then
        BAKE_ARGS+=(--push)
    fi
else
    BAKE_ARGS+=(--no-cache)
    if ! $DRY_RUN && [[ "$ARCH" != *,* ]]; then
        # --load doesn't support multi-platform; handled after bake call
        BAKE_ARGS+=(--load)
    fi
fi

# Pass STAGE build arg to targets using the root Dockerfile
if [[ -n "${STAGE:-}" ]]; then
    BAKE_ARGS+=(--set "skiplang.args.STAGE=$STAGE" --set "skip.args.STAGE=$STAGE")
fi

# Forward SKIP_CAPACITY to targets that invoke the Skip toolchain at build
# time. Required on memory-constrained hosts (e.g. gen2 CircleCI builders)
# where the runtime's 16 GB default mmap would fail.
if [[ -n "${SKIP_CAPACITY:-}" ]]; then
    BAKE_ARGS+=(
        --set "skiplang.args.SKIP_CAPACITY=$SKIP_CAPACITY"
        --set "skip.args.SKIP_CAPACITY=$SKIP_CAPACITY"
        --set "skiplang-bin-builder.args.SKIP_CAPACITY=$SKIP_CAPACITY"
        --set "skipruntime.args.SKIP_CAPACITY=$SKIP_CAPACITY"
    )
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

docker buildx bake "${BAKE_ARGS[@]}" "${BAKE_TARGETS[@]}" ${EXTRA_BAKE_ARGS[@]+"${EXTRA_BAKE_ARGS[@]}"}

# For local multi-arch builds: load native image from cache
if ! $PUSH && ! $PUSH_ONLY && ! $DRY_RUN && [[ "$ARCH" == *,* ]]; then
    docker buildx bake --progress=plain -f docker-bake.hcl \
        --load --set "*.platform=$NATIVE_ARCH" "${BAKE_TARGETS[@]}"
fi

{ set +x; } 2>/dev/null

# Local build: also build user Dockerfile if present
if ! $PUSH && ! $PUSH_ONLY && [[ ${#IMAGES[@]} -eq 0 ]] && [[ -f "$USER/Dockerfile" ]]; then
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
