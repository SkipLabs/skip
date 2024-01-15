#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

set -e
set -x

cd $REPO

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

dockerbuild () {
    docker build . --no-cache --progress=plain --tag "$1" --file "$2/Dockerfile" $3
}

dockerbuild skiplabs/skdb-base . --platform=linux/amd64
dockerbuild skiplabs/skdb sql --platform=linux/amd64
dockerbuild skiplabs/server-core sql/server/core

git restore .dockerignore

echo disk usage:
docker system df

echo images:
docker images
