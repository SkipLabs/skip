# Error recovery and persistent allocation ownership

Diagnostic `host-retention-diag1`; 150 A→B→A cycles after one intentional frontend failure. All 303 successful compilations and executions validate; the final memory-growth assertion fails. These are functional diagnostics, with other functional work overlapping, not latency measurements.

| Scope | Tick 12 bytes | Tick 304 bytes | Change bytes |
| --- | ---: | ---: | ---: |
| Reported live allocations | 317,953,888 | 329,497,592 | +11,543,704 |
| Total scratch allocation | 329,605,120 | 340,312,064 | +10,706,944 |
| Stopped-process live allocations | 317,953,888 | 329,497,592 | +11,543,704 |
| Reachable context allocations | 312,291,352 | 309,267,344 | -3,024,008 |
| Live bytes outside the context graph | 5,662,536 | 20,230,248 | +14,567,712 |

Logical owner row counts and dependency counts are unchanged at the two equivalent A states. The census traverses references from the persisted context root, counting shared allocations once. Its live-allocation counter is read after the compiler exits; compiler completion counters are read earlier and have a different absolute baseline. Compare deltas within each scope.

Context-reachable bytes shrink while live allocations grow. The difference is not attributed to compiler metadata: constant-only roots and leaked ownership are outside this census scope. Source inspection found that the compiler pipeline exits inside its error handler before SKStore releases its borrowed persistent context. `runWithResult` also omits that release when its callback throws. Focused ownership regressions and a cleanup candidate are in progress; causality and a memory plateau still require validation.

Raw snapshots: `retention-diag1-census2-150.json.gz`. Raw test records are bundled under `retention-diag1-census2-150/`; the initial invalid census path is explicitly documented under `retention-diag1-census-150/`. Both temporary databases were deleted by test cleanup.

The focused regressions now establish both ownership leaks against the unchanged
`host-support-retention` library. Each observes two root references where one
is expected. The cleanup candidate releases the reference before invoking the
pipeline error handler and releases `runWithResult`'s borrowed snapshot when its
callback fails. Control: 76/79; candidate: 78/79, with the identical pre-existing
`testChangesAfter` failure. The initial test declarations lacked `@debug`, so
compiler CSE reused observations; only the corrected `*-tests2` control/candidate
results are evidence for these assertions. The compiler-sized cycle comparison
is still pending.

A separate runtime review found 32-bit signed shifts used against 64-bit GC
reference masks in copying, interning, freeing, hashing and native equality.
The standalone regression fails the unchanged code under UBSan at bit 31 and
passes all five actual traversals for classes and arrays at both O0 and O2 after
using `(mask >> i) & 1`. This correction is not included in either diagnostic
compiler's frozen native runtime and is not attributed as the cause of the
observed compiler-cache growth. See `runtime-reference-mask-{control,fixed}.json`
and `prelude/runtime/tests/reference_masks.c`.

The corrected native runtime is also linked into the complete SKStore test
binary: 78/79, with only the identical `testChangesAfter` failure. The five
changed sources compile successfully to Wasm bitcode with warnings treated as
errors; Wasm execution was not performed. A fresh runtime format version and
all replacement object hashes are recorded in
`runtime-reference-mask-native-identity.json`. Frozen compiler/workload runtime
archives were not modified.

## Cleanup candidate: 150-cycle comparison

All 303 successful compilations and program executions validate, including recovery from the intentional frontend failure. The memory-growth assertion now passes. The final equivalent A state is 309.312 MB (intermediate states are around 308.7 MB). These are diagnostic memory results, not elapsed performance comparisons.

| Scope | Tick 12 bytes | Tick 304 bytes | Change bytes |
| --- | ---: | ---: | ---: |
| Live allocations | 312,336,376 | 309,312,392 | -3,023,984 |
| Reachable context allocations | 312,321,896 | 309,297,912 | -3,023,984 |
| Allocated database blocks | 320,401,408 | 326,627,328 | +6,225,920 |
| Live bytes outside the context graph | 14,480 | 14,480 | 0 |

The context-external live-byte residual is constant at 14,480 bytes. The old host grows from 5,662,536 to 20,230,248 bytes outside its context graph. This directly supports the error-ownership diagnosis. The longer extension is recorded below; a full-workload branch memory gate is still required.

`host-error-cleanup-diag1` is built from the same compiler sources as the control, with the store ownership cleanup. Native runtime payloads remain unchanged, so the separate reference-mask correction does not explain this result. Raw snapshots: `error-cleanup-diag1-census-150.json.gz`.

## Cleanup candidate: 600-cycle extension

The same diagnostic host passes 600 A→B→A cycles and intentional frontend-error
recovery: all 1,203 successful compilations and executions validate. The test
reaches tick 1,204, beyond the 1,000-tick delayed-purge horizon. Its unchanged
memory/storage assertions pass. This is a functional diagnostic, with other
functional jobs overlapping; its elapsed duration is not a speed comparison.

| Scope | Tick 12 bytes | Tick 1,204 bytes | Change bytes |
| --- | ---: | ---: | ---: |
| Live allocations | 330,673,128 | 330,436,712 | -236,416 |
| Reachable context allocations | 330,658,648 | 330,422,232 | -236,416 |
| Allocated database blocks | 338,235,392 | 351,559,680 | +13,324,288 |
| Total test scratch allocation | 342,487,040 | 355,811,328 | +13,324,288 |
| Live bytes outside the context graph | 14,480 | 14,480 | 0 |

The last 100 equivalent A states range from 330,179,144 to 330,437,856 live
bytes. Logical owner row counts match the first measured A state. Compare
equivalent states within this run; its absolute allocation baseline differs
from the separate 150-cycle run. The census scope and constant residual provide
evidence for a plateau on this finite fixture, not a proof of bounded memory for
all programs or full compiler branch transitions. Test cleanup deletes the
temporary database and artifacts.

Raw snapshots: `error-cleanup-diag1-census-600.json.gz`; lossless compression and
hashes: `error-cleanup-diag1-census-600-compression.json`; runner and raw records
are preserved alongside them.
