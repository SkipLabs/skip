SHELL := /bin/bash

SKARGO_PROFILE?=release
NPM_WORKSPACES=\
    -w eslint-config\
    -w tsconfig\
    -w skiplang/prelude/ts/binding\
    -w skiplang/prelude/ts/wasm\
    -w skiplang/skdate/ts\
    -w skiplang/skjson/ts/binding\
    -w skiplang/skjson/ts/wasm\
    -w skipruntime-ts/api\
    -w skipruntime-ts/core\
    -w skipruntime-ts/helpers\
    -w skipruntime-ts/tests\
    -w skipruntime-ts/wasm\
    -w skipruntime-ts/addon\
    -w skipruntime-ts/runtime\
    -w skipruntime-ts/server\
    -w skipruntime-ts/examples

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
	../bin/cd_sh wasm "bun run test"

.PHONY: test-native
test-native: build
	../bin/cd_sh addon "npm run test"
