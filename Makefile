
default: build/out32.wasm build/a.out

build/out32.wasm: build/out32.ll build/runtime32.bc build/runtime32_specific.bc
	cat preamble32.ll build/out32.ll > build/preamble_and_out32.ll
	llvm-link-10 build/runtime32.bc build/runtime32_specific.bc build/preamble_and_out32.ll -o build/all.bc
	llc-10 -mtriple=wasm32-unknown-unknown -O3 -filetype=obj build/all.bc -o build/out32.o
	wasm-ld-10 --initial-memory=67108864 -export=getCompositeName -export=getCompositeSize -export=getCompositeAt -export=getStringSize -export=getLeafValue -export=objectKind -export=SKIP_call0 -export=mymemcpy -export=malloc -export=skip_main -export=SKIP_initializeSkip build/out32.o -o build/out32.wasm --no-entry -allow-undefined

build/out32.ll: *.sk
	~/skip/build/bin/skip_to_llvm --embedded32 . --export-function-as main=skip_main --no-inline --output build/out32.ll

build/runtime32.bc: runtime.c
	/usr/bin/clang-10 --target=wasm32 -emit-llvm -c runtime.c -c -o build/runtime32.bc

build/runtime32_specific.bc: runtime32_specific.c
	/usr/bin/clang-10 --target=wasm32 -emit-llvm -c runtime32_specific.c -c -o build/runtime32_specific.bc


build/a.out: build/out64.ll build/runtime64.o build/runtime64_specific.o
	cat preamble64.ll build/out64.ll > build/preamble_and_out64.ll
	clang++-10 -O2 build/runtime64.o build/runtime64_specific.o build/preamble_and_out64.ll -o build/a.out

build/out64.ll: *.sk
	~/skip/build/bin/skip_to_llvm --embedded64 . --export-function-as main=skip_main --no-inline --output build/out64.ll

build/runtime64.o: runtime.c
	/usr/bin/clang-10 -c runtime.c -o build/runtime64.o

build/runtime64_specific.o: runtime64_specific.cpp
	/usr/bin/clang++-10 -c runtime64_specific.cpp -o build/runtime64_specific.o

clean:
	rm -Rf build && mkdir build
