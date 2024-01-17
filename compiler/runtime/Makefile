MEMSIZE32=1073741824

OLEVEL=-O2
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm -nostdlibinc
CC64FLAGS=$(OLEVEL) -DSKIP64

# NB: this MUST be kept in sync with CRELFILES in prelude/build_wasm32.mk
CFILES=\
	copy.c \
	free.c \
	hash.c \
	hashtable.c \
	intern.c \
	memory.c \
	obstack.c \
	runtime.c \
	stdlib.c \
	stack.c \
	string.c \
	native_eq.c \
	splitmix64.c \
	xoroshiro128plus.c

NATIVE_FILES=\
	consts.c \
	palloc.c \
	posix.c

CFILES32=$(CFILES) runtime32_specific.c
BCFILES32=magic.32.bc $(CFILES32:.c=.32.bc)
BCFILES64=magic.64.bc $(CFILES:.c=.64.bc) runtime64_specific.64.bc $(NATIVE_FILES:.c=.64.bc)

.PHONY: default
default: libskip_runtime64.bc libskip_runtime32.bc

magic.c:
	date | cksum | awk '{print "unsigned long version = " $$1 ";"}' > magic.c
	echo "int SKIP_get_version() { return (int)version; }" >> magic.c

libskip_runtime32.bc: $(BCFILES32)
	llvm-link $(BCFILES32) -o $@

libskip_runtime64.bc: $(BCFILES64)
	llvm-link $(BCFILES64) -o $@

%.32.bc: %.c
	clang $(OLEVEL) $(CC32FLAGS) -o $@ -c $<

%.64.bc: %.c
	clang $(OLEVEL) $(CC64FLAGS) -emit-llvm -o $@ -c $<

.PHONY: libbacktrace
libbacktrace: .libs/libbacktrace.a

.libs/libbacktrace.a:
	test -f libbacktrace/configure || (echo "Warning: libbacktrace submodule not initialized" && false)
	(cd libbacktrace && ./configure)
	$(MAKE) -C libbacktrace

runtime64_specific.64.bc: runtime64_specific.cpp .libs/libbacktrace.a
	clang++ -std=c++11 $(OLEVEL) -g -emit-llvm -o $@ -c -Ilibbacktrace/ $<

.PHONY: clean
clean:
	rm -f *.bc magic.c
	(test ! -f libbacktrace/Makefile && echo "Warning: libbacktrace submodule not initialized") || $(MAKE) -C libbacktrace clean
