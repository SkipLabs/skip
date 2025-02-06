SHELL := /bin/bash

SKARGO_PROFILE?=release
NPM_WORKSPACES=$(shell jq --raw-output "[.workspaces[] | select((startswith(\"sql\") or contains(\"examples\")) | not)] | map(\"-w \" + .) | .[]" ../package.json)

.PHONY: build
build:
	../bin/cd_sh .. "npm install $(NPM_WORKSPACES) && npm run build $(NPM_WORKSPACES) --if-present"

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

.PHONY: test
test: build
	../bin/cd_sh tests "npm run test"

build-examples:
	../bin/cd_sh examples "npm install && npm run build"

test-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*.out /tmp/$*.err"
	diff /tmp/$*.out tests/examples/$*.exp.out
	diff /tmp/$*.err tests/examples/$*.exp.err


EXAMPLES := $(patsubst tests/examples/%.sh,%,$(wildcard tests/examples/*.sh))

EXAMPLE_TARGETS := $(patsubst %,test-example-%,$(EXAMPLES))
.PHONY: test-examples
test-examples: build-examples $(EXAMPLE_TARGETS)

.PHONY: test-error-types
test-error-types: # Best-effort check that we don't throw generic JS errors; prefer some version of SkipError instead.
	grep -qr "throw new Error" $(CURDIR) \
	--exclude-dir node_modules \
	--exclude-dir dist \
	--exclude-dir native \
	--exclude-dir examples \
	--exclude-dir tests

regen-%:
	cd tests/examples && ./$*.sh ../tests/examples/$*.exp.out ../tests/examples/$*.exp.err

REGEN_TARGETS := $(patsubst %,regen-%,$(EXAMPLES))
.PHONY: regenerate-expectations
regenerate-expectations: build build-examples $(REGEN_TARGETS)
