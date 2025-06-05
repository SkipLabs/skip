#! /bin/bash

# Script to build skipruntime binary release
# Usage: build_runtime.sh [arch]
# Example: build_runtime.sh arm64
# Default: arm64,amd64

set -xeuo pipefail

if [ $# -gt 0 ]; then
    ARCH="$1"
else
    ARCH="arm64,amd64"
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_DIR="$SCRIPT_DIR/../"
cd "$REPO_DIR" || exit

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

builder=$(docker buildx create --use)

for arch in ${ARCH//,/ }; do
    {
        docker buildx build \
            --progress=plain \
            --platform="linux/$arch" \
            --file=skipruntime-ts/Dockerfile \
            --output=type=local,dest=build/linux_$arch \
            .
    } > "build_$arch.log" 2>&1 &
done
wait

docker buildx stop "$builder"
docker buildx rm "$builder"

git restore .dockerignore

for arch in ${ARCH//,/ }; do
    echo "=== Build log for linux/$arch ==="
    cat "build_$arch.log"
    rm "build_$arch.log"
    mv "build/linux_$arch/libskipruntime.so" "build/libskipruntime.so-linux-$arch"
    rmdir "build/linux_$arch"
done
