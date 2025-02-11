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

stage%:
	mkdir -p $@
	$(MAKE) $@/bin/skc $@/bin/skfmt $@/bin/skargo $@/lib/libstd.sklib

build/%.ll: bootstrap/%.ll.gz
	mkdir -p $(@D)
	gunzip -c $< > $@

.PHONY: build/libskip_runtime64.a build/libbacktrace.a
build/libskip_runtime64.a build/libbacktrace.a:
	OUT_DIR=$$(realpath ./build) $(MAKE) -C ../prelude

.PHONY: stage0/lib/libstd.sklib
stage0/lib/libstd.sklib:
	mkdir -p $(@D)
	PATH=$$(realpath stage0/bin):$(PATH) OUT_DIR=$$(realpath stage0/lib) $(MAKE) -C ../prelude bootstrap

stage0/bin/skc: build/skc_out64.ll build/libskip_runtime64.a build/libbacktrace.a
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

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
