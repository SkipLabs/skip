# Incremental Lean in Skip

## Implementation contract

The maintained implementation is Skip source. The original transpiler is historical
tooling and is not part of the build or the incremental execution path. Preserve
all translated functions. Runtime functions that are not implemented must fail
with their original Lean identity; never silently return a dummy success.

The first workload is:

```lean
def limit : Nat := 3
def noise : Nat := 99
theorem result : limit < 10 := by decide
```

Execute existing Lean elaboration algorithms in Skip. SKStore must observe their
environment reads, including negative lookups. Do not predeclare that `limit` is
the only dependency, replace `decide` with an arithmetic test, or use a native
Lean subprocess as the cached elaboration implementation.

## Sequence

1. Promote the complete translated corpus to maintained source. Preserve the
   existing elaborator build selection, with exactly one definition of each
   translated function. Build without running Lean, Python, or the transpiler.
2. Bring up the execution path needed by the example. Introduce shared runtime
   support and explicit execution/environment interfaces in the Skip source.
   Record every unsupported operation and deliberate restriction below.
3. Introduce one SKStore work item for theorem elaboration and keyed environment
   reads. Keep local mutable elaboration state inside a work item. Publish the
   resulting declaration and diagnostics without restoring an old environment.
4. Check cold execution, no-op reuse, unrelated edits, `limit = 4`, `limit = 30`,
   deletion, and restoration against fresh execution. Use original Lean as a
   reference and independent checker, not as the implementation under test.
5. Measure repeated fresh and incremental execution with execution counters,
   warmup, sample distributions, and retained memory. Include the cost of applying
   edits and publishing results. Report cold and warm costs separately. Optimize
   until reuse produces a useful measured improvement; do not claim speedup from
   a cache hit counter alone.

## Current restrictions and status

- The current executable only exercises translated `Lean.Name` functions. It
  does not yet execute the example or demonstrate incremental elaboration.
- Foreign runtime functions and module-initialization reads still fail explicitly.
- The first execution target may fix imports, parser tables, options and syntax;
  any such restriction must be stated here when implemented. General parsing,
  arbitrary user tactics, IO, asynchronous elaboration and persistence are not
  implicitly supported by success on this example.
- The existing successful corpus validation concerns translation and code
  generation; it is not evidence that the elaborator executes correctly.
- No performance result for incremental theorem elaboration has been obtained.

## Source ownership

`sources/Modules/` holds the elaborator dependency closure used by the normal
build. `sources/Additional/` preserves every other translated declaration from
the full import closure. These are disjoint maintained sources, not generated
copies of each other. `sources/build.txt` lists normal build inputs. Source
provenance and the original runtime/constructor inventories are in `provenance/`.
Handwritten runtime and driver code lives in `src/`.

## Source promotion verification

The maintained-source build passed in 444.88 seconds with a sampled peak of
41.89 GiB. The smoke executable passed. Migration preserved all 275,298
declarations with no duplicate qualified Skip names: 111,979 in the normal
build and 163,319 additional declarations, across 3,020 source files. No Lean
or transpiler invocation was made by the build. Raw evidence is in ignored
`build/maintained-build-measure.json`, `build/maintained-build.log`, and
`build/maintained-smoke.log`.
