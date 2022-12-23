
default: ../../build/skdb_node.js

../../build/skdb_node.js: src/node_header.js ../../build/skdb.js
	mkdir -p ../../build
	cat src/node_header.js ../../build/skdb.js > $@

../../build/skdb.js: src/skdb.ts
	mkdir -p ../../build
	tsc --build tsconfig.json --pretty false

