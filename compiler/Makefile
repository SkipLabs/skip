CXXFLAGS ?= -O3 -mllvm -inline-threshold=0 # -enable-new-pm=false
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

bootstrap/%.ll: bootstrap/%.ll.gz
	gunzip -c $< > $@

.PHONY: bootstrap/libskip_runtime64.a bootstrap/libbacktrace.a
bootstrap/libskip_runtime64.a bootstrap/libbacktrace.a:
	OUT_DIR=$$(realpath ./bootstrap) $(MAKE) -C ../prelude

.PHONY: stage0/lib/libstd.sklib
stage0/lib/libstd.sklib:
	mkdir -p $(@D)
	PATH=$$(realpath stage0/bin/):$(PATH) OUT_DIR=$$(realpath ./stage0/lib/) $(MAKE) -C ../prelude bootstrap

stage0/bin/skc: bootstrap/skc_out64.ll bootstrap/libskip_runtime64.a bootstrap/libbacktrace.a
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skargo: bootstrap/skargo_out64.ll stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage0/bin/skfmt: bootstrap/skfmt_out64.ll stage0/lib/libstd.sklib
	mkdir -p $(@D)
	clang++ -no-pie $(CXXFLAGS) -o $@ $^ -lpthread -g3

stage1/bin/skc stage1/bin/skfmt: stage0
	PATH=stage0/bin/:$(PATH) skargo build -r --bins --out-dir stage1/bin --target-dir stage1/target
stage1/lib/libstd.sklib: stage0
	PATH=stage0/bin/:$(PATH) skargo build -r --lib --out-dir stage1/lib --target-dir stage1/target --manifest-path ../prelude/Skargo.toml
stage1/bin/skargo: stage0
	PATH=stage0/bin/:$(PATH) skargo build -r --bins --out-dir stage1/bin --target-dir stage1/target --manifest-path ../skargo/Skargo.toml

stage2/bin/skc stage2/bin/skfmt: stage1
	PATH=stage1/bin/:$(PATH) skargo build -r --bins --out-dir stage2/bin --target-dir stage2/target
stage2/lib/libstd.sklib: stage1
	PATH=stage1/bin/:$(PATH) skargo build -r --lib --out-dir stage2/lib --target-dir stage2/target --manifest-path ../prelude/Skargo.toml
stage2/bin/skargo: stage1
	PATH=stage1/bin/:$(PATH) skargo build -r --bins --out-dir stage2/bin --target-dir stage2/target --manifest-path ../skargo/Skargo.toml

stage3/bin/skc stage3/bin/skfmt: stage2
	PATH=stage2/bin/:$(PATH) skargo build -r --bins --out-dir stage3/bin --target-dir stage3/target
stage3/lib/libstd.sklib: stage2
	PATH=stage2/bin/:$(PATH) skargo build -r --lib --out-dir stage3/lib --target-dir stage3/target --manifest-path ../prelude/Skargo.toml
stage3/bin/skargo: stage2
	PATH=stage2/bin/:$(PATH) skargo build -r --bins --out-dir stage3/bin --target-dir stage3/target --manifest-path ../skargo/Skargo.toml

# 	TODO: Ensure stage2 == stage3.

stageA/bin/skc:
	mkdir -p stageA/bin
	cp $(shell command -v skc) stageA/bin/skc

stageA/bin/skargo:
	mkdir -p stageA/bin
	cp $(shell command -v skargo) stageA/bin/skargo

stageA/bin/skfmt:
	mkdir -p stageA/bin
	cp $(shell command -v skfmt) stageA/bin/skfmt

stageB/bin/skc stageB/bin/skfmt stageB/bin/skargo: stageA
	PATH=stageA/bin/:$(PATH) skargo build -r --bins --out-dir stageB/bin --target-dir stageB/target
	PATH=stageA/bin/:$(PATH) skargo build -r --bins --out-dir stageB/bin --target-dir stageB/target --manifest-path ../skargo/Skargo.toml

stageC/bin/skc stageC/bin/skfmt stageC/bin/skargo: stageB
	PATH=stageB/bin/:$(PATH) skargo build -r --bins --out-dir stageC/bin --target-dir stageC/bin
	PATH=stageB/bin/:$(PATH) skargo build -r --bins --out-dir stageC/bin --target-dir stageC/target --manifest-path ../skargo/Skargo.toml

.PHONY: promote
promote: stage$(STAGE)
	cp stage$(STAGE)/target/host/release/deps/skc-*.ll bootstrap/skc_out64.ll && gzip -f bootstrap/skc_out64.ll
	cp stage$(STAGE)/target/host/release/deps/skargo-*.ll bootstrap/skargo_out64.ll && gzip -f bootstrap/skargo_out64.ll
	cp stage$(STAGE)/target/host/release/deps/skfmt-*.ll bootstrap/skfmt_out64.ll && gzip -f bootstrap/skfmt_out64.ll

.PHONY: install
install: stage$(STAGE)
	install -d $(libdir)
	install -m 644 stage$(STAGE)/lib/libstd.sklib $(libdir)
	install -d $(bindir)
	install -m 755 stage$(STAGE)/bin/skc stage$(STAGE)/bin/skfmt stage$(STAGE)/bin/skargo $(bindir)

.PHONY: clean
clean:
	rm -Rf stage* bootstrap/*.ll

.PHONY: test
test: stage$(STAGE)
	PATH=stage$(STAGE)/bin:$(PATH) skargo test
