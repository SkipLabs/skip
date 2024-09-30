SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: check-src
check-src: build
	echo "make: Entering directory '${SCRIPT_DIR}/ts'"
	cd ts/ && npm run lint
	echo "make: Leaving directory '${SCRIPT_DIR}/ts'"

.PHONY: check-tests
check-tests: eslint
	cd ts/tests && npm install && npm run build && npm run lint

.PHONY: check-all
check-all: check-src check-tests

.PHONY: build
build:
	cd .. && npm i && npm run build

.PHONY: clean
clean:
	rm -rf ./ts/dist ./ts/playwright-report ./ts/test-results 
	cd .. && make clean

.PHONY: install-test
install-test: build
	cd ts/tests && npx playwright install

.PHONY: test
test: install-test
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_server.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_mux.mk
	cd ts/tests && npx playwright test --reporter=line

.PHONY: test-client-node
test-client-node: install-test
	cd ts/tests && npx playwright test --reporter=line node.play.ts

.PHONY: test-client-browser
test-client-browser: install-test
	cd ts/tests && npx playwright test --reporter=line browser.play.ts

.PHONY: test-client
test-client: install-test
	cd ts/tests && npx playwright test --reporter=line browser.play.ts node.play.ts

.PHONY: test-server
test-server: install-test
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_server.mk
	cd ts/tests && npx playwright test --reporter=line node.play.server.ts

.PHONY: test-mux-node
test-mux-node: install-test
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_mux.mk
	cd ts/tests && npx playwright test --reporter=line node.play.mux.ts

.PHONY: test-mux-browser
test-mux-browser: install-test
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_mux.mk
	cd ts/tests && npx playwright test --reporter=line browser.play.mux.ts

.PHONY: test-mux
test-mux: install-test
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_mux.mk
	cd ts/tests && npx playwright test --reporter=line browser.play.mux.ts node.play.mux.ts
