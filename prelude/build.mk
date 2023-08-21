SCRIPT_DIR:=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))
COMP_DIR:=$(shell realpath $(SCRIPT_DIR)/../compiler)

ifdef PROFILE
PRFDEF=$(shell echo $(PROFILE) | tr  '[:lower:]' '[:upper:]')
DEFINITIONS=-D$(PRFDEF)
ifeq ($(PRFDEF),RELEASE)
OLEVEL=-O3
else
ifeq ($(PRFDEF),DEBUG)
OLEVEL=-O0
else
OLEVEL=-O2
endif # ifeq ($(PRFDEF),DEBUG)
endif # ifeq ($(PRFDEF),RELEASE)
else
DEFINITIONS=
OLEVEL=-O2 -g
endif # ifdef PROFILE

CC64FLAGS=$(OLEVEL) -DSKIP64

CRELFILES=\
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
	runtime/posix.c \
	runtime/native_eq.c

NATIVE_RELFILES=\
	runtime/palloc.c\
	runtime/consts.c

ifdef OUT_DIR
BUILD_DIR=$(shell realpath $(OUT_DIR))/
else
BUILD_DIR=$(ROOT_DIR)/build/
endif

CFILES=$(addprefix $(COMP_DIR)/,$(CRELFILES))
NATIVE_FILES=$(addprefix $(COMP_DIR)/,$(NATIVE_RELFILES))

OFILES=$(addprefix $(BUILD_DIR),$(CRELFILES:.c=.o))
ONATIVE_FILES=$(BUILD_DIR)magic.o $(addprefix $(BUILD_DIR),$(NATIVE_RELFILES:.c=.o))

.PHONY: default
default: libbacktrace $(BUILD_DIR)libskip_runtime64.a
	@echo "skargo:library=$(BUILD_DIR)libskip_runtime64.a"
	@echo "skargo:library=$(BUILD_DIR)libbacktrace.a"
	@echo "skargo:preamble=$(COMP_DIR)/preamble/preamble64.ll"
	@echo "skargo:link=-lrt"
	@echo "skargo:link=-lpthread"

$(BUILD_DIR)magic.c:
	@date | cksum | awk '{print "unsigned long version = " $$1 ";"}' > $(BUILD_DIR)magic.c
	@echo "int SKIP_get_version() { return (int)version; }" >> $(BUILD_DIR)magic.c

$(BUILD_DIR)magic.o: $(BUILD_DIR)magic.c
	@[ -d $(dir $@) ] || mkdir -p $(dir $@)
	@clang $(CC64FLAGS) -o $@ -c $<

$(BUILD_DIR)libskip_runtime64.a: $(OFILES) $(BUILD_DIR)runtime/runtime64_specific.o $(ONATIVE_FILES)
	@ar rcs $@ $^

.PHONY: libbacktrace
libbacktrace:
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	@(cd $(COMP_DIR)/runtime/libbacktrace && ./configure >> /dev/null) 
	@$(MAKE) -C $(COMP_DIR)/runtime/libbacktrace 2>&1 >> /dev/null
	@cp $(COMP_DIR)/runtime/libbacktrace/.libs/libbacktrace.a $(BUILD_DIR)libbacktrace.a

$(BUILD_DIR)runtime/runtime64_specific.o: $(COMP_DIR)/runtime/runtime64_specific.cpp
	@[ -d $(dir $@) ] || mkdir -p $(dir $@)
	@clang++ $(OLEVEL) -g -o $@ -c -I$(COMP_DIR)/runtime/libbacktrace/ $<

$(BUILD_DIR)%.o: $(COMP_DIR)/%.c
	@[ -d $(dir $@) ] || mkdir -p $(dir $@)
	@clang $(CC64FLAGS) -g -o $@ -c $<
