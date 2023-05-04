Tests that the mux protocol works correctly. Works using a simple
protocol that MuxTestServer.kt implements.

Run steps:

$ cd $SKFS_REPO/sql/server/skgw
$ gradle --console plain runMuxTestServer &
$ cd $SKFS_REPO
$ make sql/js/dist/skdb-node.js
$ node ./sql/js/tests/mux_integration/muxed_socket_integration_tests.mjs
