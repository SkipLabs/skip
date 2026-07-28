OLEVEL   ?= -O3
CXXFLAGS ?= $(OLEVEL)
SKARGO_PROFILE ?= release
SKC_ARGS ?= --canonize-paths
SKARGO_ARGS ?= --profile $(SKARGO_PROFILE) $(foreach opt,$(SKC_ARGS),--skcopt $(opt))
STAGE    ?= 1

prefix   ?= /usr/local
exec_prefix ?= $(prefix)
bindir   ?= $(exec_prefix)/bin
libdir   ?= $(exec_prefix)/lib


.PHONY: default
default: stage$(STAGE)

# Each stage target names a *directory*, so as a file target with no
# prerequisites make considers it up to date the moment the directory exists:
# once you had built a stage, `make stageN` printed "'stageN' is up to date" and
# recursed into nothing, leaving however stale a skc was already sitting there.
# They are aggregates, so make them phony and always recurse; the rules they
# recurse into now key off real inputs, so an up-to-date tree still does nothing.
#
# The stages have to be listed explicitly rather than matched with `stage%`:
# make skips implicit-rule search for phony targets, so a phony target built by
# a pattern rule gets "Nothing to be done" instead. Naming them also turns a
# typo like `make stage7` into an error rather than a successful no-op.
.PHONY: stage0 stage1 stage2 stage3 stageD
stage0 stage1 stage2 stage3 stageD:
	mkdir -p $@
	$(MAKE) $@/bin/skc $@/bin/skfmt $@/bin/skargo $@/lib/libstd.sklib

build/%.ll: bootstrap/%.ll.gz | check-bootstrap
	mkdir -p $(@D)
	gunzip -c $< > $@

# The real inputs of the stage0 artifacts. The recursive makes that produce the
# runtime archives and the stdlib cannot report whether they changed anything,
# so their targets are .PHONY and their mtimes bump on every invocation; a
# stage0 rule that took them as ordinary prerequisites would relink on every
# invocation too. Depend on the sources instead, and see stage0/bin/skc for how
# the archives themselves are kept up to date without forcing that relink.
RUNTIME_SRC := $(wildcard ../prelude/runtime/*.c ../prelude/runtime/*.cpp ../prelude/runtime/*.h)
PRELUDE_SRC := $(shell find ../prelude/src -name '*.sk')

# The compiler is bootstrapped from the pre-compiled IR shipped in the
# `bootstrap` submodule. If that submodule is not at the commit recorded in this
# checkout, skc gets built from mismatched IR and typically crashes at runtime
# with an opaque internal error (e.g. "Invariant violation"). Fail early with a
# clear remedy instead. (No-op outside a git checkout, e.g. source tarballs.)
.PHONY: check-bootstrap
check-bootstrap:
	@if git submodule status bootstrap 2>/dev/null | grep -qE '^[-+U]'; then \
	  echo "" >&2; \
	  echo "ERROR: the bootstrap submodule (skiplang/compiler/bootstrap) is out of sync with" >&2; \
	  echo "the commit recorded in this checkout, so skc would be built from mismatched IR." >&2; \
	  echo "Sync it before building:" >&2; \
	  echo "" >&2; \
	  echo "    git submodule update --init skiplang/compiler/bootstrap" >&2; \
	  echo "" >&2; \
	  exit 1; \
	fi

.PHONY: build/libskip_runtime64.a build/libbacktrace.a
build/libskip_runtime64.a build/libbacktrace.a:
	OUT_DIR=$$(realpath ./build) $(MAKE) -C ../prelude

# Real prerequisites rather than .PHONY. This recipe puts stage0/bin on PATH and
# compiles the stdlib with whatever `skc` it finds there, so stage0/bin/skc is a
# genuine input; without it an already-present but outdated stage0/bin/skc was
# used as-is and the bootstrap IR it should have been rebuilt from was never
# even unpacked. A stage0 left over from an older checkout then silently
# compiled the current prelude and reported errors for language features it
# predates -- a stage0 older than `@allow_tracked_call` rejects it with 47
# "Cannot call an untracked function from a tracked context", which reads
# exactly like the stdlib being broken. It also means the check-bootstrap guard,
# which hangs off unpacking that IR, now actually runs on this path.
#
# Being a real file target also stops stage0/bin/{skargo,skfmt}, which link
# against it, from relinking on every invocation.
stage0/lib/libstd.sklib: stage0/bin/skc $(PRELUDE_SRC)
	mkdir -p $(@D)
	PATH=$$(realpath stage0/bin):$(PATH) OUT_DIR=$$(realpath stage0/lib) $(MAKE) -C ../prelude bootstrap

# The archives are order-only prerequisites: they are always brought up to date
# before the link, but being .PHONY they are never a reason to relink. The
# relink decision comes from the bootstrap IR and the runtime sources, which are
# what actually determine this binary. As ordinary prerequisites they forced a
# ~2.5min -O3 link of a 72MB IR module on every single invocation.
stage0/bin/skc: build/skc_out64.ll $(RUNTIME_SRC) | build/libskip_runtime64.a build/libbacktrace.a
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ build/skc_out64.ll build/libskip_runtime64.a build/libbacktrace.a -lpthread -g3

stage0/bin/skargo: build/skargo_out64.ll stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skfmt: build/skfmt_out64.ll stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage1/bin/skc stage1/bin/skfmt: stage0
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage1/bin --target-dir stage1/target
stage1/lib/libstd.sklib: stage0
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --lib --out-dir stage1/lib --target-dir stage1/target --manifest-path ../prelude/Skargo.toml
stage1/bin/skargo: stage0
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage1/bin --target-dir stage1/target --manifest-path ../skargo/Skargo.toml

stage2/bin/skc stage2/bin/skfmt: stage1
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage2/bin --target-dir stage2/target
stage2/lib/libstd.sklib: stage1
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --lib --out-dir stage2/lib --target-dir stage2/target --manifest-path ../prelude/Skargo.toml
stage2/bin/skargo: stage1
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage2/bin --target-dir stage2/target --manifest-path ../skargo/Skargo.toml

stage3/bin/skc stage3/bin/skfmt: stage2
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage3/bin --target-dir stage3/target
	-diff -q stage2/bin/skc.ll stage3/bin/skc.ll
stage3/lib/libstd.sklib: stage2
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --lib --out-dir stage3/lib --target-dir stage3/target --manifest-path ../prelude/Skargo.toml
stage3/bin/skargo: stage2
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage3/bin --target-dir stage3/target --manifest-path ../skargo/Skargo.toml

# stageD is a "direct" build mode, where skc is built from current compiler
# and runtime sources using the skc found in PATH, without using skargo or
# build scripts written in skip; libstd.sklib is built with that stageD
# compiler; skargo and skfmt are built using the skargo found in PATH and the
# stageD compiler

stageD/bin/skc:
	mkdir -p $(@D)
	OUT_DIR=$$(realpath stageD/lib) $(MAKE) -C ../prelude default
	SKC_PREAMBLE=../prelude/preamble/preamble64.ll SKARGO_PKG_NAME=skc SKARGO_PKG_VERSION=stageD GIT_COMMIT_HASH=$(shell git rev-parse --short HEAD) skc $(SKC_ARGS) --link-args -lpthread --no-std --export-function-as main=skip_main -o stageD/bin/skc $(OLEVEL) stageD/lib/libskip_runtime64.a stageD/lib/libbacktrace.a $(shell find ../prelude/src ../arparser/src ../cli/src src -name '*.sk')
	mkdir -p stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/ && mv stage$(STAGE)/bin/skc.ll stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/skc-d.ll

stageD/lib/libstd.sklib: stageD/bin/skc
	mkdir -p $(@D)
	PATH=$$(realpath stageD/bin):$(PATH) OUT_DIR=$$(realpath stageD/lib) $(MAKE) -C ../prelude bootstrap

stageD/bin/skargo: stageD/bin/skc stageD/lib/libstd.sklib
	PATH=$$(realpath stageD/bin):$(PATH) skargo build $(SKARGO_ARGS) --bin skargo --out-dir stageD/bin --target-dir stageD/target --manifest-path ../skargo/Skargo.toml

stageD/bin/skfmt: stageD/bin/skc stageD/lib/libstd.sklib
	PATH=$$(realpath stageD/bin):$(PATH) skargo build $(SKARGO_ARGS) --bin skfmt --out-dir stageD/bin --target-dir stageD/target

.PHONY: promote
promote: stage$(STAGE)
	cp stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/skc-*.ll bootstrap/skc_out64.ll && gzip --best --force bootstrap/skc_out64.ll
	cp stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/skargo-*.ll bootstrap/skargo_out64.ll && gzip --best --force bootstrap/skargo_out64.ll
	cp stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/skfmt-*.ll bootstrap/skfmt_out64.ll && gzip --best --force bootstrap/skfmt_out64.ll
	@echo "Push to bootstrap repository: cd $$(realpath ./bootstrap); git add -A; git commit -m 'Update to $(shell git describe --always)'; git push; cd -"

.PHONY: install
install: stage$(STAGE)
	install -d $(libdir)
	install -m 644 stage$(STAGE)/lib/libstd.sklib $(libdir)
	install -d $(bindir)
	install -m 755 stage$(STAGE)/bin/skc stage$(STAGE)/bin/skfmt stage$(STAGE)/bin/skargo $(bindir)

.PHONY: clean
clean:
	OUT_DIR=$$(realpath ./build) $(MAKE) -C ../prelude clean
	rm -Rf stage* build

.PHONY: test
test: stage$(STAGE)
	PATH=$$(realpath stage$(STAGE)/bin):$(PATH) skargo test
