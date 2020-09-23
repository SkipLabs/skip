
build/a.out: build/out.ll build/runtime.bc
	cat preamble.ll build/out.ll > build/preamble_and_out.ll
	llvm-link-10 build/runtime.bc build/preamble_and_out.ll -o build/all.bc
	llc-10 -mtriple=wasm32-unknown-unknown -O3 -filetype=obj build/all.bc -o build/out.o
	wasm-ld-10 --initial-memory=67108864 -export=sk.call0 -export=sk.call1 -export=getExn -export=mymemcpy -export=malloc -export=skip_main -export=SKIP_initializeSkip build/out.o -o build/out.wasm --no-entry -allow-undefined

build/out.ll:
	~/skip/build/bin/skip_to_llvm --embedded32 . --export-function-as main=skip_main --no-inline --output build/out.ll

build/runtime.bc: runtime.c
	/usr/bin/clang-10 --target=wasm32 -emit-llvm -c runtime.c -c -o build/runtime.bc

clean:
	rm -Rf build && mkdir build
