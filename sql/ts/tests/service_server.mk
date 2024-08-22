SHELL := /bin/bash

SRV_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))
ifndef ROOT_DIR
$(error ROOT_DIR must be defined.)
endif

SDKMAN_DIR?=$(HOME)/.sdkman
MAKEFLAGS += --no-print-directory

REAL_DIR=$(shell realpath $(ROOT_DIR))
SERVER_DIR=$(ROOT_DIR)/server
SDKMAN_INIT=$(SDKMAN_DIR)/bin/sdkman-init.sh
SKDB_CLI=$(SRV_DIR)/node_modules/skdb/dist/skdb-cli.mjs
SKDB_CLI_DIR=$(SRV_DIR)/node_modules/skdb
SKDB_CLI_CMD=./dist/skdb-cli.mjs
SKDB_CMD=$(REAL_DIR)/target/host/release/skdb

BUILD_DIR=$(SRV_DIR)/build
SKDB_DATABASES=$(BUILD_DIR)/dbs
SKGW_DIR=$(SERVER_DIR)/dev
SKDB_INIT=$(ROOT_DIR)/privacy/init.sql
SKGW_JAR=$(SKGW_DIR)/build/libs/dev.jar
SERVER_JAR=$(BUILD_DIR)/server.jar
CONF_FILE=$(BUILD_DIR)/skdb.conf

default: build

.PHONY: build_server
build_server:
	mkdir -p $(SKDB_DATABASES)
	@cd $(SKGW_DIR) && source $(SDKMAN_INIT) && ../gradlew jar --no-daemon --console plain 1>&2 > $(BUILD_DIR)/build_server.log
	cp $(SKGW_JAR) $(SERVER_JAR)

.PHONY: build
build: build_server $(SDKMAN_INIT) $(SKGW_DIR) $(CONF_FILE)
	$(SRV_DIR)/service_server.sh $(SDKMAN_DIR) $(SKGW_DIR) $(CONF_FILE) $(SKDB_DATABASES) $(SERVER_JAR)
	@echo sknpm.env:SKDB_CLI=$(SRV_DIR)/node_modules/skdb/dist/skdb-cli.mjs

.PHONY: $(CONF_FILE)
$(CONF_FILE): $(SKDB_CLI) $(SKDB_DATABASES) $(SKDB_INIT)
	@echo "skdb_port=8110" > $(CONF_FILE)
	@echo "skdb_databases=$(SKDB_DATABASES)" >> $(CONF_FILE)
	@echo "skdb=$(SKDB_CMD)" >> $(CONF_FILE)
	@echo "skdb_init=$(SKDB_INIT)" >> $(CONF_FILE)