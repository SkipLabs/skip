SHELL := /bin/bash

SKARGO_PROFILE?=release
NPM_WORKSPACES=$(shell jq --raw-output "[.workspaces[] | select((startswith(\"sql\") or contains(\"examples\")) | not)] | map(\"-w \" + .) | .[]" ../package.json)
SKIPRUNTIME?=$(realpath $(CURDIR)/..)/build/skipruntime

export SKIPRUNTIME

.PHONY: install
install:
	../bin/cd_sh .. "pnpm install $(NPM_WORKSPACES)"

.PHONY: install-all
install-all:
	../bin/cd_sh .. "pnpm install"

.PHONY: build
build:
	../bin/cd_sh .. "pnpm run build $(NPM_WORKSPACES) --if-present"

bunrun-%: build
	bun run examples/$*.ts

bunclient-%:
	bun run examples/$*-client.ts

bunserver-%:
	bun run examples/$*-server.ts

noderun-%: build
	node examples/dist/$*.js

nodeclient-%:
	cd examples && tsc
	node examples/dist/$*-client.js

nodeserver-%:
	cd examples && tsc
	node examples/dist/$*-server.js

.PHONY: clean
clean:
	make -C .. clean

.PHONY: run-test
run-test:
	../bin/cd_sh tests "pnpm run test"

.PHONY: test
test: install build run-test

.PHONY: build-examples
build-examples: build
	../bin/cd_sh examples "pnpm run build -w skipruntime-examples"

test-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*.out /tmp/$*.err"
	diff /tmp/$*.out tests/examples/$*.exp.out
	diff /tmp/$*.err tests/examples/$*.exp.err

test-wasm-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*-wasm.out /tmp/$*-wasm.err"
	diff /tmp/$*-wasm.out tests/examples/$*.exp.out
	diff /tmp/$*-wasm.err tests/examples/$*.exp.err

test-native-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*-native.out /tmp/$*-native.err native"
	diff /tmp/$*-native.out tests/examples/$*.exp.out
	diff /tmp/$*-native.err tests/examples/$*.exp.err

EXAMPLES := $(patsubst tests/examples/%.sh,%,$(wildcard tests/examples/*.sh))

.PHONY: test-wasm-examples
test-wasm-examples: $(patsubst %,test-wasm-example-%,$(EXAMPLES))

.PHONY: test-native-examples
test-native-examples: $(patsubst %,test-native-example-%,$(EXAMPLES))

.PHONY: test-error-types
test-error-types: # Best-effort check that we don't throw generic JS errors; prefer some version of SkipError instead.
	grep -qr "throw new Error" $(CURDIR) \
	--exclude-dir node_modules \
	--exclude-dir dist \
	--exclude-dir native \
	--exclude-dir examples \
	--exclude-dir tests

.PHONY: test-all
test-all: install-all build-examples run-test test-wasm-examples test-native-examples test-error-types

regen-%:
	cd tests/examples && ./$*.sh ../tests/examples/$*.exp.out ../tests/examples/$*.exp.err

REGEN_TARGETS := $(patsubst %,regen-%,$(EXAMPLES))
.PHONY: regenerate-expectations
regenerate-expectations: build-examples $(REGEN_TARGETS)
