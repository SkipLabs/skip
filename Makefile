# this builds the artifacts of this repository, orchestrating the
# various build systems

.PHONY: all
all: npm build/skdb build/init.sql

PRETTIER_LOG_LEVEL?=warn

PLAYWRIGHT_REPORTER?="line"
SKARGO_PROFILE?=release
SKDB_WASM=sql/target/wasm32-unknown-unknown/$(SKARGO_PROFILE)/skdb.wasm
SKDB_BIN=sql/target/host/$(SKARGO_PROFILE)/skdb
SDKMAN_DIR?=$(HOME)/.sdkman

################################################################################
# skdb wasm + js client
################################################################################

.PHONY: npm
npm: $(SKDB_WASM) build/package/skdb build/package/package.json
	cd build/package && npm install

build/package/package.json:
	@echo "{" > build/package/package.json
	@echo "  \"dependencies\": {" >> build/package/package.json
	@echo "      \"skdb\": \"file:skdb\"" >> build/package/package.json
	@echo "  }" >> build/package/package.json
	@echo "}" >> build/package/package.json

sql/target/wasm32-unknown-unknown/dev/skdb.wasm: sql/src/*
	cd sql && skargo build --target wasm32-unknown-unknown --bin skdb

sql/target/wasm32-unknown-unknown/release/skdb.wasm: sql/src/*
	cd sql && skargo build --release --target wasm32-unknown-unknown --bin skdb

$(SDKMAN_DIR):
	cd $(dirname $(SDKMAN_DIR)) && sh -c 'wget -q -O- "https://get.sdkman.io?rcupdate=false" | bash'

################################################################################
# skdb native binary
################################################################################

sql/target/host/dev/skdb: sql/src/* skiplang/prelude/src/**/*.sk skiplang/skdate/src/* skiplang/skjson/src/* skiplang/sqlparser/src/*
	cd sql && skargo build

sql/target/host/release/skdb: sql/src/* skiplang/prelude/src/**/*.sk skiplang/skdate/src/* skiplang/skjson/src/* skiplang/sqlparser/src/*
	cd sql && skargo build --release --bin skdb

# TODO: keeping this for now as nearly all test scripts refer to build/skdb
build/skdb: $(SKDB_BIN)
	mkdir -p build
	cp $^ $@

################################################################################
# skdb server
################################################################################

build/init.sql: sql/privacy/init.sql
	mkdir -p build
	cp $^ $@

################################################################################
# dev workflow orchestration
################################################################################

.PHONY: update-js-deps
update-js-deps:
	find . -name node_modules -not -prune -or -name target -not -prune -or -name package.json -exec sh -c 'cd $$(dirname "$$0"); bun update --latest' {} \;

.PHONY: check
check:
	find * -name Skargo.toml -exec sh -c 'bin/cd_sh $$(dirname {}) "skargo check"' \;

.PHONY: check-ts
check-ts:	
#	delegate to pick up build-time config for libskipruntime
	${MAKE} -C skipruntime-ts check-ts

.PHONY: check-sh
check-sh:
	find . -name node_modules -not -prune -or \
	       -name libbacktrace -not -prune -or \
		   -name tnt-tpch -not -prune -or \
		   -name "*.sh" | xargs shellcheck --exclude SC2181 --exclude SC2002

.PHONY: clean
clean:
	rm -Rf build
	find . -name 'Skargo.toml' -print0 | sed 's|Skargo.toml|target|g' | xargs -0 rm -rf
	npm run clean

.PHONY: clean-all
clean-all: clean
	find . -type d -name 'node_modules' -prune -print0 | xargs -0 rm -rf

.PHONY: fmt-sk
fmt-sk: # Keep in sync with bin/git_hooks/check_format.sh
	find . -path ./skiplang/compiler/tests -not -prune -or -name \*.sk | parallel skfmt -i {}

.PHONY: fmt-c
fmt-c: # Keep in sync with bin/git_hooks/check_format.sh
	find . -path ./node_modules -not -prune -or -path ./skiplang/prelude/libbacktrace -not -prune -or -path ./sql/test/TPC-h/tnt-tpch -not -prune -or -regex '.*\.\(c\|cc\|cpp\|h\|hh\|hpp\)' | parallel clang-format -i {}

.PHONY: fmt-js
fmt-js: # Keep in sync with bin/git_hooks/check_format.sh
	npx prettier --log-level $(PRETTIER_LOG_LEVEL) --write .
	npx prettier --log-level $(PRETTIER_LOG_LEVEL) --write --parser=json skipruntime-ts/addon/binding.gyp


.PHONY: fmt-py
fmt-py: # Keep in sync with bin/git_hooks/check_format.sh
	black --quiet --line-length 80 .

.PHONY: fmt
fmt: fmt-sk fmt-c fmt-js fmt-py # Keep in sync with bin/git_hooks/check_format.sh

.PHONY: check-fmt
check-fmt:
	PRETTIER_LOG_LEVEL=debug ${MAKE} fmt
	if ! git diff --quiet --exit-code; then echo "make fmt changed some files:"; git status --porcelain; exit 1; fi

# regenerate api docs served by docs-run from ts sources
.PHONY: docs
docs:
	npm install && npm run build
	cd www && rm -rf docs/api && npm install && npx docusaurus generate-typedoc

# run the docs site locally at http://localhost:3000
.PHONY: docs-run
docs-run: # depends on docs, but can't be tracked reliably
	cd www && npm run start

# generate the docs site as static files
.PHONY: docs-build
docs-build: docs
	cd www && rm -rf build && npm run build

# run the static docs site locally
.PHONY: docs-serve
docs-serve: # depends on docs-build, but can't be tracked reliably
	cd www && npm run serve

# update the static docs site repo
.PHONY: docs-publish
docs-publish: docs-build
	cd www && rsync --archive --exclude=.git --exclude=README.md --delete build/ docs_site/
	@echo "Test locally: make docs-serve"
	@echo "Push to live site: cd www/docs_site/; git add -A; git commit -m 'update to $(shell git describe --always)'; git push; cd -"

# install the repo pre-commit hook locally
.git/hooks/pre-commit: bin/git_hooks/check_format.sh
	ln -s $(PWD)/bin/git_hooks/check_format.sh .git/hooks/pre-commit

.PHONY: setup-git-hooks
setup-git-hooks: .git/hooks/pre-commit


# test targets

.PHONY: test
test:
	$(MAKE) --keep-going SKARGO_PROFILE=dev SKDB_WASM=sql/target/wasm32-unknown-unknown/dev/skdb.wasm SKDB_BIN=sql/target/host/dev/skdb test-prelude test-skjson test-skipruntime-ts test-native test-wasm

.PHONY: test-prelude
test-prelude:
	bin/cd_sh skiplang/prelude "skargo test --profile $(SKARGO_PROFILE)"

.PHONY: test-skjson
test-skjson:
	bin/cd_sh skiplang/skjson "skargo test --profile $(SKARGO_PROFILE)"

.PHONY: test-skipruntime-ts
test-skipruntime-ts:
	$(MAKE) -C skipruntime-ts test-all

test-%:
	cd $* && skargo test --profile $(SKARGO_PROFILE)

.PHONY: test-native
test-native: build/skdb
	cd sql/ && SKARGO_PROFILE=$(SKARGO_PROFILE) SKDB_BIN=$(realpath build/skdb) ./test_sql.sh \
	|tee /tmp/native-test.out ; \
	! grep -v '\*\|^[[:blank:]]*$$\|OK\|PASS' /tmp/native-test.out

.PHONY: test-wasm
test-wasm:
	cd sql && make test

.PHONY: test-client
test-client:
	cd sql && make test-client

.PHONY: test-replication
test-replication: build/skdb
	./sql/test/replication/test_pk.py
	./sql/test/replication/test_no_pk.py

.PHONY: test-tpc
test-tpc: test
	@echo ""
	@echo "*******************************************************************************"
	@echo "* TPC-H *"
	@echo "*******************************************************************************"
	@echo ""
	@cd sql/test/TPC-h/ && ./test_tpch.sh

.PHONY: test-soak-priv
test-soak-priv: build/skdb build/init.sql npm
	./sql/server/test/test_soak.sh

.PHONY: test-soak
test-soak:
	$(MAKE) SKARGO_PROFILE=release test-soak-priv

# run targets

.PHONY: run-dev-server
run-dev-server: sql/target/host/dev/skdb build/init.sql
	mkdir -p build
	cp sql/target/host/dev/skdb build
	(cd sql/server/dev && gradle --console plain run)

# useful for testing in a browser
build/index.html: sql/js/index.html
	mkdir -p build
	cp $^ $@

.PHONY: check-vite
check-vite: npm
	rm -rf build/vitejs
	cp -r sql/ts/vitejs build/vitejs
	cd build/vitejs && npm install;
	rm -r build/vitejs/node_modules/skdb
	cp -r build/package/skdb build/vitejs/node_modules/
	cd build/vitejs && npm run build
	cd build/vitejs && node server.js
	cd build/vitejs && npm run dev

.PHONY: test-bun
test-bun: npm
	rm -rf build/bun
	cp -r sql/ts/bun build/bun
	cd build/bun && bun install;
	rm -r build/bun/node_modules/skdb
	cp -r build/package/skdb build/bun/node_modules/
	cd build/bun && bun bun.js true && bun bun.js false

skcheck-%:
	cd $* && skargo c --profile $(SKARGO_PROFILE)

skfmt-%:
	cd $* && skargo fmt

skbuild-%:
	cd $* && skargo b --profile $(SKARGO_PROFILE)

.PHONY: publish-core
publish-core:
	bin/release_npm.sh @skipruntime/core skipruntime-ts/core/package.json $(OTP)

.PHONY: publish-helpers
publish-helpers:
	bin/release_npm.sh @skipruntime/helpers skipruntime-ts/helpers/package.json $(OTP)

.PHONY: publish-wasm
publish-wasm:
	bin/release_npm.sh @skipruntime/wasm skipruntime-ts/wasm/package.json $(OTP)

.PHONY: publish-native
publish-native:
	bin/release_npm.sh @skipruntime/native skipruntime-ts/addon/package.json $(OTP)

.PHONY: publish-server
publish-server:
	bin/release_npm.sh @skipruntime/server skipruntime-ts/server/package.json $(OTP)

.PHONY: publish-postgres-adapter
publish-postgres-adapter:
	bin/release_npm.sh @skip-adapter/postgres skipruntime-ts/adapters/postgres/package.json $(OTP)

.PHONY: publish-kafka-adapter
publish-kafka-adapter:
	bin/release_npm.sh @skip-adapter/kafka skipruntime-ts/adapters/kafka/package.json $(OTP)

.PHONY: publish-metapackage
publish-metapackage:
	bin/release_npm.sh @skiplabs/skip skipruntime-ts/metapackage/package.json $(OTP)

.PHONY: publish-all
publish-all: clean publish-core publish-helpers publish-wasm publish-native publish-server publish-postgres-adapter publish-kafka-adapter publish-metapackage
