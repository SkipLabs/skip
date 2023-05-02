Manual test that the server interface works correctly:

Run steps:

$ cd $SKFS_REPO/
$ make run-server &
$ ./sql/js/tests/test_server_api/run.sh '<B64 KEY FOR skdb_service_mgmt>'


Manual test that the production server is working correctly:

$ ssh $SERVER
$ sudo rm -f /var/db/test.db
$ ./sql/js/tests/test_server_api/run.sh '<B64 KEY FOR skdb_service_mgmt>' wss://api-beta.skiplabs.io
