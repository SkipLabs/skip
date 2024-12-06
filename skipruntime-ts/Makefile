SHELL := /bin/bash

SKARGO_PROFILE?=release

.PHONY: build
build:
	../bin/cd_sh .. "npm install && npm run build"

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
