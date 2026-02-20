#!/bin/bash

# Build skipruntime binary release (libskipruntime.so)
# Usage: build_runtime.sh [arch]
# Example: build_runtime.sh arm64
# Default: arm64,amd64

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ARCH="${1:-arm64,amd64}"

for arch in ${ARCH//,/ }; do
    "$SCRIPT_DIR"/docker_build.sh --arch "$arch" skipruntime \
        -- --set "skipruntime.output=type=local,dest=build/linux_$arch"
done

for arch in ${ARCH//,/ }; do
    mv "build/linux_$arch/libskipruntime.so" "build/libskipruntime.so-linux-$arch"
    rmdir "build/linux_$arch"
done
