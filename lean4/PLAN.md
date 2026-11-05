# Lean to Skip: prototype plan

Target the full `Lean.Elab` import closure, using the built Lean checkout at
`../../lean4`. Pin the input compiler revision in the export. This prototype
translates code; a functioning elaborator requires later runtime work.

## Compiler boundary

Use LCNF mono declarations saved by `saveMono`: after erasure, specialization,
lambda lifting, and simplification; before physical object layouts, explicit
boxing, reference counting, and allocation reuse. Read these through Lean's
compiler APIs. Eventually expose the emitter as a compiler hook at this boundary.
Do not parse C or printed compiler traces.

## Milestones

1. Export the saved mono declarations, signatures, constructors, module imports,
   initialization metadata, and foreign annotations into versioned JSON Lines.
   Preserve names and types, stream one declaration at a time, and reject missing
   definitions or unsupported constructs. Inventory the entire elaborator closure.
2. Emit ordinary Skip functions and immutable values, initially using a uniform
   `Value` type for erased polymorphism. Translate calls, constructors, projections,
   cases, closures, partial/overapplication, and join points. Lower joins to local
   control-flow loops so jumps do not grow the stack. Keep all code tracked for
   now; IO will need a separate design. Keep numeric literals exact and do not
   assume Lean Nat = Skip Int.
3. Emit a named aborting stub for every external declaration, including its foreign
   annotation in the diagnostic. Unknown translations must be exporter/emitter
   errors, not invented foreign stubs. Implement only the representation machinery
   needed for constructors and closures. Keep initialization dependencies explicit;
   executing module initialization is deferred while primitives are stubbed.
4. Validate semantic fixtures against Lean and compile generated Skip fixtures.
   Translate the complete `Lean.Elab` closure and check every generated body with
   Skip. Exercise native code generation with explicit exports so an empty main
   cannot conceal problems by dead-code elimination. Report coverage and remaining
   limitations separately from successful checks.
5. Later: replace foreign stubs based on execution needs (values, collections,
   state, initialization, kernel/environment services, IO). Support loading and
   executing newly defined macros/tactics as a separate milestone. Recover stronger
   Skip types and optimize representations after correctness is established.

## Acceptance for this iteration

- Full elaborator closure emitted with no unresolved ordinary calls.
- Every function emitted; every external declaration explicitly classified.
- Skip frontend checks all generated functions, including otherwise unused ones.
- Native fixtures cover data, erased fields, closures, partial and excess
  application, recursion, and join-point argument transfers.
- A runtime call aborts with the primitive's identity.
- Reproducible commands, machine-readable coverage, and honest limitations.

## Initial census

Lean commit `63fbf3d3588b404bbe707721df61ecd41885a6f6`, Skip `b6e36f18`:
2,240 imported modules; 273,814 mono function bodies; 1,484 external declarations.
Direct-call scan found only saved declarations and 3,426 constructor names.
The counts describe compiler-generated declarations, not source functions or
unique C symbols. A complete ABI/initialization audit remains part of implementation.

## Implementation adjustment: bounded validation

The monolithic Skip check was killed with exit 137. Generate bounded batches
(500 declarations / about 750 KB of source) with external interface declarations
for direct callees in other batches. Interfaces come from the same catalog and
are for validation/code generation, not replacement runtime implementations.
Check every batch; native exports force every included body through codegen.

## Completed prototype

- Exporter, metadata inventory, Skip emitter, and named primitive stubs implemented.
- Full closure emitted: 273,814 bodies and 1,484 external declarations.
- All 598 batches passed both the frontend and LLVM/native-object validation.
- Linked execution fixtures passed, including erasure, closures, joins, and aborts.
- Everything generated is tracked, per the updated direction; IO is deferred.
- Whole-elaborator linking/ABI integration and runtime implementation remain future
  milestones. Independently validated native batches are not a linked runtime.

# Next iteration: a normal Skip source tree and Skargo build

Use one Skargo package. Libraries do not isolate compilation and are not part of
our memory strategy. Keep all generated code tracked; foreign primitives still
fail, and IO remains a separate future design.

1. Split generator responsibilities into catalog/naming, lowering, emission, and
   project generation. Emit source by its owning Lean module, with meaningful
   names and deterministic subdivisions for large modules.
2. Use ordinary positional function parameters/calls. Preserve binder names and
   reserve array-based arguments for the generic closure application boundary.
3. Share closure adapters by target and calling convention, rather than creating
   one class per partial-application site. Prefer native tracked Skip closures.
4. Structure acyclic join points as expressions where feasible. Keep a verified
   loop fallback for general control flow, with simultaneous argument transfer.
5. Extend the export with structured mono types and constructor field metadata;
   introduce typed data conservatively, retaining Value for erased polymorphism.
6. Add Skargo.toml, a linked smoke entry point, and automatic cached generation.
   Normal builds export their actual entry points. Exhaustive validation remains
   separate and must continue to cover every generated declaration.
7. Compare source size, adapter count, frame usage, and peak compiler memory.
   Smaller files do not promise smaller whole-program memory. Diagnose any
   remaining compiler bottleneck using the complete generated source.

Acceptance: reproducible skargo build and executable smoke tests; readable,
module-organized output; no missing declarations or silently stubbed ordinary
functions; existing semantic tests and full-corpus checks still pass. Report
whole-program limitations explicitly rather than presenting batch checks as a
linked elaborator.

## Implementation notes for the Skip source iteration

The source tree and one-package Skargo integration are implemented. Ordinary calls
use positional arguments; shared frozen function references replace per-site
Callable classes. All 72,587 partial-application sites need 22,218 distinct
adapters. The exporter preserves binder names, structured mono expressions and
constructor field metadata. Precise data-type reconstruction is deferred until
whole-program compilation is under control; `lcAny` cannot safely become a
concrete Skip type merely from a printed name.

Simple expression recovery covers 755 of 12,280 functions containing joins.
General joins retain the verified array-frame lowering. Named mutable local
lowering exposed Skip native-code-generation errors (first with unused locals,
then in `Lean.PrettyPrinter.Parenthesizer.maybeParenthesize`); it is not used in
the final fallback. Small single-use representation expressions and adjacent
let/return pairs are simplified without reordering ordinary calls.

The first complete Skargo compilation exceeded the 44 GiB process-group guard.
Continue measuring the reduced source and existing compiler memory controls.
File/module organization alone is not evidence of a whole-program memory fix.

### Build dependency closure

Keep the complete import-closure export, source and validation coverage. For the
normal Skargo compilation, perform dependency selection before Skip's frontend:
root **every declaration whose owning module is `Lean.Elab` or a submodule**, plus
all regular/builtin initializer registrations across the import closure and the
smoke entry dependencies. Traverse every constant reference, including closure
targets. This retains 75,570 elaborator-owned declarations and 111,979 declarations
in total, while omitting 163,319 support declarations unused by those roots.

This is whole-elaborator dependency selection, not smoke-only reachability or
library-based compilation isolation. No retained ordinary function is replaced
with an interface/stub. `Modules/` remains the complete source; `Elaborator/Modules/`
is the dependency-closed build source. Exhaustive validation still covers all
275,298 declarations. Formatting uses `skfmt` in bounded groups.

### Compiler memory checkpoint

The dependency-closed elaborator passes one frontend invocation with the existing
compiler, at a sampled peak of 47.82 GiB. The Skargo archive build exceeded a
52 GiB guard: archive emission runs in the same pipeline step as naming/typing,
before their temporary allocations have been released.

`skiplang/compiler/src/compile.sk` now stops at completed naming and typing
arrows. The existing pipeline synchronizes continuation state and releases the
temporary heap before resuming packaging/specialization. This changes allocation
boundaries, not compilation units or dependency resolution. The rebuilt compiler
passes the six existing sequential-checkpoint regressions (including saved-cache
error recovery) and the Lean semantic fixtures. Use this rebuilt compiler for the
Skargo build; the older installed `/usr/local/bin/skc` does not contain the fix.

The archive writer needed a separate bound: the JSON string encoder allocated
character fragments across all source files in one temporary heap. Source objects
are now encoded in individual regions, and their finished UTF-8 fragments use the
existing native concatenation helper. Seven archive regressions passed, including
byte-for-byte comparison with the older writer and reading with the older compiler.

The executable's archive-loading step then exposed repeated iterator cloning in
zero-offset lexer peeks. That path now reads the current character directly;
configuration decoding also runs in a region so its scratch is released before
frontend processing. Both changes retain the existing archive format and parser
semantics. Final build measurements below distinguish these fixes from the earlier
unsuccessful memory experiments.

## Verified result of the Skip source iteration

- Clean `skargo build`: passed in 404.05 seconds using the rebuilt repository compiler.
- Peak: 34.44 GiB sampled process-group RSS; 34.93 GiB compiler high-water.
- `skargo run --bin lean4-smoke`: passed; cached build completed in 0.057 seconds.
- Full generated import closure: 275,298 declarations, all 2,055 frontend/native validation units passed.
- Normal build: all 75,570 elaborator-owned declarations plus initialization and call dependencies, 111,979 total.
- Native semantic fixtures: passed on both installed and rebuilt compilers.
- Compiler regressions: seven archive tests and six checkpoint tests passed, including old-reader compatibility and identical metadata bytes.

The final module source is formatted with `skfmt`. All translated code remains
tracked. Foreign primitives and initialization-backed values still fail explicitly.
Typed data reconstruction and IO/runtime implementation remain later milestones.
The executable is a smoke entry point; exhaustive native validation forces otherwise
unused bodies through code generation separately. It is not a working elaborator.

Raw commands, compiler identity, hashes and memory samples are in ignored
`build/skargo-results.json`, `build/skargo-build-measure.json`, and the generated
coverage/native reports.
