Manual test that the server interface works correctly:

Run steps:

$ cd $SKFS_REPO/
$ make npm
$ ./sql/js/tests/test_server_api/run.sh


Manual test that the production server is working correctly:

$ make npm
$ ssh $SERVER
$ sudo rm -f /var/db/test.db
$ ./sql/js/tests/test_server_api/run.sh wss://api-beta.skiplabs.io
