# Expressions: bounded static approval for six constructor/map bodies

Reviewer: foundations / fd9159c3. Baseline HEAD: `41bb486d9`.

## Decision

**APPROVED for parent integration and serialized execution checks: the six frozen `integration/<simple>/Reviewed.sk` files listed below.** No semantic blocker found in this subset after reading originals, replacements, maintained helper implementations/contracts, and probe sources. This is static-review approval, not a claim that this reviewer compiled or executed any probe. Production/config files were not edited; no builds, tests, benchmarks, commits, or subagents were run.

**Not approved here:** either binding target, environment, inference, allocation, other lanes, or later edits to the frozen bodies. X-1 remains separately held for the two binding targets pending review of genuine returned error/state coverage. Earlier E-1/I-1 findings remain outside this approval.

Parent reports that a private-overlay **release** ProbeExpr passed (fixed constructor metadata and profile cases), production remained unchanged, and debug compilation failed on undefined `SKIP_print_stack_trace`. This report records that as parent-reported additional evidence only; it does not claim a debug pass or independently verified execution. Parent also previously reported a baseline 36-case production matrix pass; that baseline is not replacement validation.

## Frozen approved artifacts

All paths below have prefix `build/parity-wave/integration/` and suffix `/Reviewed.sk`. SHA256 values are whole-file hashes.

| Simple name | SHA256 |
|---|---|
| `f_Expr_forallE_override_b21c7ca660` | `ca2249a41387e7bafcbe7490a7288f7e8c5037440d52c12dd150a7cbc570cca1` |
| `f_Expr_lam_override_5bc80605de` | `f511de9953cc5443b4acfa710e9028de6133b5f0b4a975999738f842d2e4baf6` |
| `f_addExprMVarDecl_spec_0_spec_0_0c9fc4045a` | `fbd00a0e1169a0b01bdd82cb386effe862eadebfd62c367baf39e84f303d2370` |
| `f_assignExp_spec_0_spec_0_12353c570c` | `f6409c8010769946801a5f7bc1090fe62a9faf04fc5923078b323c3a4831fd5c` |
| `f_assignLevelMVarExp_spec_0_spec_0_c459d88a74` | `a94484e95b80cd4c66a52165b9d3a65e648e9b5c94b3693edbc72ca6da0aa242` |
| `f_mkLocalDecl_spec_0_spec_0_eab4f1c354` | `4acd77572d322a1339773411109d22851de7e8636774e805b0f2ed3349f8efce` |

Each frozen body is equal to its previously reviewed `expressions/replacements/<simple>.sk` after stripping formatting/comments/module wrappers and optional trailing call/array commas. Function signatures and module identities remain exact; no helpers were introduced by these six.

For each target, current production whole-file SHA256 matches `baseline-source-hashes.json`, and the function text exactly matches frozen `Original.sk`. Manifest body hashes also match after including the original Lean-name comment (the catalog hashes the comment plus function, not just `fun` through the closing brace). Earlier ad-hoc function-only hash mismatches were extraction-convention differences, not source drift.

## Semantic basis

### Lambda / forall constructors

- Exact constructor tags and five-field ABI `[data, name, type, body, info]`; retain original name, info and child objects without inspecting unused name/info.
- Seeds 29 (lambda) / 31 (forall); hash order remains `mix32(mix32(seed, typeHash), bodyHash)`. Maintained metadata/word/primitive helper calls remain, including profiling dispatch.
- Loose range remains arbitrary-Nat-safe `max(typeRange, max(bodyRange - 1, 0))`; no host-Int replacement of Nat arithmetic. Depth remains capped by maintained mkData to 255 after max + 1. Four flag disjunctions remain left-biased with original helper/effect order.
- Concrete boxed Bool matches retain non-exhaustive failures. Output is the original direct Expr constructor, not an accidental Bool/LBool/EST/EStateM/ST wrapper. These bodies introduce no new world/state handling.
- Frozen forall anchors: `Reviewed.sk:12-53` data/hash/range order; `:56-108` depth/left-biased flags; `:109-136` mkData and field publication. Lambda has the corresponding structure. Maintained contracts include `sources/Modules/Lean/Expr/Metadata.sk`, `Expr/Part001.sk:2346` mkData argument order and `Init/Prelude/Part001.sk:4` mixHash32/profile dispatch.

### Four persistent-map insertion specializations

- Per-family equality adapters and collision/redistribution helpers preserved. Name/MVarId/FVarId/LevelMVarId representations are not silently unified at the ABI boundary, even where maintained equality delegates to Name.
- Keep entries-array size/bounds branch, returning the original node when the slot is outside a short array. Read slot, create temporary PUnit-cleared array, then inspect entry, preserving original projection/failure/helper order. Temporary clear is not published in the input root.
- Equal-key replacement, unequal-key old-pair-first collision, null slot and ref descent retain original shape. Unsigned hash suffix shifts by 5, depth increments with USize wrap, and original helper conversions are used.
- Collision erased/proof field 2 is still projected. Insert into collision before checking depth; depth >= 7 returns before size query; size < 4 retains collision; otherwise redistribute, including an overwrite of an already oversized collision.
- Input root, retained siblings and values remain immutable/shared as before. No new global cache, mutable publication or checkpoint policy.
- Representative frozen assignExp anchors: `Reviewed.sk:18-113` entries path; `:115-175` collision path, including ignored field projections at `:117,:161`. The four original bodies and four replacement bodies have the same control structure modulo specialization identities/error text; maintained helper-call inventories match per family. Read collision/empty entries/size contracts in `Lean/Data/PersistentHashMap/Part000.sk:164,500,777,911`, assignExp collision helper in `MetavarContext/Part000.sk:3258`, and redistribution in `:9060-9141`, as well as the other family helper bodies.

## Probe-source review and independent outcomes

Reviewed files (not executed by this reviewer), prefix `build/parity-wave/expressions/`:

| File | SHA256 |
|---|---|
| `ProbeSupport.sk` | `d7e984117e198cb78020296f72cf39857fc17f1ad56e3e6a49662d2b463325a8` |
| `ProbeExpr.sk` | `c6ebed18d72a88f89651d5dcc6ecf339582c671ecbed9613a4b0f1d405aec629` |
| `ProbeMaps.sk` | `9e09d1e0a976df948a944b799ca2e657e071ac17e29ceed39fdd8eb479dfb4a5` |
| `ProbeFailures.sk` | `86372ca6ac5874e91179d811cda77d0a8129376b2878bd0e09199177a861ccf9` |

- Support restores two independent runtimes from one checkpoint and compares results plus refs, initializers, identities, runtime flags/settings, caches and counters. It excludes wall-clock primitive nanoseconds when profiling; counters are not an ordered primitive-event trace.
- Expr has 19 fixed packed-word vectors, both constructors, both child Word/Scalar representations, all four binder infos, profile off/on, maximal unsigned data, range dominance/zero subtraction, depth 254/255, and each metadata flag in either child. Expected words are constants rather than outputs from the production hash routine; two native-reference anchors are also present (`35193678269718`, `17602979302435`). It asserts retained child/name/info identities, child immutability, repeated-child aliasing, and unavailable unused name/info.
- Maps covers all four functions and both profile modes, unsigned USize boundary/wrap, empty/short arrays, insert/overwrite/distinct-leaf collision, retained sibling/ref descent, nonzero suffix shift, maximal unsigned hash selecting slot31, collision sizes3/4 and depths1/6/7/8, and oversized overwrite. Independent finite-association traversal checks no keys are lost/duplicated and values remain the expected opaque objects, rather than using production lookup as its oracle. Simple branches have exact shape assertions; threshold insertion checks collision-vs-entries shape. Old roots are also held through checkpoint refs and compared with input copies.
- Failure-driver source retains matching malformed-node/Expr failure expectations, but the current combined file also references the two binding `_fallback` names. **For six-only integration, run ProbeExpr and ProbeMaps directly; defer the combined ProbeFailures driver or use a parent-owned six-only driver until those fallback names are provided. Do not integrate unapproved binding rewrites merely to make that driver compile.**

## Limits and parent execution priorities

1. Integration can begin now for these six; keep exact old ABI/body as `_fallback`, redirect its direct self-recursion, and check normal compiler/module resolution in the parent queue. No replacement speedup is claimed or required.
2. Prioritize release ProbeMaps across all four families/profile modes, retain the completed release ProbeExpr evidence and its source selection, then existing Expr/Metadata/MVar regressions and parent-owned end-to-end proof/reject validation as appropriate. Existing full validation must not be replaced by helper parity alone.
3. Fallback independence is bounded: unchanged collision redistribution helpers can call the canonical insertion, so even a self-recursive fallback is not an entirely isolated old call graph. Independent association/shape/constant metadata expectations are essential and were reviewed here.
4. Nonblocking probe improvements: explicitly assert the selected child slot for the hash-suffix fixture and entries-vs-collision tag for the oversized-overwrite threshold case (currently association coverage plus differential shape); add equal-but-distinct key identity expectations, and a malformed collision missing field2 to pin unused-projection preservation. The source paths preserve those contracts; these omissions do not block integration of this six-body subset.
5. Coverage is not exhaustive for malformed inputs, giant arrays, all theoretical wrapped traversals, or ordered effects. Binding returned EStateM error/state (X-1) is deliberately not covered by this approval.

Report destination was checked absent before creation.
