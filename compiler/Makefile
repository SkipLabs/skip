CC=clang-10
CPP=clang++-10
SKC=~/skip/build/bin/skip_to_llvm  --no-inline
BCLINK=llvm-link-10
MEMSIZE32=1073741824

OLEVEL=-O3
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm
CC64FLAGS=$(OLEVEL) -DSKIP64
SKFLAGS=

SKIP_FILES=$(wildcard *.sk) $(wildcard ../*.sk) $(wildcard */*.sk)

default: ../build/skc

../build/skc_out32.wasm: ../build/skc_out32.ll ../build/full_runtime32.bc
	cat ../preamble32.ll ../build/skc_out32.ll > ../build/preamble_and_skc_out32.ll
	llvm-link-10 ../build/full_runtime32.bc ../build/preamble_and_skc_out32.ll -o ../build/all.bc
	llc-10 -mtriple=wasm32-unknown-unknown $(OLEVEL) -filetype=obj ../build/all.bc -o ../build/skc_out32.o
	wasm-ld-10 --initial-memory=$(MEMSIZE32) $(EXPORTJS) ../build/skc_out32.o -o ../build/skc_out32.wasm --no-entry -allow-undefined

../build/skc_out32.ll: $(SKIP_FILES)
	mkdir -p ../build/
	$(SKC) --embedded32 . --export-function-as main=skip_main $(SKFLAGS) --output ../build/skc_out32.ll

../build/skc: ../build/skc_out64.ll ../build/libskip_runtime64.a
	cat ../preamble64.ll ../build/skc_out64.ll > ../build/preamble_and_skc_out64.ll
	$(CPP) $(OLEVEL) ../build/preamble_and_skc_out64.ll ../build/libskip_runtime64.a -o ../build/skc -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive

../build/skc_out64.ll: $(SKIP_FILES)
	mkdir -p ../build/
	$(SKC) --embedded64 . --export-function-as main=skip_main $(SKFLAGS) --output ../build/skc_out64.ll

clean:
	rm -Rf ../build/skc*
