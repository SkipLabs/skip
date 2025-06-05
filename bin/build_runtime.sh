#!/bin/bash

# Script to build skipruntime binary release

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_DIR="$SCRIPT_DIR/../"
cd "$REPO_DIR" || exit

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

builder=$(docker buildx create --use)

docker buildx build --platform=linux/arm64,linux/amd64 --output=build --file=skipruntime-ts/Dockerfile .

docker buildx stop "$builder"
docker buildx rm "$builder"

git restore .dockerignore

mv build/linux_arm64/libskipruntime.so build/libskipruntime.so-linux-arm64
mv build/linux_amd64/libskipruntime.so build/libskipruntime.so-linux-amd64
rmdir build/linux_arm64
rmdir build/linux_amd64
