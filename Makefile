CC=clang
CPP=clang++
SKC=build/skc
BCLINK=llvm-link
LLC=llc
WASMLD=wasm-ld-10
MEMSIZE32=1073741824

OLEVEL=-O2
SKFLAGS=

SKIP_FILES=$(shell find prelude -name '*.sk') $(shell find skfs -name '*.sk') $(wildcard main/*.sk) $(wildcard sql/*.sk) $(wildcard sktest/src/*.sk) $(wildcard termcolor/src/*.sk) $(wildcard cli/src/*.sk)

SKFUNS=\
	getCompositeName \
	getCompositeSize \
	getCompositeAt \
  SKIP_String_byteSize \
	getLeafValue \
	objectKind \
	SKIP_call0 \
	SKIP_Obstack_alloc \
	skip_main \
	SKIP_init_jsroots \
	SKIP_add_root \
	SKIP_remove_root \
	SKIP_tracked_call \
	SKIP_tracked_query \
	sk_string_create \
	SKIP_initializeSkip \
	SKIP_skfs_init \
	SKIP_skfs_end_of_init \
	SKIP_get_persistent_size \
	sk_pop_dirty_page \
	SKIP_get_version \
	SKIP_throw_EndOfFile

EXPORTJS=$(addprefix -export=,$(SKFUNS))

default: compiler build/out32.wasm build/skdb build/skdb.js build/skdb_node.js build/index.html

.PHONY: compiler
compiler:
	$(MAKE) -C compiler STAGE=0
	mkdir -p build
	cp compiler/stage0/bin/skc build/
	cp compiler/stage0/lib/libskip_runtime64.a build/
	cp compiler/stage0/lib/libskip_runtime32.bc build/
	cp compiler/stage0/lib/skip_preamble64.ll build/
	cp compiler/stage0/lib/skip_preamble32.ll build/

test: build/out32.wasm build/skdb
	./run_all_tests.sh

build/out32.wasm: build/out32.ll compiler
	cat build/skip_preamble32.ll build/out32.ll > build/preamble_and_out32.ll
	$(BCLINK) build/libskip_runtime32.bc build/preamble_and_out32.ll -o build/all.bc
	$(LLC) -mtriple=wasm32-unknown-unknown $(OLEVEL) -filetype=obj build/all.bc -o build/out32.o
	$(WASMLD) --initial-memory=$(MEMSIZE32) $(EXPORTJS) build/out32.o -o build/out32.wasm --no-entry -allow-undefined
	mkdir -p sql/js/dist
	cp build/out32.wasm sql/js/dist

build/out32.ll: $(SKIP_FILES) compiler
	mkdir -p build/
	$(SKC) --embedded32 $(SKIP_FILES) --export-function-as main=skip_main $(SKFLAGS) --output build/out32.ll

build/skdb: build/out64.ll compiler
	cat build/skip_preamble64.ll build/out64.ll > build/preamble_and_out64.ll
	$(CPP) $(OLEVEL) build/preamble_and_out64.ll build/libskip_runtime64.a -o build/skdb -lrt -lpthread

build/out64.ll: $(SKIP_FILES) compiler
	mkdir -p build/
	$(SKC) --embedded64 $(SKIP_FILES) --export-function-as main=skip_main $(SKFLAGS) --output build/out64.ll

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

clean:
	rm -Rf build
