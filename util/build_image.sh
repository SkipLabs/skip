#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

set -e
set -x

cd $REPO

git clean -xdn | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

dockerbuild () {
    docker build . --no-cache --progress=plain --tag $1 --file $2/Dockerfile
}

dockerbuild skiplabs/skdb-base .
dockerbuild skgw sql/server/skgw
dockerbuild skiplabs/skdb-dev-server sql/server/dev
[[ -f $USER/Dockerfile ]] && dockerbuild $USER-skfs $USER

git restore .dockerignore

echo disk usage:
docker system df

echo images:
docker images
