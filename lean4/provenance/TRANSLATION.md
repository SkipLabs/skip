# Lean 4 to Skip

A backend for Lean's saved **LCNF mono** declarations: after specialization,
erasure and lambda lifting, before physical layouts and reference counting.
The input is the complete `Lean.Elab` import closure. No C or printed IR is parsed.
All generated code is tracked. Foreign runtime calls abort with their Lean name
and foreign annotation; a functioning elaborator and an IO design remain future work.

## Build and run

From this directory:

```sh
export SKC="$PWD/../skiplang/compiler/stage1/bin/skc"
skargo build
skargo run --bin lean4-smoke
```

To rebuild that compiler from this checkout (a built `stage0` is required):

```sh
cd ../skiplang/compiler
SKC="$PWD/stage0/bin/skc" skargo build --profile release \
  --skcopt --canonize-paths --skcopt --split-support-module --bin skc \
  --out-dir stage1/bin --target-dir ../../lean4/build/compiler-target
cd ../../lean4
```

The build hook exports Lean if necessary, generates the complete source tree,
and supplies every elaborator-owned declaration and its dependency closure to Skargo. Generation is cached by content.
The executable exercises real translated `Lean.Name` functions. It does not run
the elaborator, whose foreign services are deliberately stubbed.

The repository compiler includes frontend memory checkpoints needed for this
large build. The installed `/usr/local/bin/skc` predates that change; select the
rebuilt compiler with `SKC` as shown above. Skargo's ordinary library archive
contains source and does not provide separate compilation. The normal build
uses one dependency-closed elaborator compilation; exhaustive independent batch
checks remain a separate validation step. See [PLAN.md](PLAN.md) for measurements.

Requires Python 3.12+, `skc`, `skargo`, `skfmt`, Clang, and a built Lean checkout at
`../../lean4`. Set `LEAN_ROOT` to use another checkout and `SKC` to select a Skip
compiler. The exporter loads `build/release/env.sh` from Lean when present. After changing
`LEAN_ROOT`, run `./run.sh emit` so Skargo observes the new generated inputs.
The current export is pinned to Lean commit
`63fbf3d3588b404bbe707721df61ecd41885a6f6`.

```sh
./run.sh export       # Refresh the full saved mono export
./run.sh emit         # Refresh generated source when inputs changed
./run.sh test         # Compile, link and execute semantic regression fixtures
JOBS=4 ./run.sh check # Frontend-check every generated body
JOBS=4 ./run.sh native # Compile every body to LLVM and native objects
```

`./run.sh all` performs these steps in order. Check/native jobs default to two.
Native validation explicitly exports every declaration; dead-code elimination
cannot hide missing or malformed unused bodies. Successful results are cached
against source contents, exact commands and compiler versions. These objects
are independent validation products, without a shared cross-unit vtable ABI.

## Source layout

| Path | Responsibility |
| --- | --- |
| `Export.lean` | Compiler API export, including structured mono types and field metadata |
| `tools/lean_skip/ir.py` | Streaming input, declaration catalog, reference resolution |
| `tools/lean_skip/names.py` | Stable, readable module/function/binder names |
| `tools/lean_skip/lowering.py` | Conservative recovery of expression-shaped joins |
| `tools/lean_skip/emit.py` | Tracked Skip function and closure emission |
| `tools/lean_skip/project.py` | Module files, validation interfaces and inventories |
| `tools/build.py`, `build.sk` | Cached generation and Skargo integration |
| `src/Support/Values.sk` | Immutable representation and named runtime failures |
| `src/Smoke.sk`, `src/Main.sk` | Linked smoke entry point |
| `check.py`, `tests/` | Exhaustive body compilation and executable regressions |

The complete generated import closure lives under `build/generated/Modules/`, mirroring Lean's module
hierarchy. For example, `Lean/Data/Name/Part000.sk` contains functions owned by
`Lean.Data.Name`. Large modules have deterministic numbered parts. Skip has flat
module names, so this module is named `L4_Lean_Data_Name`. `symbols.json` maps
canonical Lean names to their module, readable identifier and owning source file.
A short hash distinguishes compiler specializations and numeric name components.
Generated module files are formatted with `skfmt`; set `SKFMT` to override it.

`build/generated/Elaborator/Modules/` contains the normal build's source. Its
roots are **all 75,570 elaborator-owned declarations**, all module initializer
registrations, and the smoke functions. Following all constant references retains
111,979 declarations. The 163,319 omitted support declarations remain in the full
source and exhaustive validation. Build filtering does not replace any ordinary
function with a stub and is not limited to the smoke entry's dependencies.

There is one application package. Numbered files and validation units are not
Skip libraries and do not claim to isolate whole-program compilation.

## Representation and lowering

Ordinary functions have positional parameters and direct calls. Array arguments
are reserved for the generic closure boundary and join-result tuples. A shared
adapter per partial-application target supplies a tracked native Skip function
reference; there is no adapter class per call site.

`LeanValue` represents erased polymorphic values: constructors, exact numeric
literals, strings, erased placeholders and closures. Numeric values retain their
kind and decimal digits; Lean Nat is not truncated to Skip Int. Constructor fields
keep the mono stage's logical order, including erased slots, while type parameters
are excluded. Structured mono types and original field names are preserved in
metadata; precise generated data types remain a later migration.

Small total representation values can be inlined when used once. Adjacent
let/return pairs become a single expression. Ordinary calls retain their evaluation
order, including named failures. Simple acyclic joins become expressions; general
joins use a program-counter loop and a bounded mutable frame. Jump arguments are
snapshotted before assignment. The frame avoids a Skip code-generation failure
observed with large sets of mutable locals; it is not a Lean runtime dependency.

Zero-argument pure constants are recomputed. Reads of initialization-backed
declarations fail explicitly. Initializer registrations remain in `modules.json`;
executing them requires future runtime work. Missing ordinary references and
unsupported IR are translation errors, never invented foreign stubs.

## Evidence

Ignored build artifacts include:

- `build/elaborator.jsonl`: full versioned export, ending with a count record.
- `build/generated/coverage.json`: counts, source manifest and validation status.
- `symbols.json`, `constructors.json`, `primitives.json`, `modules.json`: inventories.
- `check-results.json`, `native-results.json`: exact commands and per-unit results.
- `build/tests.json`: executed fixture result and native Lean reference output.
- `build/*measure.json`: process-group RSS samples for whole-build experiments.

The input has 2,240 modules, 273,814 function bodies, 1,484 named foreign stubs and
3,610 inventoried constructors. Regression fixtures cover closures, partial and
excess application, cyclic argument swaps, erased proof fields, polymorphism,
exact large literals, Unicode/NUL strings, 100,000 tail calls and named aborts.
The current backend passed all **2,055 native validation batches**, covering all
275,298 declarations. The clean Skargo build and linked smoke executable passed,
as did the native semantic fixtures and 13 compiler regression tests. The clean
build took 404 seconds and used about **35 GiB** at peak; cached rebuilding took
0.057 seconds on this machine. The memory fixes are in the repository compiler,
so use the `SKC` selection shown above.

`build/skargo-results.json` records the compiler binary hash and build result;
`build/skargo-build-measure.json` contains the memory samples. Normal builds let
Skip remove functions unused by the smoke entry. Independent native validation
explicitly exports every generated declaration to exercise all bodies.
