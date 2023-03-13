.PHONY: default

default: sql/js/skdb.wasm build/skdb build/skdb.js build/skdb_node.js build/index.html build/init.sql

npm: sql/js/package.json sql/js/skdb.wasm sql/js/src/skdb.ts

sql/target/skdb: sql/src/* skfs/src/*
	cd sql && skargo build

sql/target/wasm32-unknown-unknown/skdb.wasm: sql/src/* skfs/src/*
	cd sql && skargo build --target wasm32-unknown-unknown

build/skdb: sql/target/skdb
	mkdir -p build
	cp $^ $@

build/init.sql: sql/privacy/init.sql
	cp $^ $@

sql/js/skdb.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	cp $^ $@

build/skdb.wasm: sql/js/skdb.wasm
	mkdir -p build
	cp $^ $@

build/skdb_node.js: sql/node/src/node_header.js build/skdb.js build/skdb.wasm build/node_modules
	mkdir -p build
	cat sql/node/src/node_header.js build/skdb.js \
	| sed 's/^export //g' \
        | sed 's/let wasmModule =.*//g' \
        | sed 's/let wasmBuffer =.*/let wasmBuffer = fs.readFileSync("skdb.wasm");/g'> $@
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

build/skdb_cli.mjs: build/skdb_node.js sql/node/src/skdb_cli.mjs build/node_modules
	cp sql/node/src/skdb_cli.mjs build/skdb_cli.mjs


.PHONY: clean
clean:
	rm -Rf build

.PHONY: test
test: build/skdb_node.js build/skdb
	./run_all_tests.sh

.PHONY: run-server

run-server: build/skdb build/init.sql
	./sql/server/deploy/start.sh --DANGEROUS-no-encryption

.PHONY: run-chaos
run-chaos: build/skdb sql/js/skdb.wasm build/skdb.js build/index.html
	./sql/server/deploy/chaos.sh

.PHONY: test-soak
test-soak: build/skdb build/skdb_node.js build/node_modules
	./sql/server/test/test_soak.sh

build/index.html: sql/js/index.html
	cp $^ $@
