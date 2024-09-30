SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))


.PHONY: check-src
check-src: build
	echo "make: Entering directory '${SCRIPT_DIR}/ts'"
	cd ts && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts'"

.PHONY: check-examples
check-examples: build
	echo "make: Entering directory '${SCRIPT_DIR}/ts/examples'"
	cd ts/examples && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts/examples'"

.PHONY: check-all
check-all: build check-src check-examples

.PHONY: build
build:
	cd .. && npm install && npm run build

.PHONY: bunbuild
bunbuild:
	cd .. && bum install && bun run build

bunrun-%: bunbuild
	bun run ts/examples/$*.ts

bunclient-%: bunbuild
	bun run ts/examples/$*-client.ts

bunserver-%: bunbuild
	bun run ts/examples/$*-server.ts

noderun-%: build
	node ts/examples/dist/$*.js

nodeclient-%: build
	node ts/examples/dist/$*-client.js

nodeserver-%: build
	node ts/examples/dist/&*-server.js

.PHONY: clean
clean:
	cd .. && make clean

.PHONY: test
test: build
	cd ts && npm run test
