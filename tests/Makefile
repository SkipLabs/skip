SOURCES := $(shell find . -name "*.sk" | grep syntax)
LLVMOBJS = $(SOURCES:.sk=.ll)

default: $(LLVMOBJS)

../build/state.db:
	../build/skc --no-inline --preamble ../preamble64.ll `find prelude/ -name "*.sk"` --init ../build/state.db

%.ll: ../build/state.db %.sk
	../build/skc --no-inline --preamble ../preamble64.ll `find prelude/ -name "*.sk"` --data $^ > $@


clean:
	rm -Rf ../build/state.db
