#! /bin/bash

set -e
set -x

tags=()

read -r -p "Release 'latest' version? [y/N] " latest
if [[ "$latest" =~ ^([yY]|[yY][eE][sS])$ ]]; then
    tags+=(skdb-dev-server:latest)
fi

read -r -p "Release 'quickstart' version? [y/N] " quickstart
if [[ "$quickstart" =~ ^([yY]|[yY][eE][sS])$ ]]; then
    tags+=(skdb-dev-server:quickstart)
fi

if [[ -z "${tags[*]}" ]]; then
    echo Nothing to do, exiting.
    exit 0
fi

"$(dirname -- "${BASH_SOURCE[0]}")"/release_docker.sh "${tags[@]}"
