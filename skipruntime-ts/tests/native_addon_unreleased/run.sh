#! /bin/bash

# Test script for native addon using current sources
# Usage: run.sh [arch]
# Example: run.sh arm64,amd64
# Default: current Docker architecture

set -xeuo pipefail

if [ $# -gt 0 ]; then
    ARCH="$1"
else
    ARCH=$(docker version --format '{{.Server.Arch}}')
fi

# build and copy the runtime
../../../bin/build_runtime.sh "$ARCH"
VERSION=$(jq --raw-output .version ../../metapackage/package.json)
mkdir -p build/v"$VERSION"
cp ../../../build/libskipruntime.so-* build/v"$VERSION"

# copy the install script
cp ../../../bin/install_runtime.sh build/

# build and pack npm packages
make -C ../.. install
for pkg in core addon; do
    (cd ../../"$pkg" && npm run build && npm pack)
    mv ../../"$pkg"/skipruntime-*.tgz build/skipruntime-${pkg/addon/native}.tgz
done

# build, run, and remove the test container
for arch in ${ARCH//,/ }; do
    echo "Testing linux/$arch..."
    TEMP_FILE=$(mktemp)
    docker build --platform="linux/$arch" --iidfile "$TEMP_FILE" .
    docker run --rm "$(cat "$TEMP_FILE")"
    rm "$TEMP_FILE"
done
