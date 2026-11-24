MEMSIZE32=1073741824

# -I. lets the vendored Ryu sources (ryu/*.c) and string.c resolve
# `#include "ryu/..."` (upstream builds with its repo root on the include path).
CFLAGS += -I. -Werror -Wall -Wextra -Wno-sign-conversion -Wno-sometimes-uninitialized -Wno-c2x-extensions -Wsign-compare -Wextra-semi-stmt -fstrict-flex-arrays=3
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
	ryu/d2s.c \
	ryu/s2d.c \
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
ONATIVE_FILES=$(NATIVE_FILES:.c=.o)

# Auto-generated header dependencies (-MMD -MP), so editing runtime.h or
# another header rebuilds the objects that include it instead of silently
# relinking stale ones (#1493). Kept out of CFLAGS because callers pass
# CFLAGS on the command line, which would override a `CFLAGS +=` here.
DEPFLAGS=-MMD -MP
DEPFILES=$(OFILES:.o=.d) $(ONATIVE_FILES:.o=.d) runtime64_specific.d parallel_map.d $(BCFILES32:.bc=.d)

.PHONY: default
default: libskip_runtime64.a libskip_runtime32.bc

# Only the wasm runtime uses SKIP_get_version(): native persistent files are
# keyed on the executable's build-id (palloc.c).
magic.c:
	date | cksum | awk '{print "unsigned long version = " $$1 ";"}' > magic.c
	echo "int SKIP_get_version() { return (int)version; }" >> magic.c

libskip_runtime32.bc: $(BCFILES32)
	llvm-link $(BCFILES32) -o $@

memory.bc: alloc_size_classes.h
palloc.o: alloc_size_classes.h

%.bc: %.c
	clang $(CC32FLAGS) $(DEPFLAGS) -o $@ -c $<

# skc bundles this archive into libstd.sklib, and the bootstrap skc predates
# the arparser fix for the member names of Apple's BSD-format archives, so
# build a GNU-format one on macOS.
ifeq ($(shell uname -s),Darwin)
libskip_runtime64.a: $(OFILES) runtime64_specific.o parallel_map.o $(ONATIVE_FILES)
	rm -f $@
	llvm-ar --format=gnu rcs $@ $^
else
libskip_runtime64.a: $(OFILES) runtime64_specific.o parallel_map.o $(ONATIVE_FILES)
	$(AR) rcs $@ $^
endif

runtime64_specific.o parallel_map.o: %.o: %.cpp runtime64_support.h
	clang++ -std=c++11 $(CC64FLAGS) $(DEPFLAGS) -o $@ -c $<

%.o: %.c
	clang $(CC64FLAGS) $(DEPFLAGS) -o $@ -c $<

-include $(DEPFILES)

.PHONY: clean
clean:
	rm -f *.o *.d *.bc ryu/*.o ryu/*.d ryu/*.bc magic.c libskip_runtime64.a libskip_runtime32.bc
