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
SKDB_DATABASES=$(SRV_DIR)/dbs
SKGW_DIR=$(SERVER_DIR)/dev
SKDB_INIT=$(ROOT_DIR)/privacy/init.sql
SKGW_JAR=$(SKGW_DIR)/build/libs/dev.jar
SERVER_JAR=$(SRV_DIR)/server.jar

default: build

.PHONY: build_server
build_server:
	@source $(SDKMAN_INIT) && cd $(SERVER_DIR) && gradle --console plain build 1>&2 > $(SKDB_DATABASES)/build_server.log
	@cd $(SKGW_DIR) && source $(SDKMAN_INIT) && ../gradlew jar --no-daemon --console plain 1>&2 > $(SKDB_DATABASES)/build_server.log
	cp $(SKGW_JAR) $(SERVER_JAR)

.PHONY: build
build: build_server $(SDKMAN_INIT) $(SKGW_DIR) $(SRV_DIR)/skdb.conf
	$(SRV_DIR)/service_server.sh $(SDKMAN_DIR) $(SKGW_DIR) $(SRV_DIR)/skdb.conf $(SKDB_DATABASES) $(SERVER_JAR)
	@echo sknpm.env:SKDB_CLI=$(SRV_DIR)/node_modules/skdb/dist/skdb-cli.mjs

.PHONY: $(SRV_DIR)/skdb.conf
$(SRV_DIR)/skdb.conf: $(SKDB_CLI) $(SKDB_DATABASES) $(SKDB_INIT)
	@echo "skdb_port=8110" > $(SRV_DIR)/skdb.conf
	@echo "skdb_databases=$(SKDB_DATABASES)" >> $(SRV_DIR)/skdb.conf
	@echo "skdb=$(SKDB_CMD)" >> $(SRV_DIR)/skdb.conf
	@echo "skdb_init=$(SKDB_INIT)" >> $(SRV_DIR)/skdb.conf
	@echo "skdb_add_cred=cd $(SKDB_CLI_DIR) && node $(SKDB_CLI_CMD) --add-cred --host ws://localhost:%d --db %s --access-key %s <<< \"%s\"" >> $(SRV_DIR)/skdb.conf
