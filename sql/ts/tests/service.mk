SHELL := /bin/bash

SRV_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))
ifndef ROOT_DIR
$(error ROOT_DIR must be defined.)
endif

SDKMAN_DIR?=$(HOME)/.sdkman

REAL_DIR=$(shell realpath $(ROOT_DIR))
SERVER_DIR=$(ROOT_DIR)/server
SDKMAN_INIT=$(SDKMAN_DIR)/bin/sdkman-init.sh
SKDB_CLI=$(SRV_DIR)/node_modules/skdb/dist/skdb-cli.mjs
SKDB_CLI_DIR=$(SRV_DIR)/node_modules/skdb
SKDB_CLI_CMD=./dist/skdb-cli.mjs
SKDB_CMD=$(REAL_DIR)/target/release/skdb
SKDB_DATABASES=$(SRV_DIR)/dbs
SKGW_DIR=$(SERVER_DIR)/skgw
SKDB_INIT=$(ROOT_DIR)/privacy/init.sql

default: build

.PHONY: build
build: $(ROOT_DIR)/server $(SDKMAN_INIT) $(SKGW_DIR) $(SRV_DIR)/skgw.conf
build: SLOG=$(shell $(SRV_DIR)/service.sh $(SDKMAN_DIR) $(SKGW_DIR) $(SRV_DIR)/skgw.conf $(SKDB_DATABASES))
build: CREDENTIALS=$(shell cat $(SRV_DIR)/dbs/init.log | grep 'skgw.credentials')
build:
	@echo $(SLOG)
	@echo $(CREDENTIALS:skgw.credentials%=sknpm.env:SKDB_CREDENTIALS%)
	@echo sknpm.env:SKDB_BIN=$(REAL_DIR)/target/release/skdb
	@echo sknpm.env:SKDB_CLI=$(SRV_DIR)/node_modules/skdb/dist/skdb-cli.mjs

.PHONY: $(SRV_DIR)/skgw.conf
$(SRV_DIR)/skgw.conf: $(SKDB_CLI) $(SKDB_DATABASES) $(SKDB_CMD) $(SKDB_INIT)
	@echo "skdb_port=8110" > $(SRV_DIR)/skgw.conf
	@echo "skdb_databases=$(SKDB_DATABASES)" >> $(SRV_DIR)/skgw.conf
	@echo "skdb=$(SKDB_CMD)" >> $(SRV_DIR)/skgw.conf
	@echo "skdb_init=$(SKDB_INIT)" >> $(SRV_DIR)/skgw.conf
	@echo "skdb_add_cred=cd $(SKDB_CLI_DIR) && node $(SKDB_CLI_CMD) --add-cred --host ws://localhost:%d --db %s --access-key %s <<< \"%s\"" >> $(SRV_DIR)/skgw.conf

$(SKDB_DATABASES):
	@mkdir -p $(SKDB_DATABASES)

$(SKDB_CMD):
	@cd $(REAL_DIR);skargo b --release
