# this builds the artifacts of this repository, orchestrating the
# various build systems

.PHONY: default
default: check check-ts

PRETTIER_LOG_LEVEL?=warn
PRETTIER_VERSION:=$(shell jq -r '.devDependencies.prettier' package.json)
BLACK_VERSION:=$(shell grep '^black==' requirements-dev.txt | cut -d'=' -f3)

PLAYWRIGHT_REPORTER?="line"
SKARGO_PROFILE?=release
SKDB_WASM=sql/target/wasm32-unknown-unknown/$(SKARGO_PROFILE)/skdb.wasm
SKDB_BIN=sql/target/host/$(SKARGO_PROFILE)/skdb
SDKMAN_DIR?=$(HOME)/.sdkman

.PHONY: skdb
skdb: npm build/skdb build/init.sql

################################################################################
# skdb wasm + js client
################################################################################

.PHONY: npm
npm: $(SKDB_WASM) build/package/skdb build/package/package.json
	cd build/package && npm install

# Assemble the publishable skdb layout from sql/ts.  Mirrors what
# `npm publish` from sql/ts/ would ship (dist/, package.json, README).
# Consumed by `make check-vite` and `make test-bun` which cp it into a
# scaffolded node_modules to smoke-test consumer installs.
build/package/skdb: $(SKDB_WASM)
	cd sql/ts && npm run build
	rm -rf $@
	mkdir -p $@
	cp -r sql/ts/dist sql/ts/package.json $@/
	[ -f sql/ts/README.md ] && cp sql/ts/README.md $@/ || true

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

.PHONY: libbacktrace
libbacktrace:
	$(MAKE) -C skiplang/prelude libbacktrace

.PHONY: check
check: libbacktrace
	@set -e; \
	find . \( -name node_modules -o -name target \) -prune -o -name Skargo.toml -print | \
	while read -r manifest; do bin/cd_sh "$$(dirname "$$manifest")" "skargo check"; done

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
	find . \( -path ./skiplang/compiler/tests -o -path ./skiplang/compiler/invalid_tests \) -not -prune -or -name \*.sk | parallel skfmt -i {}

.PHONY: fmt-c
fmt-c: # Keep in sync with bin/git_hooks/check_format.sh
	find . -path ./node_modules -not -prune -or -path ./skiplang/prelude/libbacktrace -not -prune -or -path ./sql/test/TPC-h/tnt-tpch -not -prune -or -regex '.*\.\(c\|cc\|cpp\|h\|hh\|hpp\)' | parallel clang-format -i {}

.PHONY: fmt-js
fmt-js: # Keep in sync with bin/git_hooks/check_format.sh
	npx -y prettier@$(PRETTIER_VERSION) --log-level $(PRETTIER_LOG_LEVEL) --write .
	npx -y prettier@$(PRETTIER_VERSION) --log-level $(PRETTIER_LOG_LEVEL) --write --parser=json skipruntime-ts/addon/binding.gyp


.PHONY: fmt-py
fmt-py: # Keep in sync with bin/git_hooks/check_format.sh
	pip install -q --break-system-packages black==$(BLACK_VERSION) && black --quiet --line-length 80 .

.PHONY: fmt
fmt: fmt-sk fmt-c fmt-js fmt-py # Keep in sync with bin/git_hooks/check_format.sh

.PHONY: check-fmt
check-fmt:
	PRETTIER_LOG_LEVEL=debug ${MAKE} fmt
	if ! git diff --quiet --exit-code; then echo "make fmt changed some files:"; git status --porcelain; exit 1; fi

# regenerate api docs served by docs-run from ts sources
.PHONY: docs
docs:	
#	delegate to pick up build-time config for libskipruntime
	${MAKE} -C skipruntime-ts docs

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
test: libbacktrace
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

.PHONY: test-skipruntime-ts-bun
test-skipruntime-ts-bun:
	$(MAKE) -C skipruntime-ts test-skipruntime-ts-bun

test-%:
	cd $* && skargo test --profile $(SKARGO_PROFILE)

.PHONY: test-native
test-native: build/skdb
	cd sql && skargo test --profile $(SKARGO_PROFILE)
	@cd sql/ && SKARGO_PROFILE=$(SKARGO_PROFILE) SKDB_BIN=$(realpath build/skdb) ./test_sql.sh \
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

# Build every workspace package in dependency order. Required before the
# publish-* targets that ship built artifacts, so that downstream packages can
# see their dependencies' emitted .d.ts and .js (which release_npm.sh's
# idempotent skip-if-already-published check would otherwise bypass).
.PHONY: build-all
build-all:
	npm run build --workspaces --if-present

# @skiplabs/tsconfig and @skiplabs/eslint-config are pure configuration
# packages: no build step, no emitted artifacts, and nothing depends on them at
# build time. They can be published without the (slow, toolchain-dependent)
# build-all -- notably even when the Skip compiler cannot be built.
.PHONY: publish-tsconfig
publish-tsconfig:
	bin/release_npm.sh @skiplabs/tsconfig tsconfig/package.json $(OTP)

.PHONY: publish-eslint-config
publish-eslint-config:
	bin/release_npm.sh @skiplabs/eslint-config eslint-config/package.json $(OTP)

.PHONY: publish-skiplang-std
publish-skiplang-std: build-all
	bin/release_npm.sh @skiplang/std skiplang/prelude/ts/binding/package.json $(OTP)

.PHONY: publish-skiplang-json
publish-skiplang-json: build-all
	bin/release_npm.sh @skiplang/json skiplang/skjson/ts/binding/package.json $(OTP)

.PHONY: publish-skip-wasm-std
publish-skip-wasm-std: build-all
	bin/release_npm.sh @skip-wasm/std skiplang/prelude/ts/wasm/package.json $(OTP)

.PHONY: publish-skip-wasm-worker
publish-skip-wasm-worker: build-all
	bin/release_npm.sh @skip-wasm/worker skiplang/prelude/ts/worker/package.json $(OTP)

.PHONY: publish-skip-wasm-json
publish-skip-wasm-json: build-all
	bin/release_npm.sh @skip-wasm/json skiplang/skjson/ts/wasm/package.json $(OTP)

# @skip-wasm/date depends on @skip-wasm/std, so publish std first.
.PHONY: publish-skip-wasm-date
publish-skip-wasm-date: build-all publish-skip-wasm-std
	bin/release_npm.sh @skip-wasm/date skiplang/skdate/ts/package.json $(OTP)

.PHONY: publish-core
publish-core: build-all
	bin/release_npm.sh @skipruntime/core skipruntime-ts/core/package.json $(OTP)

.PHONY: publish-helpers
publish-helpers: build-all
	bin/release_npm.sh @skipruntime/helpers skipruntime-ts/helpers/package.json $(OTP)

.PHONY: publish-wasm
publish-wasm: build-all
	bin/release_npm.sh @skipruntime/wasm skipruntime-ts/wasm/package.json $(OTP)

.PHONY: publish-native
publish-native: build-all
	bin/release_npm.sh @skipruntime/native skipruntime-ts/addon/package.json $(OTP)

.PHONY: publish-server
publish-server: build-all
	bin/release_npm.sh @skipruntime/server skipruntime-ts/server/package.json $(OTP)

.PHONY: publish-postgres-adapter
publish-postgres-adapter: build-all
	bin/release_npm.sh @skip-adapter/postgres skipruntime-ts/adapters/postgres/package.json $(OTP)

.PHONY: publish-kafka-adapter
publish-kafka-adapter: build-all
	bin/release_npm.sh @skip-adapter/kafka skipruntime-ts/adapters/kafka/package.json $(OTP)

.PHONY: publish-metapackage
publish-metapackage: build-all
	bin/release_npm.sh @skiplabs/skip skipruntime-ts/metapackage/package.json $(OTP)

.PHONY: publish-all
publish-all: clean \
	publish-tsconfig \
	publish-eslint-config \
	publish-skiplang-std \
	publish-skiplang-json \
	publish-skip-wasm-std \
	publish-skip-wasm-worker \
	publish-skip-wasm-json \
	publish-skip-wasm-date \
	publish-core \
	publish-helpers \
	publish-wasm \
	publish-native \
	publish-server \
	publish-postgres-adapter \
	publish-kafka-adapter \
	publish-metapackage

# skdb / skdb-dev / skdb-react all use release_npm.sh with STRICT_BUMP
# (error if the package.json version hasn't been bumped past what's on the
# registry).  skdb-{dev,react} additionally use VALIDATE_PUBLISHED_DEP=skdb
# to error if their skdb dep doesn't pin the currently-published skdb
# version.  Run in order; skdb must publish first.

.PHONY: publish-skdb
publish-skdb:
	STRICT_BUMP=1 bin/release_npm.sh skdb sql/ts/package.json $(OTP)

.PHONY: publish-skdb-dev
publish-skdb-dev: publish-skdb
	STRICT_BUMP=1 VALIDATE_PUBLISHED_DEP=skdb bin/release_npm.sh skdb-dev packages/dev/package.json $(OTP)

.PHONY: publish-skdb-react
publish-skdb-react: publish-skdb
	STRICT_BUMP=1 VALIDATE_PUBLISHED_DEP=skdb bin/release_npm.sh skdb-react packages/react/package.json $(OTP)

.PHONY: publish-all-skdb
publish-all-skdb: publish-skdb publish-skdb-dev publish-skdb-react
