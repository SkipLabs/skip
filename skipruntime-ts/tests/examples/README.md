This directory contains expectation tests for each of the examples found in `../../examples`.

Each script `foo.sh` expects 2 arguments, redirecting the example client's stdout to the first and its stderr to the second.

To update output expectations, run `./foo.sh ./foo.exp.out ./foo.exp.err`.
To test that outputs match expectations, use the `test-example-foo` make targets (or `test-examples` to test all) in `../../Makefile`.
