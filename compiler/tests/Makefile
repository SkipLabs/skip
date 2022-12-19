SOURCES := $(shell find ./ -name "*.sk" | sed "s|^\./||" | grep -v native | grep -v todo)
PRELUDE_SOURCES := $(shell find ../../prelude -name '*.sk')
SKFS_SOURCES := $(wildcard ../../skfs/src/*.sk)
LLVMOBJS = $(addprefix ../../build/tests/, $(SOURCES:.sk=.test))

default: ../../build/state.db $(LLVMOBJS)

../../build/state.db:
	@mkdir -p ../../build/tests/
	../../build/skc --embedded64 --no-inline --preamble ../../preamble64.ll $(PRELUDE_SOURCES) $(SKFS_SOURCES) --init ../../build/state.db --check

../../build/tests/%.test: %.sk
	@mkdir -p $(dir $@)
	@- ../../build/skc --embedded64 --no-inline --preamble ../../preamble64.ll $(PRELUDE_SOURCES) $(SKFS_SOURCES) --export-function-as main=skip_main --data ../../build/state.db $^ 2> $(@:.test=.err) > $(@:.test=.ll) || true
	@- sed -i 's/File "/File ".\//' $(@:.test=.err)
	@./run.sh $@

clean:
	rm -Rf ../../build/state.db
	rm -Rf ../../build/tests

