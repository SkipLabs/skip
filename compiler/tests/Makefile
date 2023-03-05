SOURCES := $(shell find ./ -name "*.sk" | sed "s|^\./||" | grep -v native | grep -v todo)
PRELUDE_SOURCES := $(shell find ../../prelude/src/ -name '*.sk')
SKFS_SOURCES := $(wildcard ../../skfs/src/*.sk)
LLVMOBJS = $(addprefix ../../build/tests/, $(SOURCES:.sk=.test))

default: ../../build/state.db $(LLVMOBJS)

../../build/state.db:
	@mkdir -p ../../build/tests/
	skc --no-inline $(PRELUDE_SOURCES) $(SKFS_SOURCES) --init ../../build/state.db --check

../../build/tests/%.test: %.sk
	@mkdir -p $(dir $@)
	@- skc --no-inline -O0 $(PRELUDE_SOURCES) $(SKFS_SOURCES) $^ --export-function-as main=skip_main --data ../../build/state.db --emit=link -o $(@:.test=.bin) 2> $(@:.test=.err) || true
	@- sed -i 's/File "/File ".\//' $(@:.test=.err)
	@./run.sh $@

clean:
	rm -Rf ../../build/state.db
	rm -Rf ../../build/tests
