SHELL := /bin/bash

SKARGO_PROFILE?=release
NPM_WORKSPACES=$(shell jq --raw-output "[.workspaces[] | select((startswith(\"sql\") or contains(\"examples\")) | not)] | map(\"-w \" + .) | .[]" ../package.json)

.PHONY: default
default: install

# tell skipruntime-ts/addon build script to link unversioned libskipruntime.so
export SKIPRUNTIME_VERSION=dev
# config linker to find libskipruntime.so
export LDFLAGS=-L$(realpath $(CURDIR)/..)/build/skipruntime/
export LD_LIBRARY_PATH=$(realpath $(CURDIR)/..)/build/skipruntime/

define check_out
	@result=$$(diff $(1) $(2)); \
	code=$$?; \
	if [ $$code -ne 0 ] && [ -e $(2).alt ]; then \
		result=$$(diff $(1) $(2).alt); \
		code=$$?; \
	fi; \
	if [ $$code -ne 0 ]; then \
		echo "$$result"; \
	fi
endef

.PHONY: libskipruntime
libskipruntime:
	skargo build --release --lib --manifest-path=skiplang/ffi/Skargo.toml --out-dir=../build/skipruntime/

.PHONY: install
install: libskipruntime
	../bin/cd_sh .. "npm install $(NPM_WORKSPACES)"

.PHONY: install-all
install-all: libskipruntime
	../bin/cd_sh .. "npm install"

.PHONY: check-ts
check-ts: install-all
	../bin/check-ts.sh

.PHONY: build
build: install
	../bin/cd_sh .. "npm run build $(NPM_WORKSPACES) --if-present"

.PHONY: docs
docs: build
	../bin/cd_sh ../www "rm -rf docs/api && npm install && npx docusaurus generate-typedoc"

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

.PHONY: build-examples
build-examples: build
	../bin/cd_sh examples "npm run build -w skipruntime-examples"

test-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*.out /tmp/$*.err"
	@echo "diff /tmp/$*.out tests/examples/$*.exp.out"
	$(call check_out,/tmp/$*.out,tests/examples/$*.exp.out)
	diff /tmp/$*.err tests/examples/$*.exp.err

test-wasm-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*-wasm.out /tmp/$*-wasm.err"
	@echo "diff /tmp/$*-wasm.out tests/examples/$*.exp.out"
	$(call check_out,/tmp/$*-wasm.out,tests/examples/$*.exp.out)
	diff /tmp/$*-wasm.err tests/examples/$*.exp.err

test-native-example-%:
	../bin/cd_sh tests/examples "./$*.sh /tmp/$*-native.out /tmp/$*-native.err native"
	@echo "diff /tmp/$*-native.out tests/examples/$*.exp.out"
	$(call check_out,/tmp/$*-native.out,tests/examples/$*.exp.out)
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
test-all: install-all test build-examples test-wasm-examples test-native-examples test-error-types

regen-%:
	cd tests/examples && ./$*.sh ../tests/examples/$*.exp.out ../tests/examples/$*.exp.err

REGEN_TARGETS := $(patsubst %,regen-%,$(EXAMPLES))
.PHONY: regenerate-expectations
regenerate-expectations: build-examples $(REGEN_TARGETS)
