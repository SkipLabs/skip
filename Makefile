# this builds the aritfacts of this repository, orchestrating the
# various build systems

all: npm build/skdb build/init.sql

################################################################################
# skdb wasm + js client
################################################################################

npm: sql/js/skdb.wasm sql/js/dist/skdb.js sql/js/dist/skdb-node.js sql/js/dist/skdb-cli.js

sql/target/wasm32-unknown-unknown/skdb.wasm: sql/src/* skfs/src/*
	cd sql && skargo build --target wasm32-unknown-unknown

sql/js/skdb.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	cp $^ $@

sql/js/node_modules: sql/node/package.json
	cd sql/node && npm install

sql/js/dist/%.js: sql/js/src/%.ts
	cd sql/js && tsc --build tsconfig.json --pretty false

sql/js/dist/%.js: sql/js/src/%.js
	cd sql/js && tsc --build tsconfig.json --pretty false

sql/js/dist/skdb-node.js: sql/js/dist/skdb.js sql/js/src/node_header.js
	mkdir -p sql/js/dist
	cat sql/js/src/node_header.js sql/js/dist/skdb.js \
	| sed 's/let wasmModule =.*//g' \
	| sed 's/let wasmBuffer =.*/let wasmBuffer = fs.readFileSync("skdb.wasm");/g'> $@

################################################################################
# skdb native binary
################################################################################

sql/target/skdb: sql/src/* skfs/src/*
	cd sql && skargo build

# TODO: keeping this for now as nearly all test scripts refer to build/skdb
build/skdb: sql/target/skdb
	mkdir -p build
	cp $^ $@

################################################################################
# skdb server
################################################################################

# TODO: add server artifact build step here and package in to a docker image

build/init.sql: sql/privacy/init.sql
	mkdir -p build
	cp $^ $@

################################################################################
# dev workflow orchestration
################################################################################

.PHONY: clean
clean:
	rm -Rf build

.PHONY: test
test: sql/js/dist/skdb-node.js build/skdb
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

# useful for testing in a browser
build/index.html: sql/js/index.html
	mkdir -p build
	cp $^ $@
