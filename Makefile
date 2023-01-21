.PHONY: default
default: build/out32.wasm build/skdb build/skdb.js build/skdb_node.js build/index.html

.PHONY: test
test: sql/js/dist/out32.wasm build/skdb
	./run_all_tests.sh

sql/target/skdb:
	cd sql && skargo build

sql/target/wasm32-unknown-unknown/skdb.wasm:
	cd sql && skargo build --target wasm32-unknown-unknown

build/skdb: sql/target/skdb
	mkdir -p build
	cp $^ $@

build/out32.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	mkdir -p build
	cp $^ $@

sql/js/dist/out32.wasm: sql/target/wasm32-unknown-unknown/skdb.wasm
	mkdir -p build
	cp $^ $@

# JS version of SKDB

build/skdb_node.js: sql/node/src/node_header.js build/skdb.js
	mkdir -p build
	cat sql/node/src/node_header.js build/skdb.js | sed 's/^export //g' \
        | sed 's/let wasmModule =.*//g' | sed 's/let wasmBuffer =.*/let wasmBuffer = fs.readFileSync("out32.wasm");/g'> $@

build/skdb.js: sql/js/src/skdb.ts
	mkdir -p build
	cd sql/js && tsc --build tsconfig.json --pretty false
	cp sql/js/dist/skdb.js build/skdb.js

build/index.html: sql/js/index.html build/skdb.js
	mkdir -p build
	cp sql/js/index.html $@

.PHONY: clean
clean:
	rm -Rf build
