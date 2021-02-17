CC=clang-10
CPP=clang++-10
SKC=~/skip/build/bin/skip_to_llvm
BCLINK=llvm-link-10
MEMSIZE32=134217728

OLEVEL=-O3
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
	runtime/size.c \
	runtime/native_eq.c \
	runtime/verify.c

CFILES32=$(CFILES) runtime/runtime32_specific.c
CFILES64=$(CFILES) runtime/runtime64_specific.cpp runtime/alloc.c
BCFILES32=$(addprefix build/,$(CFILES32:.c=.bc))
OFILES=$(addprefix build/,$(CFILES:.c=.o))

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
	SKIP_skfs_init

EXPORTJS=$(addprefix -export=,$(SKFUNS))

default: build/out32.wasm build/a.out

test: build/out32.wasm build/a.out
	node run.js
	build/a.out all

build/out32.wasm: build/out32.ll build/full_runtime32.bc
	cat preamble32.ll build/out32.ll > build/preamble_and_out32.ll
	llvm-link-10 build/full_runtime32.bc build/preamble_and_out32.ll -o build/all.bc
	llc-10 -mtriple=wasm32-unknown-unknown $(OLEVEL) -filetype=obj build/all.bc -o build/out32.o
	wasm-ld-10 --initial-memory=$(MEMSIZE32) $(EXPORTJS) build/out32.o -o build/out32.wasm --no-entry -allow-undefined

build/out32.ll: $(SKIP_FILES)
	mkdir -p build/
	$(SKC) --embedded32 . --export-function-as main=skip_main $(SKFLAGS) --output build/out32.ll

build/full_runtime32.bc: $(BCFILES32)
	$(BCLINK) $(BCFILES32) -o build/full_runtime32.bc

build/%.bc: %.c
	mkdir -p build/runtime
	$(CC) $(OLEVEL) $(CC32FLAGS) -o $@ -c $<

build/a.out: build/out64.ll build/libskip_runtime64.a
	cat preamble64.ll build/out64.ll > build/preamble_and_out64.ll
	$(CPP) $(OLEVEL) build/preamble_and_out64.ll build/libskip_runtime64.a -o build/a.out

build/out64.ll: $(SKIP_FILES)
	mkdir -p build/
	$(SKC) --embedded64 . --export-function-as main=skip_main $(SKFLAGS) --output build/out64.ll

build/libskip_runtime64.a: $(OFILES) build/runtime/runtime64_specific.o build/runtime/alloc.o
	ar rcs build/libskip_runtime64.a $(OFILES) build/runtime/runtime64_specific.o build/runtime/alloc.o

build/runtime/runtime64_specific.o: runtime/runtime64_specific.cpp
	$(CPP) $(OLEVEL) -c runtime/runtime64_specific.cpp -o build/runtime/runtime64_specific.o

build/%.o: %.c
	mkdir -p build/runtime
	$(CC) $(CC64FLAGS) -o $@ -c $<

clean:
	rm -Rf build
