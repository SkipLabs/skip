#! /bin/bash

set -e
set -x

"$(dirname -- "${BASH_SOURCE[0]}")"/build_docker_images.sh --prod
