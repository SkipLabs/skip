SHELL := /bin/bash

SKARGO_PROFILE?=release

SCRIPT_DIR=$(shell dirname $(shell realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: check-src
check-src: build
	../bin/cd_sh .. "npm run lint -w skdb"

.PHONY: check-tests
check-tests: build
	../bin/cd_sh .. "npm run lint -w skdb-tests"

.PHONY: check-all
check-all: check-src check-tests

.PHONY: build
build:
#	install-all-no-native only for its side effect of installing skdb/skdb-tests'
#	npm deps (NPM_WORKSPACES excludes sql, so this is the target that covers them);
#	nothing under sql/ links libskipruntime, so skip building it.
	${MAKE} -C ../skipruntime-ts install-all-no-native
	../bin/cd_sh .. "npm run build -w skdb -w skdb-tests"

.PHONY: clean
clean:
	rm -rf ./ts/dist ./ts/playwright-report ./ts/test-results 
	cd .. && make clean

.PHONY: install-test
install-test: build
	cd ts/tests && npx playwright install


.PHONY: run-test
run-test:
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_common.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_server.mk
	cd ts/tests && make ROOT_DIR=${SCRIPT_DIR} -f service_mux.mk
	cd ts/tests && ./run-playwright.sh

.PHONY: test
test: install-test run-test

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
	cd ts/tests && npx playwright test --reporter=line --timeout=60000 node.play.server.ts

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
