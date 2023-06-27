#!/bin/bash

#
# start the server
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "/root/.sdkman/bin/sdkman-init.sh"

cd "$SCRIPT_DIR/../skgw" || exit 1

mkdir -p /var/db || exit 1

if [[ $# -gt 0 ]]; then
    exec gradle --console plain run "--args=$*"
else
    exec gradle --console plain run
fi
