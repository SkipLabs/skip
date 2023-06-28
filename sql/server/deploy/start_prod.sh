#!/bin/bash

#
# start the server
#

# should not be needed as container should already have this mounted
# with skdb_service_mgmt.db inside. but we create anyway in case this
# is a cold start
mkdir -p /var/db || exit 1

java -jar /skfs/build/server.jar "$@"
