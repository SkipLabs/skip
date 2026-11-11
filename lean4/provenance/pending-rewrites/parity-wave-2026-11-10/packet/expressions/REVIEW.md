# Expressions lane review / integration handoff

## Status and scope

**Eight bodies ready for review; no compilation, execution, tests, probes, or benchmarks were run by this lane.** Parent owns the serialized validation queue and should integrate only reviewed bodies. No performance claim is made. Work is confined to `build/parity-wave/expressions`; originals and manifest are unchanged. No applicable AGENTS.md was found in ancestors or the relevant source/test trees. Archived drafts were not used.

Static source inspection (not a compiler check) found:
- 8/8 canonical parameter names, order, types, result types and module names exactly match the frozen originals (whitespace ignored).
- 8 replacement files; 11 total production functions (8 canonical + 3 unique helpers).
- No pre-existing canonical `_fallback` conflicts at the handoff inspection.
- No unresolved qualified production function references in replacements/probes against the source inventory plus the eight expected fallbacks.
- All original frame arrays / program-counter dispatches are removed from replacements.

## Files

One file per manifest target under `replacements/`:

| File / canonical function | Original module | Replacement lines including helpers/module |
|---|---|---:|
| f_Expr_forallE_override_b21c7ca660.sk | L4_Lean_Expr | 83 |
| f_Expr_lam_override_5bc80605de.sk | L4_Lean_Expr | 83 |
| f_assignExp_spec_0_spec_0_12353c570c.sk | L4_Lean_MetavarContext | 149 |
| f_assignLevelMVarExp_spec_0_spec_0_c459d88a74.sk | L4_Lean_MetavarContext | 149 |
| f_addExprMVarDecl_spec_0_spec_0_0c9fc4045a.sk | L4_Lean_MetavarContext | 149 |
| f_mkLocalDecl_spec_0_spec_0_eab4f1c354.sk | L4_Lean_LocalContext | 149 |
| f_MetavarContext_mkBinding_spec_0_4115d2aad9.sk | L4_Lean_MetavarContext | 40 |
| f_MkBinding_mkBinding_spec_0_5c82fc8500.sk | L4_Lean_MetavarContext | 395 |

Three helpers are defined **only** in the last file:
- `f_expressionsWave_bindLocal`
- `f_expressionsWave_bindLet`
- `f_expressionsWave_bindMVar`

Probe files:
- `ProbeExpr.sk`: constructor words, input sharing, scalar representations, native lambda vector.
- `ProbeMaps.sk`: all four insertions, independent finite-map traversal, persistent roots.
- `ProbeBindings.sk`: binding matrix, abstraction, eta, dependency elimination, names/state, ID collection.
- `ProbeFailures.sk`: separate-process malformed-input / bounds failures, old and new routes.
- `ProbeSupport.sk`: shared raw-checkpoint differential comparison and snapshot checks; no main.

There are 4 executable drivers and 1 support file. Replacement files total 1,197 lines versus 2,592 lines in frozen original files, including module wrappers. The binding helper split intentionally introduces small intermediate EStateM ok wrappers; these do not escape, affect reference state, or substitute for actual Expr construction. This is a readability change, not an established speedup.

## Contracts read

- All eight frozen originals and their family diffs.
- Expr metadata accessors in `sources/Modules/Lean/Expr/Metadata.sk`, `f_Lean_Expr_mkData_9e4edaf0b9`, constructor wrappers, beta/abstraction/lowering entry points.
- `src/Support/ExprData.sk`, `Words.sk`, `Values.sk`, `Extensions.sk`, checkpoint representation in `Execution.sk`.
- PersistentHashMap empty/collision constructors, collision-size helper, specialized collision insertion and redistribution helpers.
- MkBinding elimMVarDeps / elim / mkLambda / mkFreshBinderName and public binding wrapper; LocalContext declaration constructors/getFVar; MetavarContext declarations/assignments/default.
- `tests/Support/RewriteProbe.sk`, `ConstructorBoundariesProbe.sk`, `MetadataProbe.sk`, `ExprProbe.sk`, `ExprReference.lean`, `check_expr.py`, MVar and existing fixture patterns.
- `tools/probe.py` and source-selection/integration contracts (read only).

## Old/new branch mapping

### forallE and lam constructors

Both constructors have identical semantic pipelines despite different original join-slot permutations:

| Original pc | New code |
|---|---|
| 0 | Read type data; truncate to UInt32 hash; mix seed; read body data; mix body hash; compute loose range. |
| 6 | Read type depth then body depth, widen UInt8 to UInt32, select max (ties choose body). |
| 5 | Add one using UInt32 helper, then type-first short-circuit hasFVar. |
| 4 | Type-first short-circuit hasExprMVar. |
| 3 | Type-first short-circuit hasLevelMVar. |
| 2 | Type-first short-circuit hasLevelParam. |
| 1 | mkData(hash, range, depth, fvar, exprMvar, levelMvar, levelParam), then exact Expr tag/field order. |

Expected metadata, independently of the frame graph:
- hash = mixHash32(mixHash32(seed, typeData & 0xffffffff), bodyData & 0xffffffff); seed 29 for lam, 31 for forallE.
- range = max(typeRange, saturatingNatSub(bodyRange, 1)).
- depth = min(255, max(typeDepth, bodyDepth) + 1), with saturation in unchanged mkData primitive.
- flags = OR of child flags, obtained with original left-biased accessor calls in FVar / ExprMVar / LevelMVar / LevelParam order.
- packing: low 32 hash bits; depth bits 32..39; flags bits 40..43; 20-bit range at 44..63.
- Name and binderInfo do NOT contribute to hash. All four payload inputs are stored by identity, even when type and body alias.

No new raw host arithmetic replaces production UInt/Nat helpers. Nineteen synthetic vector pairs in ProbeExpr were calculated with separate unsigned big-integer arithmetic; they are fixed data, not production hash/packing calls. They include zero, all-one low hashes, zero/one/saturated and competing ranges, saturated depth, all bits set on either side, and complementary flags. Each pair is checked for both constructors, four binder infos, independent Word/Scalar forms of both inputs, and profiling off/on: **1,216 fixed-vector comparisons**, plus six native/shared-input and four unused-name/info sentinel comparisons = **1,226**.

Native anchor: `tests/ExprReference.lean` constructs lambda x implicit (bvar 0) (app (bvar 0) (bvar 2)). Its unchanged lambda in the first output group's final entry has data **35193678269718**, also present in existing `build/expr-native.log` and `build/expr-reference.jsonl`. The same group's second entry anchors forall x instImplicit Prop (app (bvar 0) (bvar 1)) at **17602979302435**, after instantiate1 removes the outer free-variable slot. Both constructors therefore have native anchors. These are existing references, not newly executed native results. Parent should still run the broader native ExprReference/ExprProbe comparison.

### Four persistent-map insertions

All share the decision tree but retain specialization-specific equality, collision insertion, redistribution and unreachable error identity:

| Family | Equality | Collision helper suffix | Redistribution suffix |
|---|---|---|---|
| assignExp | MVarId beq | b6d825e9a9 | 00fea488e7 |
| assignLevelMVarExp | LevelMVarId beq | a5519a5b2d | 0c070890ee |
| addExprMVarDecl | Name beq | 7cdfe17019 | 1f904cb2fc |
| mkLocalDecl | FVarId beq | 03317ac977 | f9ab22e0ba |

- Original pc0 entries => mask suffix by 31, convert to Nat, read size, bounds comparison. Out-of-bounds returns the **exact old node**, not a reconstruction.
- In-bounds reads old entry, then original temporary PUnit array write **before** inspecting entry/equality. The immutable write helper clones/overlays; no input root becomes mutable.
- Entry: equal key overwrites supplied key/value; unequal key builds two-item collision under a ref, old pair first.
- Ref: shift suffix right five, USize-add one to depth (including modulo overflow), recurse through canonical identity, wrap child result.
- Null: create supplied key/value entry.
- Original pc1 => second immutable array write and entries-node publication. Siblings and values remain shared.
- Collision: project keys/values/proof, erase proof as before, specialized collision helper. Test 7 <= depth **before** collision size. Depth >= 7 retains collision; otherwise retain size < 4; expand size >= 4, even on overwrite.
- Expansion uses exact old redistribution helper, depth, keys, values, Nat zero, fresh empty entries. Non-exhaustive and specialization-specific unreachable messages remain explicit.

ProbeMaps also keeps each input root in a real checkpoint reference and re-reads it after both branches. ProbeMaps checks independent associations by walking storage without insertion/hash/production lookup. It checks exact simple shapes, threshold tag, value identity, immutable roots, sibling sharing, modulo USize and nested copies. **23 cases x 4 families x 2 profiling modes = 184 comparisons.** Forced-collision fixtures need not match names' natural hash buckets before expansion; these are direct insertAux boundary fixtures, and the independent model does not assume bucket layout.

Oracle limitation: retained original *self* recursion is redirected to fallback, but existing redistribution helpers call canonical insertion again. Expansion is not a wholly isolated old call graph. Independent association/shape/snapshot assertions are essential; fallback equality alone is not proof of expansion correctness.

The declaration-named target is an insertAux specialization (including the user-name map path), not the entire public declaration transaction. No public counters/context wrappers are bypassed or replaced.

### MetavarContext.mkBinding ID collector

- Original pc0 => termination by **USize equality**, not less-than or array length.
- Read item, test only isMVar; other Exprs (including apps containing mvars) do not contribute.
- MVar => mvarId then unchanged persistent set insertion; duplicate can preserve old set identity.
- Original pc1 => USize add one then next iteration, preserving wraparound/helper order.
- Empty interval returns exact input set without inspecting array.

ProbeBindings includes full/subrange collection, duplicates, app non-descent, populated set identity, max-USize empty interval and poisoned unused array.

### MkBinding reverse Nat fold

- Original pc0 zero => EStateM ok(body, state), inspecting no other inputs. Nonzero => Nat subtract one, array lookup, isFVar.
- Non-FVar => bindMVar: validate/project state/declaration in original order, headBeta type, eliminate dependencies, abstractRange(index), test anonymous, optionally generate fresh hygienic x with threaded state. Test isLambda *before* projecting context binderInfo. usedOnly does not apply.
- Original cdecl + pc2 + pc1 => bindLocal: if usedOnly, inspect bvar0 and skip/lower if absent; otherwise headBeta, elimMVarDeps, abstractRange, real forall/mkLambda.
- Original ldecl => first short-circuit generalizeNondepLet AND nondep. True uses bindLocal/default binderInfo; false uses bindLet.
- Original pc5 => bindLet's usedLetOnly check and optional lowering. Old pc5's extra flag is necessarily Bool_false on all reachable incoming edges: generalize false, or generalize true/nondep false. No true/nondep edge reaches retained-let construction.
- Original pc4 => eliminate type first; on success eliminate value using type-result state; abstract type then value; construct real letE with original nondep; continue with value-result state. **No headBeta** on retained-let type/value.
- Original pc3 => bindMVar's real forall/mkLambda, retaining fresh-state changes.
- Recursive continuations => update body/state/remaining in structured loop. Nat never narrows to host integer. Reader context remains constant.
- Every elimination error returns the same EStateM error object, with original field projections. Impossible mkFreshBinderName error keeps original unreachable failure. No error converts to success, and remaining binders are not processed after error.

ProbeBindings: **384 local flag-matrix comparisons** (3 declaration kinds x 2 usage cases x 2^5 flags x 2 profiling modes), 54 other binding comparisons (including eight real error cases), and 8 collection comparisons = **446** total. Includes dependent abstraction/reverse order, ordinary headBeta vs retained-let non-beta, assigned-mvar type/value elimination, eta sharing, named mvars despite usedOnly, anonymous hygiene with small/arbitrary-precision nextMacroScope, poisoned unused type/value/context/state, empty-fold identity and immutable states/locals.

## Foundations review follow-up (X-1 and coverage requests)

Read the expressions section of the foundations initial plan and the explanatory native Lean MkBinding source at /home/julienv/lean4/src/Lean/MetavarContext.lean. That checkout is explanatory, not the frozen parity oracle. Important added independent cases:
- Each of four metadata flags separately on either child; depth 254 on either child, 255 saturation, all bits set; unused LeanUnavailable binder name/info retained without decoding.
- Full unsigned USize hash 2^64-1 selecting slot 31, plus checkpoint-held map roots.
- Eta blocked by the function's bvar0 dependency, blocked by a nonzero argument, and explicitly disabled; allowed free-variable eta retains its exact object.
- **X-1: four real binding EStateM error sites x two profiling modes**, with exact independently constructed exception/state. No fake callback, altered result acceptance, or weakening of equality.

X-1 fixture: a valid dependency local context contains x : Prop followed by y : x. A metavariable m is declared over that context. Binding variables ordered [y, x, z] (or [y, x, n] for the mvar branch) causes elimination of m with preserveOrder=true to encounter y's dependency on the later x. The four cases reach local-type, retained-let-type, retained-let-value and mvar-type elimination. A poisoned let value must not be read after the type error. The anonymous n must not allocate a fresh binder name after its type error; the remaining y/x binders must not be processed.

Independent expected result is exactly:
- EStateM_Result_error;
- exception MetavarContext_MkBinding_Exception_revertFailure(errorMctx, dependencyLocals, [y, x], LeanText("y"));
- returned MkBinding state with the same mctx, nextMacroScope=7 and name generator, but the fresh **empty 16-bucket Expr cache**, not the original nonempty cache.

This last distinction is deliberate: elimMVarDeps/withFreshCache restores the old cache on success only, while its error branch returns the error state. The fixture seeds a valid nonempty cache with prop -> prop, then requires the returned state to differ from the input exactly at cache field 3. It also checks unchanged mctx/generator identities and retained immutable input snapshots. Expected exception and returned-state fields are not computed by calling the dependency helper or fallback.

These additions are authored and statically traced, **not executed**. X-1 should be treated as a required parent-run validation case, not as passed evidence.

## Effects, snapshots, error boundaries

- Production helper calls remain at original semantic points, even where direct bitwise code could fuse them.
- Temporary array clears remain for instrumentation/order. No mutation of published LeanValue arrays/roots.
- Constructor data access/mkData remain on profiling-aware boundaries.
- No new world/ref/trace operations. Existing dependency helpers keep behavior and unsupported errors.
- Probes use separate `restoreRaw()` runtimes from one immutable checkpoint, per RewriteProbe patterns. Compare result, refs, initializers, identity tables, flags, Simp state, metrics. Primitive elapsed nanoseconds (metrics[7]) excluded only when profiling; counts compared. Input copies check root immutability. ProbeSupport supplements shared support without modifying it.
- Failure driver covers invalid Expr, invalid node, huge Nat fold index, start > stop collector bounds. Compare old/new status/diagnostics. Expected exit 86.

## Untested / unsupported boundaries and review priorities

**This lane executed nothing.** Source inventory and ABI checks are not syntax/type/semantic validation. Coordinator validation reported below is separate; remaining probes can still contain Skip or fixture errors.

Highest priorities:
1. bindLet's proof that old pc5 flag is false; local vs mvar usedOnly; elimination error identity/state; anonymous-name state; type-before-value order.
2. Constructor old join permutations vs mkData order, especially forall range/depth/FVar placement; seeds, saturation, unsigned words, aliases.
3. Specialized collision/redistribution suffixes, threshold/depth order, immutable temporary arrays; fallback/helper reentry caveat.
4. Compiler acceptance of helper signatures/loops/fixtures, then native hashes and snapshot/profile comparisons.

Not claimed covered by executable fixtures:
- Successful deep mvar-dependency elimination creating new mvars/delayed assignments. Real preserveOrder EStateM errors now have explicit fixtures (X-1 above); other error families remain untested.
- mkFreshBinderName impossible error and unreachable collision-helper tags; malformed tests are representative, not exhaustive.
- Every malformed field count, mismatched collision arrays, theoretical full USize wrap traversal, huge valid arrays. Bounds stay delegated.
- Ordered primitive trace capture: source-call order preserved; probes compare counts/state, not an ordered event log.
- End-to-end theorem export/native kernel validation. No proof shortcut added; parent should keep normal full validation.

## Coordinator evidence (separate from lane execution)

Coordinator reported the private-overlay **release ProbeExpr passed** with unchanged production and old self-recursion retained. Read `build/parity-wave/expressions-expr-check.log`: it ends with `expressions constructors passed`; selection/body hashes are in `build/probes/parity-expressions-expr-draft/sources.json`. Coordinator also reported the private-overlay release ProbeMaps passed; read `build/parity-wave/expressions-maps-check.log`, ending with `expressions persistent maps passed`. These confirm only those frozen overlay runs, not binding/failure probes or integrated production. The prior debug attempt failed in generated LLVM on undefined SKIP_print_stack_trace; it was not a source-level or semantic test pass. No lane benchmark was run.

Foundations reviewer bounded static approval for the six constructor/map bodies is in `build/parity-wave/reviews/expressions-six-static-fd9159c3.md`. This does not approve either binding target; the completed X-1 error cases in ProbeBindings are now ready for that separate review and parent execution. Six-only integration cannot compile the combined failure driver until binding fallbacks are supplied by an approved integration or private overlay. Defer that driver rather than integrating unapproved bodies.

## Parent-only validation commands (NOT RUN BY THIS LANE)

Review/integrate all eight files first, retaining each old function as `<canonical>_fallback` with self-recursion redirected. Do not include replacements in probes while canonicals still exist: that duplicates definitions. After integration, serialize:

```sh
cd /home/julienv/skip/lean4
LANE=build/parity-wave/expressions
python3 tools/probe.py --release --name parity-expressions-expr --rewrite-harness \
  --include "$LANE/ProbeSupport.sk" --driver "$LANE/ProbeExpr.sk"
python3 tools/probe.py --release --name parity-expressions-maps --rewrite-harness \
  --include "$LANE/ProbeSupport.sk" --driver "$LANE/ProbeMaps.sk"
python3 tools/probe.py --release --name parity-expressions-bindings --rewrite-harness \
  --include "$LANE/ProbeSupport.sk" --driver "$LANE/ProbeBindings.sk"

# Compiles then intentionally exits 86 (default malformed node).
python3 tools/probe.py --release --name parity-expressions-failures \
  --driver "$LANE/ProbeFailures.sk"
# Check exit 86 and matching old/new stderr for each pair:
for mode in node expr fold-index collect-index; do
  printf '%s\n' "$mode" | build/probes/parity-expressions-failures/probe
  printf 'old-%s\n' "$mode" | build/probes/parity-expressions-failures/probe
done

# Existing production/native-vector regressions:
python3 tools/probe.py --release --name parity-expressions-existing --driver tests/ExprProbe.sk
# Capture that executable's JSON output to <skip-output>, then compare:
python3 tests/check_expr.py <skip-output> build/expr-reference.jsonl
python3 tools/probe.py --release --name parity-expressions-metadata --driver tests/MetadataProbe.sk
python3 tools/probe.py --release --name parity-expressions-mvar --driver tests/MVarProbe.sk
```

Expected failure diagnostic bodies from read contracts (usual `Lean-to-Skip: ` prefix):
- node: `non-exhaustive Lean case`
- expr: `expected a Lean Expr`
- fold-index: `Lean Array index out of bounds (panic recovery is not implemented)`
- collect-index: `Lean Array USize index out of bounds`

Native reference regeneration, full build/test/proof verification, and benchmarks belong exclusively to parent's serialized queue. This lane neither ran nor scheduled them.

## Final lane freeze

No replacement body changed during X-1/coverage additions. Final read-only inventory again found exact canonical signatures and no unresolved production references. The lane is ready for the remaining reviewer/coordinator steps; no execution is requested outside the parent queue.

Binding artifacts for review:
- replacements/f_MkBinding_mkBinding_spec_0_5c82fc8500.sk: SHA256 70ec871bf42a595dc2905af39d11bca2e4c544df9dfffebfc7d35f94492a4393
- replacements/f_MetavarContext_mkBinding_spec_0_4115d2aad9.sk: SHA256 bab9fe2a1daef450cca11f85ec247f2eb01125656cc86aa2f3f6d7a2a6d1dfed
- ProbeBindings.sk (including X-1): SHA256 7669a71e2a03cbf5a1d12a84a9137bc3795c134e7c340802dfedc9f53a70700b

Constructor/map probe bytes remain those recorded in the six-body review. Nonblocking map-probe refinements noted there (equal-but-distinct key identity, malformed missing collision proof field, extra explicit selected-slot/oversized-overwrite tag assertions) are deferred rather than modifying the coordinator's queued/frozen packet. Existing differential shape/model checks remain strict; no unexpected outcome is accepted.
