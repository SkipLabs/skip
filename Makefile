.PHONY: default
default: build/out32.wasm build/skdb build/skdb.js build/skdb_node.js build/index.html build/init.sql

sql/target/skdb: sql/src/* skfs/src/*
	cd sql && skargo build

sql/target/wasm32-unknown-unknown/skdb.wasm: sql/src/* skfs/src/*
	cd sql && skargo build --target wasm32-unknown-unknown

build/skdb: sql/target/skdb
	mkdir -p build
	cp $^ $@

build/init.sql: sql/privacy/init.sql
	cp $^ $@

build/out32.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	mkdir -p build
	cp $^ $@

sql/js/dist/out32.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	mkdir -p build
	cp $^ $@

# JS version of SKDB

build/skdb_node.js: sql/node/src/node_header.js build/skdb.js build/out32.wasm
	mkdir -p build
	cat sql/node/src/node_header.js build/skdb.js \
	| sed 's/^export //g' \
        | sed 's/let wasmModule =.*//g' \
        | sed 's/let wasmBuffer =.*/let wasmBuffer = fs.readFileSync("out32.wasm");/g'> $@
	echo >> $@
	echo "module.exports = SKDB;" >> $@

build/skdb.js: sql/js/src/skdb.ts
	mkdir -p build
	cd sql/js && tsc --build tsconfig.json --pretty false
	cp sql/js/dist/skdb.js build/skdb.js

sql/node/node_modules: sql/node/package.json
	cd sql/node && npm install

build/node_modules: sql/node/node_modules
	cp -R $^ $@

build/index.html: sql/js/index.html build/skdb.js
	mkdir -p build
	cp sql/js/index.html $@


.PHONY: clean
clean:
	rm -Rf build

.PHONY: test
test: build/skdb_node.js build/skdb
	./run_all_tests.sh

.PHONY: run-server
run-server: build/skdb build/out32.wasm build/skdb.js build/index.html build/init.sql
	./sql/server/deploy/start.sh --DANGEROUS-no-encryption

.PHONY: run-chaos
run-chaos: build/skdb build/out32.wasm build/skdb.js build/index.html
	./sql/server/deploy/chaos.sh

.PHONY: node-repl
node-repl: build/skdb_node.js build/node_modules
	cd build && ../sql/node/run_node.sh

.PHONY: test-soak
test-soak: build/skdb build/skdb_node.js build/node_modules
	./sql/server/test/test_soak.sh
