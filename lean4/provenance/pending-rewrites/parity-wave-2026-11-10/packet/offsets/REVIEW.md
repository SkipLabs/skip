# Offset family parity/readability packet

## Status and integration boundary

**Ready for body review; uncompiled and unexecuted.** No build, test, probe, benchmark,
translator, commit, push, cache deletion, or shared-production edit was performed by
this lane. Only `build/parity-wave/offsets/` was written. There were no applicable
ancestor/lane AGENTS.md files. No archived pending draft was used.

Baseline: manifest `41bb486d9`. Read all four originals, production Offset helpers,
`/home/julienv/lean4/src/Lean/Meta/Offset.lean`, NatInstTesters and SafeExponentiation
Lean/Skip contracts, instantiateMVarsIfMVarApp and annotation cleanup, real inference
and equality entry bridges, Nat runtime, and maintained NaturalReduction,
DiscrTreeOffset/Numeral, StuckMetavariables, DefEqQuick/FastPath and RewriteProbe
fixtures. Incorporated `reviews/elaboration-initial-risk-review.md` offsets guidance.

Integrate all four `replacements/<canonical-simple-name>.sk` as one family. Each
contains the same module and byte-identical canonical parameter-name/order/type/
result signature from its original. Helpers are defined **once**, have the unique
`f_offsets_wave_` prefix, and are cross-file references within that module. Do not
integrate `ProbeOracle.sk`: it intentionally contains frozen frame machines as
**test-only oracles**. No replacement calls a fallback.

| Target | Manifest original lines / frame slots | Replacement file lines | Helpers |
|---|---:|---:|---:|
| isOffset? | 643 / 104 | 143 | 4 |
| evalNat.visit | 4317 / 392 | 301 | 3 |
| evalNat | 194 / 29 | 113 | 7 |
| isDefEqOffset | 796 / 129 | 250 | 7 |
| **Total** | **5950 / 654** | **807** | **21** |

`PACKET.json` records the file list, hashes, signatures, counts and empty execution
record. `Probe.sk` has 548 lines; its test-only 8-function oracle has 6223 lines.
The authored matrix schedules 312 comparisons across the two profiling modes
(156 per mode); that is a static case count, **not** a passing test count.

Counts include full replacement files (comments/modules/helpers), so they are not
performance evidence. Four canonical routines plus 21 helpers = 25 production
function definitions. Source-only inventory found no frame slots/jump/pc machine,
duplicate helper definition, missing referenced function name, or signature drift.
Delimiter/name inventories are **not** a compiler or semantic validation.

Replacement file SHA256:

- isOffset: `6c4d2a3d868e54cdb28674fa2f2aea3a9cf4ac595535b4c5ad09f0db8b8b3fd8`
- visit: `b6d4005330eb50cd2935ffdb0daa7d0eb79645a74f21787e1b4a32e7599ef2fd`
- evalNat: `68d584291331245f31e421633615087ea7880f50c352f8158ee194027d5d3976`
- isDefEqOffset: `b57aa73689e9979845a6d713aaa31fc1c45079a9cf40c721dceca3506c953bca`

## Branch mapping

### evalNat wrapper

Original pc 0 becomes the expression-tag match; original pc 1 becomes `none(world)`.
Raw nat literal -> some identical Nat payload. Other literal -> none. Metadata ->
self recursion with identical context/state/world. Nat.zero uses the exact two
string Name components beneath anonymous, not printed names or hash equality;
universe arguments remain ignored. App/mvar -> visitor, everything else -> none.
The result stays EST_Out<Option<Nat>>, never a raw Nat or Bool.

### evalNat.visit (the 4317-line routine)

Original pc 0 instantiation/cleanup is unchanged in order:
`instantiateMVarsIfMVarApp` -> successful-world extraction -> `cleanupAnnotations`.
Non-app at that point -> original pc 1 none. In particular an assigned mvar that
instantiates to a literal or Nat.zero is **not** restarted at evalNat. Metadata
around a mvar is not moved before conditional instantiation.

Incremental `appFnCleanup` peeling, not a full eager spine traversal:

| Original slots/cases | Named replacement case | Action |
|---|---|---|
| 14/16/17, Nat.succ | expression / lastArgument / unaryHead | eval argument; Nat.add value 1 |
| 23/24 | leftOperand / binaryHead | Nat.pow, mod, div, mul, sub, add in original recognition order |
| 44 | ternaryHead | OfNat.ofNat: structural tester on lastArgument, then eval leftOperand (the numeral) |
| 50/51 | instance / homogeneousHead | NatPow.pow, Mod.mod, Div.div, Mul.mul, Sub.sub, Add.add |
| 71 | powerHead | Pow.pow |
| 76 | heterogeneousHead | HPow.hPow, HMod.hMod, HDiv.hDiv, HMul.hMul, HSub.hSub, HAdd.hAdd |

Recognized arities are 1, 2, 3, 4, 5, 6 respectively. Nonmatching heads/partial or
extra application shapes retain none. Ignored type arguments remain ignored.
Each of the **14** structural Nat instance testers is the exact original function,
with the same instance argument, meta-state ref, and world. False -> none using the
tester's world; error -> error, no operands. No replacement with matchesInstance.

All 5 non-power binary operators share `evalBinary`: evaluate left, short-circuit
none/error, evaluate right with left's world, short-circuit, call the exact Prelude
Nat arithmetic helper, return some using right's world. No 0*x, x^0, 1^x or other
expression-level arithmetic shortcut was introduced. Nat.sub saturates; div by
zero is zero; mod by zero is the dividend; arithmetic remains arbitrary precision.

Power delegates to the unchanged `evalPow`: evaluate exponent -> `checkExponent`
with warning=true -> only when allowed evaluate base -> Nat.pow. Threshold option
recording, warning deduplication, world/error propagation and the explicit runtime
exponent limit are retained. No native Int/word conversion in replacements.

### isOffset?

Original pc 0 becomes four expression cases with the original instantiation,
annotation cleanup and incremental app peeling. Successor -> getOffset argument,
then add 1 to the returned offset (not evalNat argument). Nat.add -> `addOffset`.
Add.add/HAdd.hAdd build **the original canonical instance expression**, then call
`matchesInstance`, which uses new mctx depth and instances transparency. These
must not be replaced by the visitor's structural testers.

Original pc 1 -> `addOffset`: evaluate **right** numeral before getOffset **left**,
then add returned base-offset plus numeral. pc 2 -> none. getOffset's fallback
still returns its **original input expression** and zero, retaining a metadata-
wrapped non-offset base, even though recognition cleaned annotations.

### isDefEqOffset

Original pc 0 -> direct ordered case analysis:

1. config field 8 false -> EST_Out ok LBool.undef, inspect neither expression.
2. left offset some -> right offset; both some compare amounts, equal -> compare
   bases, `<` -> mkOffset right base by (right-left), `>` -> mkOffset left base by
   (left-right). mkOffset happens **before** the type guard as before.
3. left offset/right none -> evalNat right; none -> undef; numeral >= offset ->
   compare base with `mkNatLit(numeral-offset)`; insufficient -> guarded LBool.false.
4. left offset none -> evalNat left; none -> undef **without inspecting right**.
   Then right offset some gives the symmetric comparison with argument order
   preserved; otherwise evalNat right, none -> undef, some -> guarded Nat.decEq
   converted by the same Bool.toLBool helper.

Original pc 1 -> `checkNatType` plus `ifNatValue`/`compareNat`. Infer type of the
**original top-level left s**, never a normalized/stripped residual. Build Nat,
retain the original LeanClosure adapter (arity 7, 2 captured expressions), call
`matchesInstance_spec_0` with allowLevelAssignments=false. False -> LBool.undef;
error unchanged; true -> value or actual residual defeq. Original pc 2's closure
allocation/apply is replaced by a direct call to its unchanged lam_0 body **after**
the guard. That body still performs the real isExprDefEqAux and Bool->LBool map.
Residual equality is outside the protected new-mctx-depth scope, as originally.
No proposition/proof/assignment/equality result is fabricated.

## Effects, failures, roots, profiling

- State refs, contexts, world values and errors flow through every existing
  effectful helper in the same order. No rollback/cache policy is invented. A
  failed optional computation does not drop previous state effects.
- Helpers validate EST_Out, Option, Bool and pair tags. The original explicit
  `non-exhaustive Lean case`/unreachable argument errors remain. Invalid join-point
  failure disappears because there is no pc to corrupt.
- No root/checkpoint is mutated by replacements. Existing persistent state/ref
  operations remain in their existing dependencies. No ABI/type/tag/name changes.
- Existing traced general-defeq/inference paths and profiling-aware Prelude
  functions are still called. Raw allocation counts and nanosecond metrics are
  not parity invariants; this task deliberately changes allocation/control flow.
- These routines do not construct proof terms themselves. Their actual defeq,
  instance and expression-construction helpers remain intact. Whole-proof kernel
  checking belongs to the parent's correctness queue, not this local packet.

## Probe routing and independence

`Probe.sk` is an executable main, included with `tests/Support/RewriteProbe.sk`.
Default old route calls `ProbeOracle.sk` global `f_offsets_oracle_*` functions.
The oracle copies the four frozen originals plus getOffset/evalPow/mkOffset/
isNatZero, changing only their function identifiers/references and qualifying the
two remaining unqualified production Offset helper calls. All 8 local recursion
loops stay in the oracle. `write_oracle.py` records each pre-renaming body hash;
the selected packet hashes are verified with the manifest's identity-comment +
function convention. The generated file is already present; do not regenerate it
from later production sources casually.

Set `LEAN_SKIP_OFFSETS_CANONICAL_FALLBACK=1` to run the same independent expectations
against the parent's retained `*_fallback` names instead. The environment-variable
name is retained for compatibility; it does not describe the function suffix.
The inspected `/tmp/lean-skip-wave-probe.py` adapter registers the exact canonical
identity plus `_fallback` for each of the four targets. No alias or oracle rename
is needed. The probe now references those exact names:

- `L4_Lean_Meta_Offset.f_Lean_Meta_evalNat_6bfbb6a56e_fallback`
- `L4_Lean_Meta_Offset.f_Meta_evalNat_visit_be1fb46d98_fallback`
- `L4_Lean_Meta_Offset.f_Lean_Meta_isOffset_cecda6b311_fallback`
- `L4_Lean_Meta_Offset.f_Lean_Meta_isDefEqOffset_4916547658_fallback`

The initial overlay selection failure was caused by the optional retained route
in `Probe.sk` spelling these names with the wrong suffix, not by `ProbeOracle.sk`.
Source selection scans references in **both** runtime branches, so including the
oracle does not hide a nonexistent fallback reference. Only the four references
and the first-line probe comment changed; replacement bodies and the frozen oracle
are unchanged. This correction was source-inspected only, not compiled or run.

**Neither route is a wholly isolated baseline runtime.** Shared dependencies
include matchesInstance/withNewMCtxDepth, structural testers, mvar instantiation,
inference, general equality, checkExponent, expressions and arithmetic. General
equality can indirectly re-enter current Offset code; other wave lanes may change
shared helpers. Therefore fixed expected results and targeted state assertions
are essential. The oracle isolates *local family recursion*, not the entire
mutually recursive Lean Meta graph.

Probe contents (authored, not run):

- profileRuntime false/true; copied input roots, immutable retained checkpoint,
  EST result/world parity, exact ref snapshot parity, fixed expected values.
- Every Nat arithmetic operator, all homogeneous/heterogeneous families, Pow,
  NatPow, OfNat, instance rejection, unsupported/partial/extra applications.
- 2^64 and beyond, saturating subtraction, div/mod zero, exponent zero, and no
  expression-level arithmetic shortcuts on blocked values.
- assigned/unassigned mvars and assigned function application; literal-instantiation
  none behavior; metadata at heads/base/right/nested positions.
- offsets, nested offsets, zero offset `some`, original base preservation,
  right-before-left evaluation, Add/HAdd definitional instance matching.
- all isDefEqOffset top-level branches, both unequal-offset directions, both
  numeral/offset orientations; disabled/unknown undef; numeric contradictions;
  deliberately non-Nat original type still undef; older type/instance metavars
  not assigned by protected checks. Fixtures install only needed declarations;
  they are interface fixtures, not a proof of the imported Nat implementation.
- exact recursion-depth errors in inference and instance matching; trace-aware
  dependency route with trace-options flag but no timed trace enabled.
- threshold 4 / exponent 5 with blocked base, first warning and deduplication;
  early exits which must not log a warning. Messages differ after first warning,
  are unchanged on repeat, and match the old route's complete ref state.
- subprocess-selected old/new explicit Nat.pow exponent-too-big error with base
  2 and exponent/threshold 4294967296, avoiding any huge result allocation.

## Parent queue commands — NOT RUN HERE

After body review and all four integrations/fallbacks, from repository root:

```sh
python3 tools/probe.py --name parity-offsets --rewrite-harness \
  --driver build/parity-wave/offsets/Probe.sk \
  --include build/parity-wave/offsets/ProbeOracle.sk

# Same binary, less-isolated retained fallback route:
LEAN_SKIP_OFFSETS_CANONICAL_FALLBACK=1 build/probes/parity-offsets/probe

# Exact unsupported boundary, two independent processes. Both must exit nonzero
# with `Nat.pow exponent is too big`, not the probe's missing-failure message.
LEAN_SKIP_OFFSETS_FAILURE=old-pow-limit build/probes/parity-offsets/probe
LEAN_SKIP_OFFSETS_FAILURE=new-pow-limit build/probes/parity-offsets/probe

# Optional optimized correctness pass, not a benchmark:
python3 tools/probe.py --name parity-offsets-release --release --rewrite-harness \
  --driver build/parity-wave/offsets/Probe.sk \
  --include build/parity-wave/offsets/ProbeOracle.sk
```

Parent also owns full-wave ABI/integration validation, full compile, existing
NaturalReduction/DiscrTreeOffset/Numeral/StuckMetavariables and equality regressions,
and the serialized imported-Goal kernel correctness matrix. No intermediate
benchmark is requested.

## Review priorities and remaining boundaries

1. Compile the 4 bodies as a unit, then compile the probe. Fixture/parser/type
   corrections may be needed: nothing executable was run here.
2. Check arity/cleanup peeling and the distinct structural/definitional instance
   policies. Read retained isOffset pc 1 and evalPow before approving effect order.
3. Check the original-left type guard/new-depth restoration, equality argument
   orientation, and error worlds. Numeric contradictions must not bypass inference.
4. Inspect oracle routing and independent expectations; do not report shared-helper
   differentials as independent whole-baseline correctness.
5. Full imported instance unfolding, active timed traces, recorded-dependency
   SKStore execution, heartbeat/cancellation errors, huge recursive expression
   stack behavior, malformed truncated constructors, and isDefEqStuckEx=true
   internal-stuck exception paths are **not exhaustively covered**. No new support
   is promised. Parent should prioritize stuck-exception/trace fixtures if its
   matrix does not exercise those paths. No direct proof-kernel test here.

`write_visitor.py` is a lane-local authoring utility that emits repetitive named
operator dispatch arms (not a translator); `write_oracle.py` only copies and
reroutes frozen function identifiers. Compact text/index files are working source
reading aids and are not integration inputs.

## Parent v2 compiler syntax correction

The parent supplied `build/probes/parity-offsets-draft-v2/compile.log`: source
selection resolved, but compilation rejected a superfluous function-final
`return` at Selected.sk:230147. This maps to visitor replacement line 225.
Only that keyword was removed; `write_visitor.py` emits the same corrected final
expression. All 25 replacement function endings were source-inspected; other
returns are early exits with subsequent enclosing computation and remain intact.

No semantic expectations changed. The other three replacements and frozen oracle
retain their prior hashes. The probe now asserts `checks == 312` immediately
before success output. Default unset fallback flag and later `=1` alternate route
are unchanged. For negative power runs, require the exact actual error
`Lean-to-Skip: Nat.pow exponent is too big` and exit 86, not a substring match
against the fixture's missing-failure sentinel.

PACKET.json and the visitor hash above describe the corrected bytes. The parent/
reviewer must rebind the visitor hash in its review; the prior bounded review is
not silently claimed for newly hashed bytes. No compile/probe/test was rerun by
this lane.

## Parent v3 probe binding correction

Read the complete `build/probes/parity-offsets-draft-v3/compile.log`: the compiler
reported the loop's `instanceName` colliding with the outer metavariable setup.
The correction covers the complete Probe.sk, not just that first diagnostic.
Metavariable identity is now `blockedInstanceName`, operator-instance member text
is `canonicalInstanceMember`; declarations, case loops, closure parameters,
remaining assignments and intentionally-unused comparison results all have
purpose-specific local names. All repeated `_after` bindings were removed in
favor of names such as `_typeDepthAfter`, `_instanceDepthAfter` and `_traceAfter`.

A source-only function-wide binding inventory covers all 13 probe functions,
including 145 bindings in main, with zero duplicate local names even across
sibling scopes. This lexical check is not a compiler/typecheck or probe execution.
The 180 identifier occurrence edits reverse to the exact preceding Probe.sk
hash, so literals, comments, fixtures, expected outcomes, call order, fallback
flag policy and `assert(checks == 312)` are unchanged. The file still has 548 lines.
All four replacement hashes and frozen ProbeOracle.sk are unchanged. Rename and
binding inventories are in `probe-binding-renames.json` and
`probe-binding-inventory.json`; PACKET.json has the new hash. Parent/reviewer may
requeue/review the name-only correction; no executable work was run by this lane.
