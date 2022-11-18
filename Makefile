CC=clang-12
CPP=clang++-12
SKC=~/skip/build/bin/skip_to_llvm
BCLINK=llvm-link-12
LLC=llc-12
WASMLD=wasm-ld-12
MEMSIZE32=1073741824

OLEVEL=-O2
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm
CC64FLAGS=$(OLEVEL) -DSKIP64
SKFLAGS=

SKIP_FILES=$(wildcard *.sk) $(wildcard */*.sk)
CFILES=\
	runtime/copy.c \
	runtime/free.c \
	runtime/hash.c \
	runtime/hashtable.c \
	runtime/intern.c \
	runtime/memory.c \
	runtime/obstack.c \
	runtime/runtime.c \
	runtime/stdlib.c \
	runtime/stack.c \
	runtime/string.c \
	runtime/native_eq.c

NATIVE_FILES=\
	runtime/palloc.c\
	runtime/consts.c

CFILES32=$(CFILES) runtime/runtime32_specific.c
CFILES64=$(CFILES) runtime/runtime64_specific.cpp $(NATIVE_FILES)
BCFILES32=build/magic.bc $(addprefix build/,$(CFILES32:.c=.bc))
OFILES=$(addprefix build/,$(CFILES:.c=.o))
ONATIVE_FILES= build/magic.o $(addprefix build/,$(NATIVE_FILES:.c=.o))

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
	sk_string_create \
	SKIP_initializeSkip \
	SKIP_skfs_init \
	SKIP_skfs_end_of_init \
	SKIP_get_persistent_size \
	sk_pop_dirty_page \
	SKIP_get_version \
	SKIP_throw_EndOfFile

EXPORTJS=$(addprefix -export=,$(SKFUNS))

default: build/out32.wasm build/skdb

build/magic.c:
	date | cksum | awk '{print "unsigned long version = " $$1 ";"}' > build/magic.c
	echo "int SKIP_get_version() { return (int)version; }" >> build/magic.c

build/magic.bc: build/magic.c
	mkdir -p build/runtime
	$(CC) $(OLEVEL) $(CC32FLAGS) -o $@ -c $<

build/magic.o: build/magic.c
	mkdir -p build/runtime
	$(CC) $(CC64FLAGS) -o $@ -c $<

test: build/out32.wasm build/skdb
	node run.js
	build/skdb all

build/out32.wasm: build/out32.ll build/full_runtime32.bc
	cat preamble32.ll build/out32.ll > build/preamble_and_out32.ll
	$(BCLINK) build/full_runtime32.bc build/preamble_and_out32.ll -o build/all.bc
	$(LLC) -mtriple=wasm32-unknown-unknown $(OLEVEL) -filetype=obj build/all.bc -o build/out32.o
	$(WASMLD) --initial-memory=$(MEMSIZE32) $(EXPORTJS) build/out32.o -o build/out32.wasm --no-entry -allow-undefined

build/out32.ll: $(SKIP_FILES)
	mkdir -p build/
	$(SKC) --embedded32 . --export-function-as main=skip_main $(SKFLAGS) --output build/out32.ll

build/full_runtime32.bc: $(BCFILES32)
	$(BCLINK) $(BCFILES32) -o build/full_runtime32.bc

build/%.bc: %.c
	mkdir -p build/runtime
	$(CC) $(OLEVEL) $(CC32FLAGS) -o $@ -c $<

build/skdb: build/out64.ll build/libskip_runtime64.a
	cat preamble64.ll build/out64.ll > build/preamble_and_out64.ll
	$(CPP) $(OLEVEL) build/preamble_and_out64.ll build/libskip_runtime64.a -o build/skdb -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
	./stripdebug.sh build/skdb

build/out64.ll: $(SKIP_FILES)
	mkdir -p build/
	$(SKC) --embedded64 . --export-function-as main=skip_main $(SKFLAGS) --output build/out64.ll

build/libskip_runtime64.a: $(OFILES) build/runtime/runtime64_specific.o $(ONATIVE_FILES)
	ar rcs build/libskip_runtime64.a $(OFILES) build/runtime/runtime64_specific.o $(ONATIVE_FILES)

build/runtime/runtime64_specific.o: runtime/runtime64_specific.cpp
	$(CPP) $(OLEVEL) -c runtime/runtime64_specific.cpp -o build/runtime/runtime64_specific.o

build/%.o: %.c
	mkdir -p build/runtime
	$(CC) $(CC64FLAGS) -o $@ -c $<

clean:
	rm -Rf build
