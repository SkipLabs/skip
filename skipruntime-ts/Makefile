SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))


.PHONY: replication
replication:
	cd ../replication && npm i && npm run build

.PHONY: skjson
skjson:
	cd ../skjson/ts && npm i && npm run build

.PHONY: prelude
prelude:
	cd ../prelude/ts && npm i && npm run build

.PHONY: eslint-config
eslint-config:
	cd ../eslint-config && npm i

.PHONY: check-src
check-src: eslint-config prelude skjson replication
	echo "make: Entering directory '${SCRIPT_DIR}/ts'"
	cd ts && npm install && npm run build && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts'"

.PHONY: check-examples
check-examples: eslint-config prelude skjson replication
	cd ts && npm i && npm run build
	cd ts/examples && npm install
	echo "make: Entering directory '${SCRIPT_DIR}/ts/examples'"
	cd ts/examples && npm run build && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts/examples'"

.PHONY: check-tests
check-tests: eslint-config prelude skjson replication
	cd ts && npm i && npm run build
	cd ts/tests && npm install && npm run build && npm run lint

.PHONY: check-all
check-all: check-src # check-tests check-examples

.PHONY: build
build: prelude skjson replication
	cd ts && npm i && npm run build

bunrun-%: build
	cd ts/examples && bun install && bun run $*.ts

bunclient-%:
	cd ts/examples && bun install && bun run $*-client.ts

check-%:
	cd ts/examples && npm install
	npx tsc -- --project ts/examples/tsconfig.json

noderun-%: build
	cd ts/examples && npm install
	npx tsc -- --project ts/examples/tsconfig.json
	cd ts/examples && node dist/$*.js

nodeclient-%:
	cd ts/examples && node dist/$*-client.js

.PHONY: clean
clean:
	rm -rf ./ts/dist ./ts/playwright-report ./ts/test-results
	cd .. && make clean

.PHONY: test
test: build
	cd ts/tests && npm i && npm run build
	cd ts/tests && npx playwright install
	cd ts/tests && npx playwright test --reporter=line
