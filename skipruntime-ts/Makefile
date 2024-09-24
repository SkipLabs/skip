SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))


.PHONY: replication
replication:
	cd ../replication && npm i && tsc

.PHONY: skjson
skjson:
	cd ../skjson/ts && npm i && tsc

.PHONY: prelude
prelude:
	cd ../prelude/ts && npm i && tsc

.PHONY: check-src
check-src:
	echo "make: Entering directory '${SCRIPT_DIR}/ts'"
	cd ts && npm install && tsc && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts'"

.PHONY: check-examples
check-examples:
	cd ts/examples && npm install
	echo "make: Entering directory '${SCRIPT_DIR}/ts/examples'"
	cd ts/examples && tsc && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts/examples'"

.PHONY: check-tests
check-tests:
	cd ts/tests && npm install && tsc && npm run lint

.PHONY: check-all
check-all: check-src check-examples check-tests

.PHONY: build
build: prelude skjson replication
	cd ts && npm i && tsc
	skargo build -r --target wasm32-unknown-unknown --lib --out-dir=./ts/dist/

bunrun-%: build
	cd ts/examples && bun install && bun run $*.ts

bunclient-%:
	cd ts/examples && bun install && bun run $*-client.ts

check-%:
	cd ts/examples && npm install
	tsc --project ts/examples/tsconfig.json

noderun-%: build
	cd ts/examples && npm install
	tsc --project ts/examples/tsconfig.json
	cd ts/examples && node dist/$*.js

nodeclient-%:
	cd ts/examples && node dist/$*-client.js

.PHONY: clean
clean:
	rm -rf ./ts/dist ./ts/playwright-report ./ts/test-results
	cd .. && make clean

.PHONY: test
test: build
	cd ts/tests && npm i && tsc
	cd ts/tests && npx playwright install
	cd ts/tests && npx playwright test --reporter=line
