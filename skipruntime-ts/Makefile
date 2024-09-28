SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))


.PHONY: check-src
check-src: build
	echo "make: Entering directory '${SCRIPT_DIR}/core'"
	cd core && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/core'"

.PHONY: check-examples
check-examples: build
	echo "make: Entering directory '${SCRIPT_DIR}/examples'"
	cd examples && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/examples'"

.PHONY: check-all
check-all: build check-src check-examples

.PHONY: build
build:
	cd .. && npm install && npm run build

.PHONY: bunbuild
bunbuild:
	cd .. && bum install && bun run build

bunrun-%: bunbuild
	bun run examples/$*.ts

bunclient-%: bunbuild
	bun run examples/$*-client.ts

bunserver-%: bunbuild
	bun run examples/$*-server.ts

noderun-%: build
	node examples/dist/$*.js

nodeclient-%: build
	node examples/dist/$*-client.js

nodeserver-%: build
	node examples/dist/&*-server.js

.PHONY: clean
clean:
	cd .. && make clean

.PHONY: test
test: build
	cd core && npm run test
