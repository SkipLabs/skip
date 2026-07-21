MEMSIZE32=1073741824

CFLAGS += -Werror -Wall -Wextra -Wno-sign-conversion -Wno-sometimes-uninitialized -Wno-c2x-extensions -Wsign-compare -Wextra-semi-stmt -fstrict-flex-arrays=3
# To add: -Wcast-align -Wcast-qual -Wimplicit-int-conversion -Wmissing-noreturn -Wpadded -Wreserved-identifier -Wshorten-64-to-32 -Wtautological-unsigned-zero-compare
# -Watomic-implicit-seq-cst ?
# If using -Weverything, you may want to add -Wno-declaration-after-statement -Wno-missing-prototypes -Wno-missing-variable-declarations -Wno-shadow -Wno-strict-prototypes -Wno-zero-length-array -Wno-unreachable-code-break -Wno-unreachable-code-return
CC32FLAGS=-DSKIP32 --target=wasm32 -emit-llvm -nostdlibinc $(CFLAGS)
CC64FLAGS=-DSKIP64 $(CFLAGS)

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
	clang $(CC32FLAGS) -o $@ -c $<

libskip_runtime64.a: $(OFILES) runtime64_specific.o $(ONATIVE_FILES)
	$(AR) rcs $@ $^

runtime64_specific.o: runtime64_specific.cpp
	clang++ -std=c++11 $(CC64FLAGS) -o $@ -c $<

%.o: %.c
	clang $(CC64FLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm -f *.o *.bc magic.c libskip_runtime64.a
