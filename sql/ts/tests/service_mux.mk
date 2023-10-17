SHELL := /bin/bash

SRV_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))
ifndef ROOT_DIR
$(error ROOT_DIR must be defined.)
endif

SDKMAN_DIR?=$(HOME)/.sdkman
MAKEFLAGS += --no-print-directory

REAL_DIR=$(shell realpath $(ROOT_DIR))
SERVER_DIR=$(ROOT_DIR)/server
SKGW_DIR=$(SERVER_DIR)/skgw
SKDB_DATABASES=$(SRV_DIR)/dbs

default: run

.PHONY: run
run:
	$(SRV_DIR)/service_mux.sh $(SDKMAN_DIR) $(SKGW_DIR) $(SKDB_DATABASES)