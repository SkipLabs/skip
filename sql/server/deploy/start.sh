#!/bin/bash

#
# start the server
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "/root/.sdkman/bin/sdkman-init.sh"
cd $SCRIPT_DIR/../skgw && gradle --console plain run
