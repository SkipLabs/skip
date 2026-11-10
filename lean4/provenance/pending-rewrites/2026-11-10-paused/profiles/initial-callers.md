# Depth-6 caller/source analysis

The useful targets are representation costs inside a few hot maintained routines, not another broad rewrite sweep. The smallest coherent candidate is the inference-cache lookup/insertion family. Two other substantial candidates are `isDefEqQuickOther` and the first argument-unification pass. The already-native assignment checker needs a different treatment from removing its outer generated frame.

## Measurement and attribution limits

This report reads `build/profiling/2026-11-10-refresh/depth6-sampled/samples.elaboration.json`: 11,026 elaboration samples across 20 raw steps, from binary `d59da747671dad2dd86a7798b50a9891d18f9ca0`. Profile SHA-256 is `5f825863a7105823a96bd077223e4422c1002131daa080345c80fd785ab093f1`. Current source was catalogued at revision `50091b2a9423f83e13d178a93a0874aac55cf608`; exact function hashes and locations are in `attribution.json`.

Root's separate uninstrumented medians were Skip 1047.8 ms and Lean 196.24 ms (5.34x). The diagnostic capture is not that timing run. No projected speedup below is a measured result.

86.30% of sampled records contain only two nonzero PCs. The maximum is ten; no record hits the 32-address cap. Inlining, absent frame pointers and tail calls hide ancestors. Thus *visible inclusive* means presence somewhere in the captured stack, not a complete call-tree cost. Adjacent caller edges can repeat in recursive stacks; do not sum them as disjoint time.

B recovered every unresolved libc PC using matching debug symbols: 3,803 `__memset_zva64`, 189 `__memcpy_generic`, and 25 allocator/free internals. Of the memset samples, 3,796 return to a call of `SKIP_Obstack_calloc`; that function tail-jumps to memset. See `build/agents/rewrite_semantics_lead/libc-resolution/`. Zeroing is 34.49% of all samples, but it serves many unrelated allocations.

## Confirmed fixed-frame costs

Disassembly and current source agree on four exact allocation sites. Each allocates the array header plus eight bytes per frame slot. Counts are sampled PCs, not numbers of allocations.

| Routine | Frame slots / bytes | Exact calloc-site memset | Direct fill | Self | Visible inclusive |
|---|---:|---:|---:|---:|---:|
| `isDefEqQuickOther` | 199 / 1608 | 101 (0.92%) | 28 (0.25%) | 45 (0.41%) | 188 (1.71%) |
| `evalNat.visit` | 392 / 3152 | 100 (0.91%) | 26 (0.24%) | 52 (0.47%) | 204 (1.85%) |
| `isDefEqArgsFirstPass.spec_0` | 208 / 1680 | 98 (0.89%) | 31 (0.28%) | 63 (0.57%) | 206 (1.87%) |
| Inference cache `insertAux` | 53 / 440 | 57 (0.52%) | 21 (0.19%) | 53 (0.48%) | 183 (1.66%) |

The four confirmed sites account for 356 zeroing samples plus 106 fill samples, 4.19% of the capture. These are distinct PCs, while the visible-inclusive column already includes descendants. The source has other real allocations: not every memset attributed to a frame-bearing function is its frame. Across all routines, 402/429 fill samples have a direct caller with a generated frame, and 1,757 calloc-zeroing samples have a frame-bearing owner; those broader numbers are associations, not proof that all are frame setup.

Exact addresses, source body hashes and disassembly are saved in `confirmed-frame-sites.json` and `frame-allocation-disassembly.txt`.

## Ranked bounded changes

1. **Inference-cache lookup and insertion, `sources/Modules/Lean/Meta/InferType/Part000.sk:15326`, `:15380`, `:15725`.** `f_inferTypeImp_infer_spec_2_3cc60cfed5` has 88 self / 137 visible-inclusive samples; `f_infer_spec_1_spec_1_ac68cfa009` has 53 / 183. The lookup walker is largely inlined into the wrapper. Keep hash, bucket and depth in native integers inside these routines instead of successively boxing Expr hash, mixed UInt64, USize, masked USize and Nat index. Replace the insertion frame with locals. The current entries arm writes a temporary PUnit into an immutable array and then writes the replacement entry: one raw-mode publication can remove a complete intermediate copy even after root's clone/set/chill array-adapter change. Preserve the instrumented primitive/event route. Keep collision helpers and their thresholds initially. The cache deliberately compares combined hashes; `InferType/Fast.sk:35` subsequently compares the configuration key and calls budgeted Expr equality. Do not replace this approximate policy with ordinary full-key equality. Tests must cover full hash collisions, short arrays, deep refs, collision expansion, old snapshots and profiling events. This is the recommended first experiment, not a claim it owns global array costs.

2. **Quick equality dispatch, `ExprDefEq/Runtime003.sk:3250`, `f_Lean_Meta_isDefEqQuickOther_f3a8ea9bdf`.** Native `Lean/Meta/ExprDefEq.lean:2036` is a readable ordered decision tree. Its 199-slot frame is allocated before annotation, equal-expression and non-metavariable exits. Structured guards can remove that setup while retaining exact assignment/instantiation/trace order. Keep complex or unsupported trace behavior explicitly routed to a retained implementation if necessary. The confirmed frame setup is 129 samples (1.17%), separate from the 45 self samples; it is not all recoverable end-to-end time.

3. **First argument equality pass, `ExprDefEq/Runtime000.sk:8195`, `f_Meta_isDefEqArgsFirstPass_spec_0_ad4075ddc6`.** The native source at `ExprDefEq.lean:395` is an indexed loop with two postponed-index arrays. A typed index and readable loop replace a 208-slot frame. Preserve higher-order postponement, proof-irrelevance skips, implicit transparency bumps, short-circuit failure, callback contexts, worlds and error order. This is independent of the inference cache but has more semantic branches. Confirmed frame setup: 129 samples (1.17%).

4. **Nat offset evaluation visitor, `Offset/Part000.sk:1158`, `f_Meta_evalNat_visit_be1fb46d98`.** This 4,317-line lowered body maps to the bounded operation/instance dispatch in native `Offset.lean:42`; every visit starts with a 392-slot frame. Reuse existing arbitrary-Nat and valid-instance fixtures. Preserve instantiated-mvar/annotation normalization before recognition, instance guards, left/right evaluation order, exponent guard ordering and Option/error worlds. Full visitor conversion is larger than the cache family; do not expand to all offset solving. Confirmed frame setup: 126 samples (1.14%).

5. **Assignment quick traversal, `src/Runtime/CheckAssignment.sk:5`.** The enclosing `checkAssignment` symbol has 141 self / 299 visible-inclusive samples, but only three direct fill samples. Its outgoing edges include Map setLoop 40, Vector push 26, Map rehash 11, Expr data 16 and child enumeration 14. This is predominantly the already-native `leanCheckAssignmentWithoutMVars`, inlined into the caller. Rewriting only the 430-line outer frame is unlikely to address that cost. A small candidate is direct reverse child pushes instead of generic `(field,binder)` enumeration; a separate candidate is avoiding duplicate visited-map lookup/insertion if the actual Skip API permits it. Preserve the DAG set, structural collision checks, free-variable/context rules and left-to-right failure order. `LeanImmutableKey` hashes cached Expr metadata; do not describe this as recursive structural hashing. The child descriptor arrays may be shared constants, so no per-node allocation claim is established. Map-capacity tuning needs a measured workload, not speculation.

## Shared representation costs and exclusions

`leanArrayWrite` is 166 self / 489 visible inclusive (1.51% / 4.44%); `leanArray` 268 / 369 (2.43% / 3.35%); `leanArrayRead` 100 / 154 (0.91% / 1.40%); `leanReplaceField` 115 / 294 (1.04% / 2.67%). B identified their concrete zeroing sites. C owns their implementation/representation analysis. Caller capture is sparse: only 12 incoming edge occurrences for `leanArrayWrite`, 58 for `leanArray`, 43 for `leanArrayRead`, and 16 for `leanReplaceField`. Do not assign their whole inclusive cost to the inference cache or another selected port caller.

`USize.land`, `UInt64.toUSize`, and `mixHash` together have 236 self samples (2.14%). Their unprofiled bodies already use native operations; repeated wrapper rewrites would not fix the boxed intermediate values created by their callers. The proposed cache family addresses those boundaries locally.

The paused `Simp.reduce` contract has only three self and seven visible-inclusive samples (0.027% / 0.063%). There is no profile-based reason to resume it ahead of the candidates above. Global brk/free/store-destruction costs also cannot be assigned to one port routine from these truncated stacks.

No source or runtime/compiler change was made for this report. Root subsequently authorized only the inference-cache family as a private experiment; its results must be remeasured after integration alongside the independently changed array adapters.
