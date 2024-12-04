SHELL := /bin/bash

SKARGO_PROFILE?=release


.PHONY: check-src
check-src:
	../bin/cd_sh wasm "bun run tsc && bun run lint"
	../bin/cd_sh server "bun run tsc && bun run lint"

.PHONY: check-examples
check-examples:
	../bin/cd_sh examples "bun run tsc && bun run lint"

.PHONY: check-all
check-all: build check-src check-examples

.PHONY: build
build:
	../bin/cd_sh .. "npm install && npm run build"

.PHONY: bunbuild
bunbuild:
	../bin/cd_sh .. "bun install && npm run build"

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
	node examples/dist/$*-server.js

.PHONY: clean
clean:
	make -C .. clean

.PHONY: test
test: build
	../bin/cd_sh wasm "bun run test"

.PHONY: test-native
test-native: build
	../bin/cd_sh addon "npm run test"
