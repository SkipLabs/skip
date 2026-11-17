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
VERSION=$(jq --raw-output .version ../../addon/package.json)
mkdir -p build/v"$VERSION"
cp ../../../build/libskipruntime.so-* build/v"$VERSION"

# copy the install script
cp ../../../bin/install_runtime.sh build/

# build and pack npm packages
# install-all-no-native: the test container below rebuilds the addon itself
# (npm install @skipruntime/native runs node-gyp inside the image) against the
# Docker-built .so, so a local libskipruntime.so / node-gyp build is never
# used -- --ignore-scripts skips it, which also keeps this step usable in the
# parallel native-addon-unreleased CI job without a host native build.
make -C ../.. install-all-no-native
for pkg in core addon; do
    (cd ../../"$pkg" && npm run build && npm pack)
    mv ../../"$pkg"/skipruntime-*.tgz build/skipruntime-${pkg/addon/native}.tgz
done

# build, run, and remove the test container
for arch in ${ARCH//,/ }; do
    echo "Testing linux/$arch..."
    TEMP_FILE=$(mktemp)
    docker build --platform="linux/$arch" --iidfile "$TEMP_FILE" .
    docker run --rm -e SKIP_CAPACITY "$(cat "$TEMP_FILE")"
    rm "$TEMP_FILE"
done
