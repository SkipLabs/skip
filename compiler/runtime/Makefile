MEMSIZE32=1073741824

COMMONFLAGS=-Wall -Wextra -Wno-sign-conversion -Wno-sometimes-uninitialized -Wno-c2x-extensions -Wsign-compare -Wextra-semi-stmt
# To add: -Wcast-align -Wcast-qual -Wimplicit-int-conversion -Wmissing-noreturn -Wpadded -Wreserved-identifier -Wshorten-64-to-32 -Wtautological-unsigned-zero-compare
# -Watomic-implicit-seq-cst ?
# If using -Weverything, you may want to add -Wno-declaration-after-statement -Wno-missing-prototypes -Wno-missing-variable-declarations -Wno-shadow -Wno-strict-prototypes -Wno-zero-length-array -Wno-unreachable-code-break -Wno-unreachable-code-return
OLEVEL=-O2
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm -nostdlibinc $(COMMONFLAGS)
CC64FLAGS=$(OLEVEL) -DSKIP64 $(COMMONFLAGS)

# NB: this MUST be kept in sync with CRELFILES in prelude/build.mk
# and CRELFILES in prelude/build_wasm32.mk
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
BCFILES32=magic.bc $(CFILES32:.c=.bc)
OFILES=$(CFILES:.c=.o)
ONATIVE_FILES=magic.o $(NATIVE_FILES:.c=.o)

.PHONY: default
default: libskip_runtime64.a libskip_runtime32.bc

magic.c:
	date | cksum | awk '{print "unsigned long version = " $$1 ";"}' > magic.c
	echo "int SKIP_get_version() { return (int)version; }" >> magic.c

libskip_runtime32.bc: $(BCFILES32)
	llvm-link $(BCFILES32) -o $@

%.bc: %.c
	clang $(OLEVEL) $(CC32FLAGS) -o $@ -c $<

libskip_runtime64.a: $(OFILES) runtime64_specific.o $(ONATIVE_FILES)
	$(AR) rcs $@ $^

.PHONY: libbacktrace
libbacktrace: .libs/libbacktrace.a

.libs/libbacktrace.a:
	test -f libbacktrace/configure || (echo "Warning: libbacktrace submodule not initialized" && false)
	(cd libbacktrace && ./configure)
	$(MAKE) -C libbacktrace

runtime64_specific.o: runtime64_specific.cpp .libs/libbacktrace.a
	clang++ -std=c++11 $(OLEVEL) -g3 -o $@ -c -Ilibbacktrace/ $<

%.o: %.c
	clang $(CC64FLAGS) -g3 -o $@ -c $<

.PHONY: clean
clean:
	rm -f *.o *.bc magic.c libskip_runtime64.a
	(test ! -f libbacktrace/Makefile && echo "Warning: libbacktrace submodule not initialized") || $(MAKE) -C libbacktrace clean
