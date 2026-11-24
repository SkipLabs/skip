SHELL := /bin/bash

SRV_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))
ifndef ROOT_DIR
$(error ROOT_DIR must be defined.)
endif

SDKMAN_DIR?=$(HOME)/.sdkman
MAKEFLAGS += --no-print-directory

REAL_DIR=$(shell realpath $(ROOT_DIR))
SDKMAN_INIT=$(SDKMAN_DIR)/bin/sdkman-init.sh
SKDB_CMD=$(REAL_DIR)/target/host/release/skdb
SKDB_DATABASES=$(SRV_DIR)/build/dbs
# The skdb binary is built from the same sources as the top-level Makefile's
# $(SKDB_BIN) rule; without prerequisites an edit never rebuilds it (#1494).
SKDB_SRCS=$(wildcard $(REAL_DIR)/src/*) $(shell find $(REAL_DIR)/../skiplang/prelude/src -name '*.sk') $(wildcard $(REAL_DIR)/../skiplang/skdate/src/*) $(wildcard $(REAL_DIR)/../skiplang/skjson/src/*) $(wildcard $(REAL_DIR)/../skiplang/sqlparser/src/*)

default: install

$(SDKMAN_DIR):
	@cd $(dir $(SDKMAN_DIR)) && sh -c 'wget -q -O- "https://get.sdkman.io?rcupdate=false" | sh'

$(SDKMAN_DIR)/candidates/java/20.0.2-tem: $(SDKMAN_DIR)
	@mkdir -p $(SKDB_DATABASES)
	@source $(SDKMAN_INIT) && sdk install java 20.0.2-tem 1>&2 > $(SKDB_DATABASES)/install_java.log

$(SDKMAN_DIR)/candidates/gradle: $(SDKMAN_DIR)/candidates/java/20.0.2-tem
	@source $(SDKMAN_INIT) && sdk install gradle 8.3 1>&2 > $(SKDB_DATABASES)/install_gradle.log

.PHONY: install
install: $(SDKMAN_DIR)/candidates/gradle $(SKDB_CMD) $(SKDB_DATABASES)

$(SKDB_DATABASES):
	@mkdir -p $(SKDB_DATABASES)

$(SKDB_CMD): $(SKDB_SRCS)
	@cd $(REAL_DIR);skargo b --release --bin skdb
