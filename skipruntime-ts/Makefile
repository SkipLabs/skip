
SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))

../build/sknpm:
	cd .. && make build/sknpm

.PHONY: check-src
check-src:
	echo "make: Entering directory '${SCRIPT_DIR}/ts/src'"
	cd ts/src && npm install && tsc && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts/src'"

.PHONY: check-examples
check-examples: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --nowasm --out-dir ts/examples/node_modules/skip-runtime
	echo "make: Entering directory '${SCRIPT_DIR}/ts/examples'"
	cd ts/examples && tsc && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts/examples'"

.PHONY: check-tests
check-tests:
	cd ts/tests && npm install
	cd ts/tests && tsc

.PHONY: check-all
check-all: check-src check-examples check check-tests

build: ../build/sknpm
	cd ts/examples && bun install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skip-runtime

bunrun-%: ../build/sknpm
	cd ts/examples && bun install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skip-runtime
	cd ts/examples && bun run $*.ts

bunclient-%:
	cd ts/examples && bun run $*-client.ts

check: ../build/sknpm
	../build/sknpm check
	../build/sknpm check --test

check-%: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --nowasm --out-dir ts/examples/node_modules/skip-runtime
	tsc --project ts/examples/tsconfig.json

noderun-%: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skip-runtime
	tsc --project ts/examples/tsconfig.json
	cd ts/examples && node dist/$*.js

nodeclient-%:
	cd ts/examples && node dist/$*-client.js
