SHELL := /bin/bash

SKARGO_PROFILE?=release
NPM_WORKSPACES=$(shell jq --raw-output "[.workspaces[] | select((startswith(\"sql\") or contains(\"examples\")) | not)] | map(\"-w \" + .) | .[]" ../package.json)

.PHONY: build
build:
	../bin/cd_sh .. "SKIPRUNTIME=$$(dirname $(CURDIR))/build/skipruntime npm install $(NPM_WORKSPACES) && npm run build $(NPM_WORKSPACES) --if-present"

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
	cd examples && npm install && npm run build

test-example-%:
	cd tests/examples && ./$*.sh /tmp/$*.out /tmp/$*.err
	diff /tmp/$*.out tests/examples/$*.exp.out >/dev/null
	diff /tmp/$*.err tests/examples/$*.exp.err >/dev/null

.PHONY: test-examples
test-examples: build-examples test-example-groups test-example-database test-example-departures test-example-remote test-example-sheet test-example-sum
