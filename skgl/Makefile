CC=clang-10
CPP=clang++-10
SKC=~/skip/build/bin/skip_to_llvm
BCLINK=llvm-link-10
MEMSIZE32=1073741824

OLEVEL=-O3
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm
CC64FLAGS=$(OLEVEL) -DSKIP64
SKFLAGS=

SKIP_FILES=$(wildcard *.sk) $(wildcard ../*.sk) $(wildcard */*.sk)

default: ../build/skgl

../build/skgl_out32.wasm: ../build/skgl_out32.ll ../build/full_runtime32.bc
	cat ../preamble32.ll ../build/skgl_out32.ll > ../build/preamble_and_skgl_out32.ll
	llvm-link-10 ../build/full_runtime32.bc ../build/preamble_and_skgl_out32.ll -o ../build/all.bc
	llc-10 -mtriple=wasm32-unknown-unknown $(OLEVEL) -filetype=obj ../build/all.bc -o ../build/skgl_out32.o
	wasm-ld-10 --initial-memory=$(MEMSIZE32) $(EXPORTJS) ../build/skgl_out32.o -o ../build/skgl_out32.wasm --no-entry -allow-undefined

../build/skgl_out32.ll: $(SKIP_FILES)
	mkdir -p ../build/
	$(SKC) --embedded32 . --export-function-as main=skip_main $(SKFLAGS) --output ../build/skgl_out32.ll

../build/skgl: ../build/skgl_out64.ll ../build/libskip_runtime64.a
	cat ../preamble64.ll ../build/skgl_out64.ll > ../build/preamble_and_skgl_out64.ll
	$(CPP) $(OLEVEL) ../build/preamble_and_skgl_out64.ll ../build/libskip_runtime64.a -o ../build/skgl -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive

../build/skgl_out64.ll: $(SKIP_FILES)
	mkdir -p ../build/
	$(SKC) --embedded64 . --export-function-as main=skip_main $(SKFLAGS) --output ../build/skgl_out64.ll

clean:
	rm -Rf ../build/skgl*
