Tests that the mux protocol works correctly. Works using a simple
protocol that MuxTestServer.kt implements.

Run steps:

$ cd $SKFS_REPO/sql/server/skgw
$ gradle --console plain runMuxTestServer &
$ cd $SKFS_REPO
$ make build/skdb_node.js
$ ./sql/node/run_node.sh ./sql/node/tests/mux_integration/muxed_socket_integration_tests.mjs
