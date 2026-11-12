OLEVEL   ?= -O3
CXXFLAGS ?= $(OLEVEL)
SKARGO_PROFILE ?= release
# Older bootstrap compilers do not recognize the split-module option. The
# optional vtable image marks bootstraps that support it.
SKC_ARGS ?= --canonize-paths $(if $(wildcard bootstrap/skc_vtables64.ll.gz),--split-support-module)
SKARGO_ARGS ?= --profile $(SKARGO_PROFILE) $(foreach opt,$(SKC_ARGS),--skcopt $(opt))
# Parallel skargo unit compilation for stage2+ builds. stage1's skargo
# invocations run the stage0 bootstrap skargo, which predates --jobs, so they
# stay serial. skargo never lets a heavy unit (>=100 sources, e.g. the
# compiler self-build, which peaks near the CI job's memory guard) share a
# slot with another unit.
SKARGO_JOBS ?= 4
STAGE    ?= 1

# Parallel by default: stage0's links and prelude build are independent, and
# the stageN skargo invocations are ordered by prerequisites so that no two
# ever share a target dir concurrently (they would race on the per-unit
# state.db files, #1581); the prelude Makefile also flocks its in-source-tree
# compiles. Default to -j unless the caller already passed one; JOBS=1 forces
# the old fully serial build. Only the top-level make adds -j: sub-makes
# inherit it through the jobserver.
JOBS ?= $(shell n=$$(nproc 2>/dev/null || echo 4); echo $$(( n > 8 ? 8 : n )))
ifeq ($(MAKELEVEL),0)
ifeq ($(findstring j,$(MAKEFLAGS)),)
MAKEFLAGS += -j$(JOBS)
endif
endif

prefix   ?= /usr/local
exec_prefix ?= $(prefix)
bindir   ?= $(exec_prefix)/bin
libdir   ?= $(exec_prefix)/lib


.PHONY: default
default: stage$(STAGE)

stage%:
	mkdir -p $@
	$(MAKE) $@/bin/skc $@/bin/skfmt $@/bin/skargo $@/lib/libstd.sklib

build/%.ll: bootstrap/%.ll.gz | check-bootstrap
	mkdir -p $(@D)
	gunzip -c $< > $@

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

# Grouped (&:) so the recipe runs once under -j, not once per target.
# Real prerequisites (not .PHONY) so an unchanged prelude does not re-copy the
# archives and force the stage0 links below to re-run on every invocation.
PRELUDE_BUILD_SRCS=../prelude/Makefile ../prelude/runtime/Makefile \
	$(filter-out ../prelude/runtime/magic.c,$(wildcard ../prelude/runtime/*.c)) \
	$(wildcard ../prelude/runtime/*.h) $(wildcard ../prelude/runtime/*.cpp) \
	$(wildcard ../prelude/libbacktrace/*.c) $(wildcard ../prelude/libbacktrace/*.h) \
	../prelude/libbacktrace/configure
build/libskip_runtime64.a build/libbacktrace.a &: $(PRELUDE_BUILD_SRCS)
	OUT_DIR=$$(realpath ./build) $(MAKE) -C ../prelude

# Not .PHONY: the rule has real prerequisites and produces the file, so an
# unchanged stage0 is not rebuilt on every invocation. The prelude sources
# are prerequisites so a prelude edit re-runs the sub-make (which rebuilds
# libstd.sklib via its own rules).
# Needs stage0/bin/skc on PATH (built from the pinned bootstrap IR); under -j
# the link must finish before the prelude sub-make looks for skc.
stage0/lib/libstd.sklib: stage0/bin/skc $(shell find ../prelude/src -name '*.sk') ../prelude/preamble/preamble64.ll ../prelude/Makefile
	mkdir -p $(@D)
	PATH=$$(realpath stage0/bin):$(PATH) OUT_DIR=$$(realpath stage0/lib) $(MAKE) -C ../prelude bootstrap

bootstrap_vtable = $(patsubst bootstrap/%.gz,build/%,$(wildcard bootstrap/$(1)_vtables64.ll.gz))

stage0/bin/skc: build/skc_out64.ll $(call bootstrap_vtable,skc) build/libskip_runtime64.a build/libbacktrace.a
	mkdir -p $(@D)
	clang++ -no-pie -Wl,--build-id $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skargo: build/skargo_out64.ll $(call bootstrap_vtable,skargo) stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie -Wl,--build-id $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skfmt: build/skfmt_out64.ll $(call bootstrap_vtable,skfmt) stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie -Wl,--build-id $(CXXFLAGS) -o $@ $^ -lpthread -g3

# skc+skfmt are one grouped (&:) target: a single `skargo build --bins` run.
# The three stage skargo invocations share stageN/target, so under -j they are
# ordered by prerequisites (bins, then skargo, then lib): concurrent skargo
# processes sharing a target dir race on the per-unit state.db files (#1581).
# Ordered this way the later builds find the bins build's units fresh and only
# compile their own. The bins build's self-compile also peaks near the CI
# job's memory guard, so it must not overlap the other builds.
stage1/bin/skc stage1/bin/skfmt &: stage0
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage1/bin --target-dir stage1/target
stage1/lib/libstd.sklib: stage0 stage1/bin/skargo
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --lib --out-dir stage1/lib --target-dir stage1/target --manifest-path ../prelude/Skargo.toml
stage1/bin/skargo: stage0 stage1/bin/skc
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --bins --out-dir stage1/bin --target-dir stage1/target --manifest-path ../skargo/Skargo.toml

stage2/bin/skc stage2/bin/skfmt &: stage1
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage2/bin --target-dir stage2/target
stage2/lib/libstd.sklib: stage1 stage2/bin/skargo
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --lib --out-dir stage2/lib --target-dir stage2/target --manifest-path ../prelude/Skargo.toml
stage2/bin/skargo: stage1 stage2/bin/skc
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage2/bin --target-dir stage2/target --manifest-path ../skargo/Skargo.toml

stage3/bin/skc stage3/bin/skfmt &: stage2
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage3/bin --target-dir stage3/target
	-diff -q stage2/bin/skc.ll stage3/bin/skc.ll
stage3/lib/libstd.sklib: stage2 stage3/bin/skargo
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --lib --out-dir stage3/lib --target-dir stage3/target --manifest-path ../prelude/Skargo.toml
stage3/bin/skargo: stage2 stage3/bin/skc
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage3/bin --target-dir stage3/target --manifest-path ../skargo/Skargo.toml

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

# skfmt gets its own target dir so it can build in parallel with skargo under
# -j (they would otherwise share stageD/target, #1581).
stageD/bin/skfmt: stageD/bin/skc stageD/lib/libstd.sklib
	PATH=$$(realpath stageD/bin):$(PATH) skargo build $(SKARGO_ARGS) --bin skfmt --out-dir stageD/bin --target-dir stageD/target-skfmt

.PHONY: promote
promote: stage$(STAGE)
	@set -eu; for name in skc skargo skfmt; do \
	  main=; for file in stage$(STAGE)/target/host/$(SKARGO_PROFILE)/deps/$$name-*.ll; do \
	    case "$$file" in *.vtables.ll) continue;; esac; \
	    test -f "$$file" && test -z "$$main"; main=$$file; \
	  done; \
	  test -n "$$main"; \
	  cp "$$main" "bootstrap/$${name}_out64.ll"; \
	  gzip --best --force --no-name "bootstrap/$${name}_out64.ll"; \
	  table=$${main%.ll}.vtables.ll; \
	  if test -f "$$table"; then \
	    cp "$$table" "bootstrap/$${name}_vtables64.ll"; \
	    gzip --best --force --no-name "bootstrap/$${name}_vtables64.ll"; \
	  else \
	    rm -f "bootstrap/$${name}_vtables64.ll.gz"; \
	  fi; \
	done
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
