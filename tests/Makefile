SOURCES := $(shell find ./ -name "*.sk" | sed "s|^\./||" | grep -v todo)
LLVMOBJS = $(addprefix ../build/tests/, $(SOURCES:.sk=.test))

default: ../build/state.db $(LLVMOBJS)

../build/state.db:
	@mkdir -p ../build/tests/
	../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --init ../build/state.db --check

../build/tests/%.test: %.sk
	@mkdir -p $(dir $@)
	@- ../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --export-function-as main=skip_main --data ../build/state.db $^ 2> $(@:.test=.err) > $(@:.test=.ll) || true
	@- sed -i 's/File "/File ".\//' $(@:.test=.err)
	@./run.sh $@

clean:
	rm -Rf ../build/state.db
	rm -Rf ../build/tests

