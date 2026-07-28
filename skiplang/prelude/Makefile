OUT_DIR?=$(shell realpath ./build)
LIB_DIR?=/usr/local/lib

OLEVEL ?= -O2

ifdef PROFILE
PRFDEF=$(shell echo $(PROFILE) | tr  '[:lower:]' '[:upper:]')
ifeq ($(PRFDEF),RELEASE)
OLEVEL = -O3
else
ifeq ($(PRFDEF),DEBUG)
OLEVEL = -O0
endif # ifeq ($(PRFDEF),DEBUG)
endif # ifeq ($(PRFDEF),RELEASE)
endif # ifdef PROFILE
OLEVEL ?= -O2
CFLAGS += $(OLEVEL) -g3

LBT_EXISTS=$(shell [ -e $(LIB_DIR)/libbacktrace.a ] && echo 1 || echo 0 )

SKIP_SRC=$(shell find src/ -name '*.sk')

.PHONY: default
default: $(OUT_DIR)/libbacktrace.a $(OUT_DIR)/libskip_runtime64.a preamble/preamble64.ll
	@echo "skargo:skc-preamble=preamble/preamble64.ll"
	@echo "skargo:skc-link-lib=$(OUT_DIR)/libskip_runtime64.a"
	@echo "skargo:skc-link-lib=$(OUT_DIR)/libbacktrace.a"
	@echo "skargo:skc-link-arg=-lpthread"

.PHONY: wasm
wasm: $(OUT_DIR)/libskip_runtime32.a preamble/preamble32.ll
	@echo "skargo:skc-preamble=preamble/preamble32.ll"
	@echo "skargo:skc-link-lib=$(OUT_DIR)/libskip_runtime32.a"

.PHONY: bootstrap
bootstrap: $(OUT_DIR)/libstd.sklib

# These archive targets are .PHONY -- their recipes delegate to a recursive make
# that cannot report whether it changed anything -- so a plain `cp` would bump
# the mtime on every invocation even when the bytes are identical. Everything
# downstream keys off that mtime: the stage0 link, and skargo, which fingerprints
# the link libraries its build script reports and rebuilds the whole compiler
# when they move. Copy only on a content difference, so an unchanged archive
# stays unchanged.
COPY_IF_DIFFERENT = cmp -s $(1) $(2) || cp $(1) $(2)

.PHONY: $(OUT_DIR)/libbacktrace.a
ifeq ($(LBT_EXISTS), 1)
$(OUT_DIR)/libbacktrace.a:
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	$(call COPY_IF_DIFFERENT,$(LIB_DIR)/libbacktrace.a,$@)
else
LBT_SOURCE=$(realpath libbacktrace)
LBT_BUILD=$(OUT_DIR)/libbacktrace-build

CFLAGS += -I$(LBT_SOURCE)

$(OUT_DIR)/libbacktrace.a:
	test -f libbacktrace/configure || (echo "Warning: libbacktrace submodule not initialized" && false)
	@rm -f libbacktrace/config.status libbacktrace/config.h libbacktrace/config.log \
	       libbacktrace/Makefile libbacktrace/libtool libbacktrace/stamp-h1 \
	       libbacktrace/*.lo libbacktrace/*.o
	@rm -rf libbacktrace/.libs libbacktrace/.deps
	@if [ ! -f $(LBT_BUILD)/Makefile ]; then mkdir -p $(LBT_BUILD) && cd $(LBT_BUILD) && CC=clang $(LBT_SOURCE)/configure; fi
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	$(MAKE) -C $(LBT_BUILD)
	$(call COPY_IF_DIFFERENT,$(LBT_BUILD)/.libs/libbacktrace.a,$@)
endif

.PHONY: $(OUT_DIR)/libskip_runtime64.a
$(OUT_DIR)/libskip_runtime64.a:
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	CFLAGS="$(CFLAGS)" $(MAKE) -C runtime/ libskip_runtime64.a
	$(call COPY_IF_DIFFERENT,runtime/libskip_runtime64.a,$@)

.PHONY: $(OUT_DIR)/libskip_runtime32.bc
$(OUT_DIR)/libskip_runtime32.bc:
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	CFLAGS="$(CFLAGS)" $(MAKE) -C runtime/ libskip_runtime32.bc
	$(call COPY_IF_DIFFERENT,runtime/libskip_runtime32.bc,$@)

$(OUT_DIR)/libskip_runtime32.o: $(OUT_DIR)/libskip_runtime32.bc
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	llc -mtriple=wasm32-unknown-unknown -O2 -filetype=obj $^ -o $@

$(OUT_DIR)/libskip_runtime32.a: $(OUT_DIR)/libskip_runtime32.o
	@[ -d $(OUT_DIR) ] || mkdir -p $(OUT_DIR)
	llvm-ar crs $@ $^

$(OUT_DIR)/libstd.sklib: $(OUT_DIR)/libskip_runtime64.a $(OUT_DIR)/libbacktrace.a $(SKIP_SRC)
	SKC_PREAMBLE=./preamble/preamble64.ll skc -o $@ --sklib-name std --no-std $(OLEVEL) --link-args '-lpthread' $^

.PHONY: libbacktrace
libbacktrace: $(OUT_DIR)/libbacktrace.a

.PHONY: clean
clean:
	rm -f $(OUT_DIR)/libbacktrace.a $(OUT_DIR)/libskip_runtime64.a $(OUT_DIR)/libstd.sklib
	rm -rf $(OUT_DIR)/libbacktrace-build
	$(MAKE) -C runtime clean
	rm -f libbacktrace/config.status libbacktrace/config.h libbacktrace/config.log \
	      libbacktrace/Makefile libbacktrace/libtool libbacktrace/stamp-h1 \
	      libbacktrace/*.lo libbacktrace/*.o
	rm -rf libbacktrace/.libs libbacktrace/.deps
	find . -name 'Skargo.toml' -print0 | sed 's|Skargo.toml|target|g' | xargs -0 rm -rf
