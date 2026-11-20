OLEVEL   ?= -O3
CXXFLAGS ?= $(OLEVEL)
SKARGO_PROFILE ?= release
# Older bootstrap compilers do not recognize the split-module option. The
# optional vtable image marks bootstraps that support it.
SKC_ARGS ?= --canonize-paths $(if $(wildcard bootstrap/skc_vtables64.ll.gz),--split-support-module)
SKARGO_ARGS ?= --profile $(SKARGO_PROFILE) $(foreach opt,$(SKC_ARGS),--skcopt $(opt))
# Parallel skargo unit compilation. The pinned stage0 bootstrap skargo
# supports --jobs, so the stage1 skargo invocations parallelize their units
# too. skargo never lets a heavy unit (>=100 sources, e.g. the compiler
# self-build, which peaks near the CI job's memory guard) share a slot with
# another unit.
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

# Each stage target names a *directory*, so as a file target with no
# prerequisites make considers it up to date the moment the directory exists:
# once you had built a stage, `make stageN` printed "'stageN' is up to date" and
# recursed into nothing, leaving however stale a skc was already sitting there.
# That is how a stage0 built weeks earlier survived a `git pull`, a bootstrap
# submodule bump and a rebuild: nothing ever asked make to look inside the
# directory again. They are aggregates, so make them phony and always recurse;
# the rules they recurse into key off real inputs (stage0) or delegate freshness
# to skargo (stage1+), so an up-to-date tree still does nothing.
#
# The stages have to be listed explicitly rather than matched with `stage%`:
# make skips implicit-rule search for phony targets, so a phony target built by
# a pattern rule gets "Nothing to be done" instead. Naming them also turns a
# typo like `make stage7` into an error rather than a successful no-op. Nothing
# in the tree uses a stage name outside 0-3 and D (Docker/CI use STAGE=0/1,
# bin/bump_bootstrap.sh uses stage3 and promote).
.PHONY: stage0 stage1 stage2 stage3 stageD
stage0 stage1 stage2 stage3 stageD:
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
	# prelude/build.sk reuses a Makefile-built libbacktrace from
	# ./build/libbacktrace.a (relative to the prelude package) instead of
	# running configure+make itself; stage the fresh archive there so the
	# skargo-driven prelude builds skip their own libbacktrace build. Keep
	# this a side effect of this rule, not a prerequisite of the stageN
	# rules: the stage aggregates recurse through sub-makes, and a prereq
	# here would make several make levels run this recipe concurrently.
	mkdir -p ../prelude/build
	cp build/libbacktrace.a ../prelude/build/libbacktrace.a

# Not .PHONY: the rule has real prerequisites and produces the file, so an
# unchanged stage0 is not rebuilt on every invocation. The prelude sources
# are prerequisites so a prelude edit re-runs the sub-make (which rebuilds
# libstd.sklib via its own rules).
# Needs stage0/bin/skc on PATH (built from the pinned bootstrap IR); under -j
# the link must finish before the prelude sub-make looks for skc.
# LIB_DIR points at the archive built for the stage0 links, so the prelude
# Makefile copies it instead of running libbacktrace's configure again.
stage0/lib/libstd.sklib: stage0/bin/skc $(shell find ../prelude/src -name '*.sk') ../prelude/preamble/preamble64.ll ../prelude/Makefile
	mkdir -p $(@D)
	PATH=$$(realpath stage0/bin):$(PATH) OUT_DIR=$$(realpath stage0/lib) LIB_DIR=$$(realpath build) $(MAKE) -C ../prelude bootstrap

# Persistent files are keyed on the executable's GNU build-id on ELF. Mach-O
# executables always carry an LC_UUID instead, and ld64 rejects --build-id.
# On macOS, link with lld: ld64 rejects the non-object members of .sklib
# archives.
ifeq ($(shell uname -s),Darwin)
STAGE0_LDFLAGS ?= -fuse-ld=lld
else
STAGE0_LDFLAGS ?= -no-pie -Wl,--build-id
endif

bootstrap_vtable = $(patsubst bootstrap/%.gz,build/%,$(wildcard bootstrap/$(1)_vtables64.ll.gz))

stage0/bin/skc: build/skc_out64.ll $(call bootstrap_vtable,skc) build/libskip_runtime64.a build/libbacktrace.a
	mkdir -p $(@D)
	clang++ $(STAGE0_LDFLAGS) $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skargo: build/skargo_out64.ll $(call bootstrap_vtable,skargo) stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ $(STAGE0_LDFLAGS) $(CXXFLAGS) -o $@ $^ -lpthread -g3
ifeq ($(shell uname -s),Darwin)
# The bootstrap skargo crashes when nproc is missing, as on macOS.
	printf '#!/bin/sh\nexec sysctl -n hw.ncpu\n' > $(@D)/nproc
	chmod +x $(@D)/nproc
endif

stage0/bin/skfmt: build/skfmt_out64.ll $(call bootstrap_vtable,skfmt) stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ $(STAGE0_LDFLAGS) $(CXXFLAGS) -o $@ $^ -lpthread -g3

# skc+skfmt are one grouped (&:) target: a single `skargo build --bins` run.
# The bins build runs first and alone: its self-compile peaks near the CI
# job's memory guard, so it must not overlap the other builds, and the other
# builds share its target dir, where concurrent skargo processes would race
# on the per-unit state.db files (#1581). Once the bins build is done, the
# lib and skargo builds run concurrently under -j; the lib build gets its own
# target dir (stageN/target-lib) so the two never share one.
stage1/bin/skc stage1/bin/skfmt &: stage0
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage1/bin --target-dir stage1/target
stage1/lib/libstd.sklib: stage0 stage1/bin/skc
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --lib --out-dir stage1/lib --target-dir stage1/target-lib --manifest-path ../prelude/Skargo.toml
stage1/bin/skargo: stage0 stage1/bin/skc
	PATH=$$(realpath stage0/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage1/bin --target-dir stage1/target --manifest-path ../skargo/Skargo.toml

stage2/bin/skc stage2/bin/skfmt &: stage1
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage2/bin --target-dir stage2/target
stage2/lib/libstd.sklib: stage1 stage2/bin/skc
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --lib --out-dir stage2/lib --target-dir stage2/target-lib --manifest-path ../prelude/Skargo.toml
stage2/bin/skargo: stage1 stage2/bin/skc
	PATH=$$(realpath stage1/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage2/bin --target-dir stage2/target --manifest-path ../skargo/Skargo.toml

stage3/bin/skc stage3/bin/skfmt &: stage2
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage3/bin --target-dir stage3/target
	-diff -q stage2/bin/skc.ll stage3/bin/skc.ll
stage3/lib/libstd.sklib: stage2 stage3/bin/skc
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --lib --out-dir stage3/lib --target-dir stage3/target-lib --manifest-path ../prelude/Skargo.toml
stage3/bin/skargo: stage2 stage3/bin/skc
	PATH=$$(realpath stage2/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bins --out-dir stage3/bin --target-dir stage3/target --manifest-path ../skargo/Skargo.toml

# stageD is a "direct" build mode, where skc is built from current compiler
# and runtime sources using the skc found in PATH, without using skargo or
# build scripts written in skip; libstd.sklib is built with that stageD
# compiler; skargo and skfmt are built using the skargo found in PATH and the
# stageD compiler

STAGED_SRC := $(shell find ../prelude/src ../arparser/src ../cli/src src -name '*.sk')

stageD/bin/skc: $(STAGED_SRC) $(PRELUDE_BUILD_SRCS)
	mkdir -p $(@D)
	OUT_DIR=$$(realpath stageD/lib) $(MAKE) -C ../prelude default
	SKC_PREAMBLE=../prelude/preamble/preamble64.ll SKARGO_PKG_NAME=skc SKARGO_PKG_VERSION=stageD GIT_COMMIT_HASH=$(shell git rev-parse --short HEAD) skc $(SKC_ARGS) --link-args -lpthread --no-std --export-function-as main=skip_main -o stageD/bin/skc $(OLEVEL) stageD/lib/libskip_runtime64.a stageD/lib/libbacktrace.a $(STAGED_SRC)
	mkdir -p stageD/target/host/$(SKARGO_PROFILE)/deps/ && mv stageD/bin/skc.ll stageD/target/host/$(SKARGO_PROFILE)/deps/skc-d.ll

stageD/lib/libstd.sklib: stageD/bin/skc
	mkdir -p $(@D)
	PATH=$$(realpath stageD/bin):$(PATH) OUT_DIR=$$(realpath stageD/lib) $(MAKE) -C ../prelude bootstrap

stageD/bin/skargo: stageD/bin/skc stageD/lib/libstd.sklib
	PATH=$$(realpath stageD/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bin skargo --out-dir stageD/bin --target-dir stageD/target --manifest-path ../skargo/Skargo.toml

# skfmt gets its own target dir so it can build in parallel with skargo under
# -j (they would otherwise share stageD/target, #1581).
stageD/bin/skfmt: stageD/bin/skc stageD/lib/libstd.sklib
	PATH=$$(realpath stageD/bin):$(PATH) skargo build $(SKARGO_ARGS) --jobs $(SKARGO_JOBS) --bin skfmt --out-dir stageD/bin --target-dir stageD/target-skfmt

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
