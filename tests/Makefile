SOURCES := $(shell find ./ -name "*.sk" | grep syntax)
LLVMOBJS = $(abspath $(addprefix ../build/tests/, $(SOURCES:.sk=.out)))

default: $(LLVMOBJS)

../build/state.db:
	@mkdir -p ../build/tests/
	../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --init ../build/state.db --check

../build/tests/%.out: ../build/state.db %.sk
	@mkdir -p $(dir $@)
	@- ../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --export-function-as main=skip_main --data $^ 2> $(@:.out=.err) > $(@:.out=.ll) || true
	@- sed -i 's/File "/File ".\//' $(@:.out=.err)
	@./run.sh $@

clean:
	rm -Rf ../build/state.db
	find . -name "*.ll" | xargs rm -f
	find . -name "*.out" | xargs rm -f
	find . -name "*.err" | xargs rm -f
	find . -name "*.o" | xargs rm -f

