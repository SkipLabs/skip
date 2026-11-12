#!/bin/bash

# Build skipruntime binary release (libskipruntime.so)
# Usage: build_runtime.sh [arch]
# Example: build_runtime.sh arm64
# Default: arm64,amd64

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPO="$SCRIPT_DIR/.."
cd "$REPO"

ARCH="${1:-arm64,amd64}"

for arch in ${ARCH//,/ }; do
    out="build/libskipruntime.so-linux-$arch"
    # SKIP_NATIVE_BUILDS_IF_PRESENT (set by the CircleCI skipruntime job after
    # restoring the docker-so cache, keyed on these build inputs by
    # bin/native_artifacts_cache_key.sh) skips the Docker build when the
    # artifact is already there; on a cache miss the build runs unchanged.
    if [ -n "${SKIP_NATIVE_BUILDS_IF_PRESENT:-}" ] && [ -f "$out" ]; then
        echo "$out present; skipping Docker build (SKIP_NATIVE_BUILDS_IF_PRESENT)"
        continue
    fi
    "$SCRIPT_DIR"/docker_build.sh --arch "$arch" skipruntime \
        -- --set "skipruntime.output=type=local,dest=build/linux_$arch"
    mv "build/linux_$arch/libskipruntime.so" "$out"
    rmdir "build/linux_$arch"
done
