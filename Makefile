# this builds the artifacts of this repository, orchestrating the
# various build systems

all: npm build/skdb build/init.sql

PLAYWRIGHT_REPORTER?="line"

################################################################################
# skdb wasm + js client
################################################################################

npm: sql/js/dist/skdb.wasm sql/js/dist/skdb.js sql/js/dist/skdb-node.js sql/js/dist/skdb-cli.js

sql/target/wasm32-unknown-unknown/skdb.wasm: sql/src/* skfs/src/*
	cd sql && skargo build --target wasm32-unknown-unknown

sql/js/dist/skdb.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	mkdir -p sql/js/dist
	cp $^ $@

sql/js/node_modules: sql/js/package.json
	cd sql/js && npm install

sql/js/dist/%.js: sql/js/src/%.ts
	cd sql/js && tsc --build tsconfig.json --pretty false

sql/js/dist/%.js: sql/js/src/%.js
	cd sql/js && tsc --build tsconfig.json --pretty false

sql/js/dist/skdb-node.js: sql/js/dist/skdb.js sql/js/src/node_header.js
	mkdir -p sql/js/dist
	cat sql/js/src/node_header.js sql/js/dist/skdb.js \
	| sed 's|let wasmModule =.*||g' \
	| sed 's|let wasmBuffer =.*|let wasmBuffer = fs.readFileSync(new URL("./skdb.wasm", import.meta.url));|g'> $@

sql/js/dist/index.html: sql/js/tests/index.html
	mkdir -p sql/js/dist
	cp $^ $@

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
	find . -name 'Skargo.toml' -print0 | sed 's|Skargo.toml|target|g' | xargs -0 rm -rf

.PHONY: fmt
fmt:
	find . -path ./compiler/tests -not -prune -or -name '*'.sk -exec sh -c 'echo {}; skfmt -i {}' \;

.PHONY: test
test: native-test wasm-test

.PHONY: native-test
native-test: build/skdb
	cd sql/ && ./test_sql.sh

.PHONY: wasm-test
wasm-test: npm sql/js/node_modules sql/js/dist/index.html
	cd sql/js && npx playwright install && npx playwright test --reporter=$(PLAYWRIGHT_REPORTER)

.PHONY: run-server
run-server: build/skdb build/init.sql
	./sql/server/deploy/start.sh --DANGEROUS-no-encryption

.PHONY: run-chaos
run-chaos: build/skdb
	./sql/server/deploy/chaos.sh

.PHONY: test-soak
test-soak: build/skdb build/init.sql npm
	./sql/server/test/test_soak.sh

# useful for testing in a browser
build/index.html: sql/js/index.html
	mkdir -p build
	cp $^ $@
