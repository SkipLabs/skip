SOURCES := $(shell find ./ -name "*.sk" | grep syntax)
LLVMOBJS = $(SOURCES:.sk=.out)

default: $(LLVMOBJS)

../build/state.db:
	../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --init ../build/state.db --check

%.out: ../build/state.db %.sk
	@- ../build/skc --embedded64 --no-inline --preamble ../preamble64.ll `find ../prelude/ -name "*.sk"` `ls ~/skfs/*.sk` --export-function-as main=skip_main --data $^ 2> $(@:.out=.err) > $(@:.out=.ll) || true
	@- sed -i 's/File "/File ".\//' $(@:.out=.err)
	@./run.sh $@

clean:
	rm -Rf ../build/state.db
	find . -name "*.ll" | xargs rm -f
	find . -name "*.out" | xargs rm -f
	find . -name "*.err" | xargs rm -f
	find . -name "*.o" | xargs rm -f

