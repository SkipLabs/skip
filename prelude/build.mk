SCRIPT_DIR:=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))

COMP_DIR:=$(shell realpath $(SCRIPT_DIR)/../compiler)

LIB_DIR?=/usr/local/lib

LBT_EXISTS=$(shell [ -e $(LIB_DIR)/libbacktrace.a ] && echo 1 || echo 0 )

ifdef OUT_DIR
BUILD_DIR=$(shell realpath $(OUT_DIR))/
else
BUILD_DIR=$(ROOT_DIR)/build/
endif

.PHONY: default
default: $(BUILD_DIR)libbacktrace.a
	@echo "skargo:library=$(COMP_DIR)/runtime/libskip_runtime64.bc"
	@echo "skargo:library=$(BUILD_DIR)libbacktrace.a"
	@echo "skargo:preamble=$(COMP_DIR)/preamble/preamble64.ll"
	@echo "skargo:link=-lpthread"

ifeq ($(LBT_EXISTS), 1)
$(BUILD_DIR)libbacktrace.a:
	cp $(LIB_DIR)/libbacktrace.a $(BUILD_DIR)libbacktrace.a
else
$(BUILD_DIR)libbacktrace.a:
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	(cd $(COMP_DIR)/runtime/libbacktrace && ./configure) 
	$(MAKE) -C $(COMP_DIR)/runtime/libbacktrace
	cp $(COMP_DIR)/runtime/libbacktrace/.libs/libbacktrace.a $(BUILD_DIR)libbacktrace.a
endif
