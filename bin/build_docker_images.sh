#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

set -e
set -x

if [ "$1" = "--prod" ]; then
  DOCKERBUILD_EXTRA=("--platform=linux/amd64")
  PROD=true
else
  DOCKERBUILD_EXTRA=()
  PROD=false
fi

cd "$REPO"

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

dockerbuild () {
    local tag="$1"
    local file="$2/Dockerfile"
    shift 2
    docker build . --no-cache --progress=plain --tag "$tag" --file "$file" "$@"
}

dockerbuild skiplabs/skdb-base . "${DOCKERBUILD_EXTRA[@]}"
dockerbuild skiplabs/skdb sql "${DOCKERBUILD_EXTRA[@]}"
if $PROD; then
  dockerbuild skiplabs/server-core sql/server/core
else
  dockerbuild skiplabs/skdb-dev-server sql/server/dev
  [[ -f $USER/Dockerfile ]] && dockerbuild "$USER-skdb" "$USER"
fi

git restore .dockerignore

echo disk usage:
docker system df

echo images:
docker images
