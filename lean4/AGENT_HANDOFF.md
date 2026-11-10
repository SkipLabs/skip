# Lean in Skip: detailed agent handoff

Prepared on 2026-11-10. The last implementation checkpoint is **`fa9550dfc`**.
This handoff and its supporting archive are documentation work performed after
the user paused optimization. They do not resume that work.

Navigation:

- [Current status](#1-read-this-first), [user constraints](#2-user-decisions-and-constraints-that-must-carry-forward), [environment](#3-repository-and-environment)
- [Architecture](#4-what-code-exists-and-how-execution-is-structured), [the theorem and benchmark](#5-the-current-theorem-and-what-the-benchmark-compares)
- [Commits and measurements](#6-commits-and-measured-releases), [accepted changes](#7-what-the-latest-accepted-changes-actually-do), [profiling findings](#8-profiling-findings-and-their-limits)
- [Commands](#9-commands-for-the-next-agent-after-resumption), [pending work](#10-pending-work-and-a-suggested-order-on-resumption)
- [Semantic pitfalls](#11-semantic-and-testing-pitfalls-already-encountered), [tooling and peers](#12-tooling-inventory-and-peer-work)
- [Portable archive](#13-durable-archive-versus-machine-local-evidence), [resumption checklist](#14-a-concrete-resumption-checklist)

## 1. Read this first

The project is a maintained Skip implementation of selected Lean elaborator
code, initially derived from Lean's erased compiler representation. It can
construct real proofs for the current typed conditional-simplification workload.
Native Lean prepares imported declarations and independently checks the resulting
proofs with its original kernel. The kernel has **not** been ported to Skip.

The immediate objective is to bring **raw execution without incremental query
reuse** close to native Lean's elaboration speed. Only then should further
SKStore incrementalization become the priority. The user accepts near parity,
such as 25 ms versus 23 ms, and wants subsequent SKStore initialization to cost
at most about twice the raw baseline. Those example numbers describe tolerance;
they are not the timings of the present depth-6 workload.

The latest measured depth-6 medians are **638.291 ms in Skip versus 192.626 ms
in native Lean**. The raw port is still about **3.31 times slower**. All 29 Skip
proofs produced in the latest depth-0/2/6 measurement series passed the native
kernel against the imported `Goal` constant. Near parity is not established,
and this is not yet a general Lean frontend, complete Lean implementation, or
Mathlib-support claim.

**Work is paused at the user's explicit request.** Do not restart optimization,
benchmarks, builds, agents, or Vibe because a historical plan says to work
continuously. Wait for a new instruction to resume. The request for this document
authorized documentation and preservation of pending work only.

The shortest route to understanding the state is:

1. Read this file and [PAUSE_CHECKPOINT.md](PAUSE_CHECKPOINT.md).
2. Read the repository skill, [lean-skip-refactor](skills/lean-skip-refactor/SKILL.md).
3. Inspect the current working tree and the three latest implementation commits
   described below. Do not assume an old agent's working tree is still current.
4. On resumption, begin with the measured bottlenecks in section 10, not a
   rewrite of the entire inventory.

Some older portions of `SIMPLIFIER_PLAN.md`, `REWRITE_PLAN.md`, the worker
reference, and `README.md` describe earlier allocations, workloads, and results.
The pause notices and this handoff describe the current state. In particular,
the old whole-exercised-path rewrite gate and old Vibe launch plans are superseded.

## 2. User decisions and constraints that must carry forward

| Topic | Current instruction |
| --- | --- |
| Source of truth | Maintain the Skip source directly. Do not revive the retired Lean-to-Skip transpiler. |
| Scope selection | Profile the real benchmark and change the functions or representations responsible for its costs. Completing every observed function is not a prerequisite to measurement. |
| Performance order | Raw parity first; then SKStore with first-run cost ideally no more than 2 times raw. Rechecking matters, but first-run performance also matters. |
| Skip itself | Do not change `skiplang/compiler/` or Skip's runtime. If further progress requires that, stop the dependent work and explain the evidence. Changes to this port's `src/Support/` and `src/Runtime/` are allowed. |
| Proof validity | Skip must construct the target proof. No exported target proof, precomputed answer, admitted proof, or fake runtime success. |
| Unsupported behavior | Keep all functions available and preserve explicit unsupported failures. State every shortcut and unsupported path accurately. |
| Readability | Human-reviewable code, meaningful names, coherent files, straightforward control flow. Light comments; explain subtle ownership or semantics rather than narrating every line. |
| Build layout | One application package. Skip libraries do not provide useful compilation isolation for this task. |
| Build workflow | Incremental `skargo check`; cached `skargo build --release` for performance. Retain `target/` and compiler caches. Do not repeatedly erase them. |
| Mutable collections | Use execution-private mutable arrays/vectors where appropriate. Old values, snapshots, and cached results must remain immutable. |
| Inlining | The user suggested `@always_inline`; a three-helper experiment has now been implemented and measured. |
| Git | Periodic coherent commits are authorized. Stage owned files and preserve unrelated work. |
| External workers | Vibe is idle. Do not relaunch the earlier pools or bounded experiment automatically. |
| Current activity | Paused. This handoff does not revoke the pause. |

The user previously authorized substantial autonomous implementation and peer
review. Once explicitly resumed, routine reversible work within these boundaries
does not need repeated permission. A completed helper or status answer is not a
reason to abandon the larger task. Conversely, the current explicit pause must
be honored until resumed.

## 3. Repository and environment

All relative paths in this file are relative to the Lean-in-Skip package unless
otherwise stated.

| Item | Path or identity |
| --- | --- |
| Package | `/home/julienv/skip/lean4` |
| Git root | `/home/julienv/skip` |
| Branch at handoff | `fix/skargo-init` |
| Last implementation commit | `fa9550dfc` |
| Native Lean checkout | `/home/julienv/lean4` |
| Pinned native Lean revision | `63fbf3d3588b404bbe707721df61ecd41885a6f6` |
| Compiler to use | `/home/julienv/skip/skiplang/compiler/stage1/bin/skc` |
| Skargo / formatter | `/usr/local/bin/skargo`, `/usr/local/bin/skfmt` |
| Native Lean environment | `/home/julienv/lean4/build/release/env.sh` |
| Native Lean executable | `/home/julienv/lean4/build/release/stage1/bin/lean` |
| Host used for measurements | Linux, AArch64 |
| Repository skill | `skills/lean-skip-refactor/SKILL.md` |
| Installed skill alias | `/home/julienv/.codex/skills/lean-skip-refactor/SKILL.md`, resolving to the repository skill |

The package lives inside the Skip Git repository. `git show` paths therefore
start with `lean4/`, even when the shell is inside the package. For example:

```bash
cd /home/julienv/skip/lean4
git status --short
git show fa9550dfc -- src/Support/Values.sk
git show f765003c1:lean4/src/Support/Values.sk
```

The installed default `skc` predates compiler fixes already present in this
checkout. Explicitly set `SKC` to the repository stage1 compiler. Those existing
fixes are part of the environment; the current optimization work did not modify
the compiler or runtime.

At pause there were no active build or benchmark processes, no running Vibe
clients, and no active peer work. The implementation working tree was clean
after `fa9550dfc`. The present documentation commit will naturally advance Git
HEAD without changing the measured implementation.

## 4. What code exists and how execution is structured

| Location | Role |
| --- | --- |
| `sources/Modules/` | Active maintained Lean-derived functions and their dependency closure. Edit these directly. |
| `sources/Additional/` | Retained declarations outside the normal selection. They have not all been made idiomatic. |
| `sources/build.txt` | Active source manifest. `build.sk` registers these external files as build inputs. |
| `src/Support/` | Value representation, naturals, words, tags, references, execution state, array adapters and primitive dispatch. |
| `src/Runtime/` | Handwritten port operations that call maintained Lean constructors/functions. This directory is part of the port, not Skip's own runtime. |
| `src/Bootstrap/` | Initialization, environments, import decoding and executable-specific mapped snapshots. |
| `src/Elaboration/Simp.sk` | Typed problem entry and setup of the maintained Meta simplifier. |
| `src/Elaboration/SimpQueries.sk` | Existing intermediate SKStore query hook and eligibility/publication logic. |
| `src/Elaboration/SimpValues.sk` | Semantic comparison/validation used at incremental boundaries. |
| `src/Workloads/Simp.sk` | Raw and incremental runners, timing, sessions, proof export and CLI. |
| `examples/simp/` | Current problem declarations and ordinary native Lean proof. |
| `tools/simp_demo.py` | Build/prepare/run/check/measure orchestration. |
| `tools/SimpReference.lean` | Native Meta-level comparison, with fresh state per repeated call. |
| `tools/CheckProof.lean` | Independent native kernel checking of Skip's exported proof. |
| `provenance/symbols.tsv` | Original Lean names, qualified Skip identities and current source paths. |
| `provenance/rewrite-inventory.json` | Observed-entry inventory and validation dispositions. |
| `provenance/rewrite-batches/` | Exact changes, hashes, executed checks and coverage limits for accepted batches. |

Many public function identities still contain their original hash suffixes.
Keep those compatibility identities and provenance. New internal helpers can
have meaningful names; maintained-module helpers used by the catalog currently
need the `f_` or `apply_f_` naming convention.

The central boundary type is `LeanValue`. It includes immutable constructors
with `Array<LeanValue>` fields, numeric/word/text values, ordinary and persistent
arrays, tracked-array views/overrides, closures, reference handles and explicit
unavailable values. Most public Meta interfaces remain boxed even after their
control flow has been rewritten. Do not call the entire port fully typed/native
because selected loops now use Skip `Int`, `Bool`, or `LeanNat`.

`LeanExecution` owns mutable reference storage, runtime options, initializers,
identity bookkeeping and diagnostics. Reference pages are copied at snapshot or
first-write boundaries. `LeanReferenceSnapshot` and `LeanExecutionCheckpoint`
must preserve previous states. `LeanArrayWrite` uses persistent vectors for
large arrays; ordinary arrays use copy-on-write. These are distinct from the
mutable reference table and must not be conflated.

### Raw execution versus existing SKStore code

The current timing mode is `--raw`. Its execution has no dependency-tracking
query Context, and measured runs reported zero query fetches. Immutable imports
are still loaded through executable-specific mapped SKStore infrastructure.
Some allocation-region helpers are named `SKStore.withRegionValue`; their use
does not establish incremental memoization. They bound temporary allocation.

An intermediate incremental implementation already exists. `SimpQueries.sk`
uses `SKStore.LHandle<LeanSimpQueryKey, LeanSimpQueryResult>`. Keys carry the
expression and relevant normalized simplifier/Meta/Core contexts. Hashes order
lookups, but full values distinguish keys. Each query restores private execution
state from an initialization checkpoint, runs the maintained simplifier, and
checks whether the result and effects are eligible for publication. Unsupported
or unsafe query situations decline and use ordinary execution. The results
include proof/result data, used theorems and local step information.

This is existing work to revisit after raw optimization. Do not present current
raw timings as SKStore speedups. Do not assume the existing hook is a complete
general incremental Lean design. See the source's eligibility, effect replay and
decline checks before extending it. Relevant controls include
`LEAN_SKIP_SIMP_CACHE`, `LEAN_SKIP_SIMP_MASK` and `LEAN_SKIP_QUERY_REGIONS`.

## 5. The current theorem and what the benchmark compares

The active example is conditional reordering of independent instruction blocks:
[Problem.lean](examples/simp/Problem.lean) and
[Proof.lean](examples/simp/Proof.lean). It is not the earlier `limit < 10` example
or the deferred GCD project.

Its recurrence doubles the application structure at each depth:

```lean
def iter {State : Type} : Nat → (State → State) → State → State
  | 0, f, s => f s
  | n+1, f, s => iter n f (iter n f s)
```

The theorem says that two iterated blocks commute, assuming conditional
commutation and an invariant:

```lean
∀ (State : Type) (a b : State → State) (safe : State → Prop)
  (independent : ∀ s, safe s → b (a s) = a (b s))
  (invariant : ∀ s, safe s) (s : State),
  iter depth b (iter depth a s) = iter depth a (iter depth b s)
```

The native proof unfolds `Goal`, introduces the binders, and uses `simp only`
with `depth`, `iter_zero`, `iter_succ`, `independent`, and `invariant`.
The Skip runner executes the corresponding maintained Meta simplifier over
typed inputs. Depth 0, 1 and 2 expose small-path overhead; depth 6 is the current
larger reduced comparison. The source defaults to depth 8, while the runner
creates depth-specific input modules. Do not accidentally report a depth-8
result as the depth-6 baseline.

Native Lean prepares checked imported declarations and typed inputs. The
prepared data must not contain the target proof or its simplified answer.
The Skip process constructs and exports a proof. The native checker is then
called with `--import SimpProblem --type-const Goal --json`; acceptance must
include `typeConstant == "Goal"`, not just acceptance of some exported type.

The benchmark reports distinct phases:

| Phase | Meaning |
| --- | --- |
| Native elaboration | Meta-level native execution of the corresponding simplifier problem. |
| Skip setup | Per-run execution/environment setup, separate from the proof phase. |
| Skip elaboration | The actual maintained simplifier/proof-construction execution. This is the principal comparison below. |
| Skip export | Serialization of the returned proof. |
| Native proof decode/check | Independent parsing of the exported proof representation and original-kernel validation. |
| Imports / process wall time | Additional costs recorded separately. |
| Preparation | One-time import export and executable-specific mapped snapshot construction. |

A proof-phase improvement does not claim the same improvement for the entire
checked process. Fresh processes use existing OS filesystem caches and prepared
immutable imports; they are not a cold-disk experiment. Import improvements alone
do not satisfy the user's intended demonstration.

The ultimate demonstration should scale back toward a theorem with roughly
ten seconds of native elaboration and show meaningful first-run and recheck
improvements. Current reduced-depth work is still establishing raw efficiency.

## 6. Commits and measured releases

| Source checkpoint or experiment | Important change | Saved executable build ID |
| --- | --- | --- |
| `50091b2a9` | Latest pre-profile rewrite batches, including natural division and Expr application boundaries | `d59da747671dad2dd86a7798b50a9891d18f9ca0` |
| `423ebd4be` | Recorded fresh/warm baseline and profile; strengthened checker calls to require imported Goal | Same implementation baseline above |
| Intermediate uncommitted candidate | Array clone/set followed by ordinary `chill()`, which copied twice | `8f605d15c64cdf1d60283fbdfd6eece28d224cf6` |
| `f765003c1` | Private array publication plus native inference-cache operations | `47416933818fbca62445456d526abdbe4b888aed` |
| `fa9550dfc` | Three `@always_inline` annotations and the pause checkpoint | `c1737554b2d8af75cc88e0cea42395228046b0a2` |

Git revision and ELF build ID are different identifiers. Some binaries were built
from a reviewed working tree and then committed. Measurement JSON records the
base revision, source delta and file hashes. In particular the inline JSON names
`f765003c1` plus the three annotations; `fa9550dfc` commits those exact sources.

Each saved binary is at:

```text
build/simp-demo/binaries/BUILD_ID/lean4-simp
```

The latest binary SHA-256 is:

```text
834f61c74637bdd22e9b1c95ad88c3172028245b47f38e6edb2ad7964df964f0
```

`target/host/release/lean4-simp` matched that build ID when this handoff was
prepared. A later build can replace it; use the saved executable for a historical
comparison. An even older saved binary, `3a39683903b646272777bea5968aa63ec685b457`,
exists locally, but it was not rerun contemporaneously in the latest series.

### Fresh-process elaboration medians

All numbers in this table are milliseconds. Each cell is **Skip / native Lean**.

| Stage | Depth 0 | Depth 1 | Depth 2 | Depth 6 |
| --- | ---: | ---: | ---: | ---: |
| Pre-profile implementation | 1.681 / 1.016 | 3.108 / 1.332 | 6.496 / 2.145 | 1047.816 / 196.237 |
| Clone + ordinary chill experiment | 1.581 / 0.989 | — | 6.644 / 2.211 | 980.166 / 200.496 |
| Private publication + inference cache | 1.608 / 1.048 | — | 6.221 / 2.213 | 821.289 / 199.670 |
| Three primitive inlining annotations | 1.636 / 1.034 | — | 6.293 / 2.099 | 638.291 / 192.626 |

The initial series used 15/7/7/5 fresh runs at depths 0/1/2/6. Each subsequent
series used 15/7/7 runs at depths 0/2/6. Every Skip proof in each fresh series
passed the native Goal check: 34 initially and 29 per subsequent series. Native
comparisons also passed.

The final depth-6 Skip median is about 39% below the initial one. The final
annotations reduced that stage's median by about 22% relative to the preceding
stage. These are successive paired-native series, not alternating old/new Skip
runs; native times varied too. Do not claim individual annotation contributions.
The tiny-input medians did not improve in the final annotation experiment.

### Warm, uncached results and memory

Only the pre-profile binary has the recent 50-run warm series. Later-run medians:

| Depth | Skip | Native Lean |
| --- | ---: | ---: |
| 0 | 0.810 ms | 0.242 ms |
| 6 | 1015.144 ms | 172.024 ms |

Each repetition creates fresh proof state and shares immutable imports only.
Skip reported zero query fetches. The final overwritten proof document in each
warm session was kernel-checked; do not describe every warm proof document as
individually checked. Every native repeated run performs its native check.
There is no latest-inline warm series yet.

Latest depth-6 sampled peak Skip RSS is 1,941,880,832 bytes, about 1852 MiB.
The memory sampler polls every 50 ms. Tiny processes can finish between polls;
their recorded zero sampled RSS is not zero actual memory usage.

The latest incremental release check took 91.134 seconds. The inline release
build took 303.16 seconds and peaked at about 34.58 GiB; the preceding hot-batch
build took 173.03 seconds and about 13.80 GiB. Both retained `target/` and passed.
Text size changed only from 7,977,668 to 7,979,644 bytes after annotations.
Broadly used annotations can invalidate many compiler dependencies even when
the source diff is three lines. Do not promise every check will be subsecond.

### Authoritative tracked reports

- [Initial baseline explanation](provenance/performance/2026-11-10-profiled-baseline.md)
- [Initial timings and identities](provenance/performance/2026-11-10-profiled-baseline.json)
- [Array/cache batch audit and intermediate experiment](provenance/rewrite-batches/2026-11-10-hot-arrays-cache.json)
- [Primitive inlining measurements](provenance/performance/2026-11-10-primitive-inlining.json)

These contain individual samples and limitations. They survive a fresh clone;
large executable, snapshot and sampling artifacts under `build/` generally do not.

## 7. What the latest accepted changes actually do

### Array and constructor publication

Changed files are `src/Support/Extensions.sk` and `src/Support/Values.sk`.
The ordinary-array branch of `leanArrayWrite` and the constructor-field update
in `leanReplaceField` previously used `mapWithIndex` to replace one slot. That
allocated zeroed storage and invoked a callback for every element.

The first experiment used `clone()`, `set()`, then `chill()`. It improved the
larger benchmark, but release disassembly showed **two array allocations and
two memcpy operations**: `chill()` copied the private array again.

The accepted implementation clones the immutable backing array, updates only
the clone, and publishes it with `unsafe_chill_trust_me(updated)`. This is safe
at these two sites because the copy is fresh, its only mutable handle is local,
that handle never escapes, and it is not used after publication. The original
array and shared immutable children remain intact. Short comments document that
ownership. Do not mechanically apply this cast to arbitrary mutable state.

Bounds and error-read ordering are unchanged. Tracked/override/persistent
branches are unchanged, including their existing `.chill()` operations.
Release disassembly on the accepted hot-batch binary confirms one memcpy and
no calloc in the ordinary constructor-field replacement path.

[ArrayUpdatesProbe.sk](tests/ArrayUpdatesProbe.sk) executes the real maintained
helpers against local retained mapper implementations. Its 72 cases include
concrete `Array<LeanCtor>` and `Array<LeanText>` inputs, heterogeneous values,
sizes 1/2/128/129, first/last positions, Nat/USize indices, earlier-root and
checkpoint preservation, and further updates of the returned value. Fourteen
separate failure processes check matching old/new diagnostics. It does not
establish every tracked-store array behavior; those branches were not changed.

### Approximate inference-cache operations

The coherent new file is
[InferType/Cache.sk](sources/Modules/Lean/Meta/InferType/Cache.sk).
The three preserved public identities are:

```text
L4_Lean_Meta_InferType.f_inferTypeImp_infer_spec_2_3cc60cfed5
L4_Lean_Meta_InferType.f_infer_spec_2_spec_3_9a6be69b2b
L4_Lean_Meta_InferType.f_infer_spec_1_spec_1_ac68cfa009
```

They are the lookup boundary, lookup walker and insertion helper. Retained
originals are in `InferType/Part000.sk` with `_fallback` suffixes. Helpers in the
new file use native `Int` hashes, bucket indices and depth, ordinary branches
and loops, and one immutable update per changed entry level. The old insertion
wrote a temporary `PUnit` and then the actual replacement into the array.
The unpublished temporary write is omitted on the raw path.

Preserve these unusual but intentional contracts:

- This specialized cache uses **combined-hash equality**, not full key equality.
  `InferType/Fast.sk` subsequently checks configuration and budgeted full Expr
  equality. Replacing the inner cache with an ordinary full-key map changes its
  policy. A hash collision can replace a different stored expression's entry.
- Lookup returns the stored key/value pair. Equal-hash insertion publishes the
  incoming key/value. Preserve exact wrapper and array element representations.
- Hash/depth are USize bit patterns. Shifts are unsigned, increments wrap at
  64 bits, and the depth comparison is unsigned. Collision size/depth thresholds
  must remain unchanged.
- Short insertion returns its input node unchanged. Short lookup reaches the
  port's explicit Array bounds failure; its supplied Lean default is not used by
  the current primitive implementation. Do not conflate the two operations.
- Profiling and noncanonical boxed hash/depth representations use retained
  paths. A dormant unavailable hash/depth must not be decoded earlier simply
  because a new implementation would prefer native integers at entry.
- Other array representations use runtime-aware reads. Prior roots and
  snapshots remain immutable.
- Collision helpers remain shared. Their rebuild helper can re-enter the
  canonical insertion routine, so the fallback is not a fully independent
  recursive oracle. Independent expected collision contents and ordering matter.

[InferenceCacheProbe.sk](tests/InferenceCacheProbe.sk) passes 520 checks over
ordinary/persistent/override arrays, actual hash collisions, bucket prefixes,
depth thresholds and wrapping, scalar compatibility, unused unavailable inputs,
state preservation and profiling. Two failure processes validate short lookup.
The tests include independent ordered collision results and a wrapped-depth
case that would fail if addition saturated instead of wrapping.

Review caught and corrected eager word decoding, reordered key projection,
the wrong short-lookup result, changed nested array specialization and dropped
erased-field reads. Keep these lessons in mind when extending the family.

### Primitive inlining

The only source changes in `fa9550dfc` are annotations on:

| Function | File |
| --- | --- |
| `leanField` | `src/Support/Values.sk` |
| `leanNat` | `src/Support/Nat.sk` |
| `leanExprDataValue` | `src/Support/ExprData.sk` |

`@always_inline` requests inlining at legal call sites. Existing examples are
in the prelude and compiler; its implementation can be read without changing
it. It cannot be combined with `@no_inline` or `@gc`, and requires a body.

The aggregate experiment passed release checking/building and the 29 whole-proof
checks. No new helper algorithm was introduced. We have not measured separate
contributions, a warmed final series or a post-inline CPU capture. `leanField`
and `leanNat` still have standalone symbols in the binary; that alone does not
show how many calls remain. A direct-call audit is still pending.

Avoid indiscriminate annotation of large primitive dispatchers. For example,
`leanWordBitsOther` includes parsing/enum/error logic and `leanArrayRead` includes
several representations and bounds paths. A small common path with an outlined
cold helper can be a better experiment. Check build memory as well as speed.

## 8. Profiling findings and their limits

The main diagnostic tool is the existing SIGPROF sampler in
`tools/sample_cpu.c`, summarized by `tools/profile_cpu.py`. Do not treat sampled
run durations as uninstrumented benchmark timings.

There are two relevant recent captures:

| Capture | Binary | Elaborations | Retained elaboration samples | Total captured samples |
| --- | --- | ---: | ---: | ---: |
| `build/profiling/2026-11-10-refresh/depth6-sampled/` | `d59da747…` | 20 | 11,026 | 11,786 |
| `build/profiling/2026-11-10-refresh/cache-sampled/` | `47416933…` | 20 | 8,803 | 9,530 |

Both use the same depth-6 input and have fresh proof state, shared immutable
imports and zero query fetches. Only the final overwritten proof document in
each diagnostic session was separately Goal-checked. The second capture is
**before** the three inlining annotations. There is no `c1737554…` CPU capture.

The depth-6 input SHA-256 is:

```text
fc101f7bcb851dca7754f0474f486fd200db3855a65053cbb7f0cf645d0751f2
```

### Resolved costs

Initially 4,017 libc samples were unresolved. Matching debug symbols identified
3,803 as `__memset_zva64`, 189 as `__memcpy_generic`, and 25 as allocator/free
internals. For 3,796 zeroing samples, the saved link register points to a direct
call to `SKIP_Obstack_calloc`, which tail-calls memset with a zero byte.
This establishes allocation zeroing, not merely an assumed association.

| Flat operation | Initial samples | Post-array/cache samples |
| --- | ---: | ---: |
| memset / zeroing | 3803 (34.49%) | 2497 (28.37%) |
| memcpy | 189 (1.71%) | 262 (2.98%) |
| Array fill callback | 429 (3.89%) | 391 (4.44%) |
| `leanArrayWrite` itself | 166 | 44 |
| `leanReplaceField` itself | 115 | 70 |
| `leanArray` itself | 268 | 167 |
| Enclosing assignment checker itself | 141 | 139 |

The increased percentage for Array fill does not mean its absolute sampled cost
increased: its count fell while the total fell faster. Counts are CPU samples,
not call counts or allocated bytes. Do not add overlapping inclusive percentages.

The removed ordinary-array/constructor calloc sites had 155 and 107 initial
zeroing samples. The new capture instead sees memcpy at these update paths,
consistent with their intended implementation. The inference-cache family also
shows reduced sampled cost, including after accounting for renamed helpers.

### Frame allocations and other targets

Initial disassembly confirmed four particular temporary-frame allocations:

| Routine | Frame slots | Initial zeroing samples at confirmed frame site | Initial fill samples |
| --- | ---: | ---: | ---: |
| `isDefEqQuickOther` | 199 | 101 | 28 |
| `evalNat.visit` | 392 | 100 | 26 |
| Argument equality first pass | 208 | 98 | 31 |
| Inference-cache insertion | 53 | 57 | 21 |

The insertion frame is now removed on its raw fast path. `QuickOther` remains
a justified next target: the post-cache profile has 80 directly attributed
zeroing samples, 29 fill samples and 57 self samples. Its draft is not yet
accepted. The other two larger frame rewrites are not currently drafted here.

Not every allocation inside a frame-bearing function is the frame. Map storage,
array updates and constructor fields also allocate. The earlier proposed
`Simp.reduce` packet had only seven inclusive samples in the initial capture and
was deferred; do not resume it ahead of the actual hot work just because a packet
already exists.

The assignment-checker cost is largely the already-native traversal in
`src/Runtime/CheckAssignment.sk`, including a visited Map and pending Vector.
Rewriting its outer frame alone would miss most of that cost. Map-growth caller
attribution was too sparse to justify a broad map redesign or capacity tuning.
`Map.maybeSet` also rehashes before detecting duplicates, so substituting it for
lookup-then-set is not automatically faster.

### The concrete `leanArray` allocation discovery

`src/Support/Primitives.sk` returns ordinary array storage directly and uses
`Array::fillBy(values.size(), i -> values[i])` for a persistent vector.
Pre-inline release assembly shows a **16-byte captured-local cell allocated
before the variant test on every call**. The persistent branch later stores its
vector in that cell and creates a separate closure that references the cell.
The ordinary branch needs neither allocation.

In the post-cache capture, 120 of the 167 flat `leanArray` samples land on the
cell's initialization stores; another 81 allocator samples return to its
unconditional allocation. There are no sampled PCs in its persistent conversion
arm. This supports removing unnecessary capture setup from the ordinary path.
It does not establish that persistent flattening is the hot operation or that
the persistent branch never executes.

The proposed bounded change is to move the persistent conversion into a separate
`@no_inline` helper, keeping the existing representation and errors. **No such
change has been implemented.** Exact dataflow, assembly and limitations are in
the archived [leanArray report](provenance/pending-rewrites/2026-11-10-paused/lean-array/REPORT.md).
Verify the latest inlined executable before using the older addresses.

### Symbolization and stack caveats

Matching libc debug information was downloaded and extracted privately; no
package was installed or upgraded. Its ELF Build ID is
`27027b96e5b8c475fc327aa445bea1c71d37b4e2`. Both Build ID and GNU debuglink CRC
were checked during initial resolution. The reusable profiler now accepts
`--debug-symbols ELF=DEBUG`, verifies matching Build IDs, and uses the original
ELF's load segments. It also accepts `--output` to preserve earlier reports.

About 86% of sampled stacks contain only PC and LR. Tail calls, absent frame
pointers and stale LR values hide deeper callers. In `leanArray`, most captured
LRs are returns from its own allocator call, **not recursive leanArray calls**.
An inclusive count means presence in the captured stack, not a complete call-tree
cost. The frame cap was not the cause of the short initial stacks.

## 9. Commands for the next agent, after resumption

The commands in this section are instructions for future authorized work, not
requests to run them while paused. Run from the package root. The root agent
owns one compiler queue; do not overlap builds/probes with performance runs.

### Environment and incremental checking

```bash
cd /home/julienv/skip/lean4
export SKC=/home/julienv/skip/skiplang/compiler/stage1/bin/skc
source /home/julienv/lean4/build/release/env.sh
skargo check --release
```

`skargo check --release` checks the release configuration without producing
object files. A full benchmark build is:

```bash
mkdir -p build/handoff-resume
python3 tools/measure.py \
  --report build/handoff-resume/build-memory.json --max-gib 44 \
  skargo build --release --bin lean4-simp \
  > build/handoff-resume/build.log 2>&1
```

The memory guard reports process-group RSS and terminates its own build group
if the limit is exceeded. Read its JSON and the build log before deciding why
something failed. Memory exhaustion and a full persistent compiler cache are
different failures. Do not delete `target/` or archive caches routinely.
If edits outside `src/` incorrectly look fresh, inspect `sources/build.txt` and
the input tracking in `build.sk` before trusting the result.

Format small batches with `skfmt -i FILE...` (up to about eight at once).
Formatting establishes parsing, not type correctness.

### Existing focused checks

```bash
python3 tools/probe.py --name array-updates --release \
  --driver tests/ArrayUpdatesProbe.sk

python3 tools/probe.py --name inference-cache --release \
  --driver tests/InferenceCacheProbe.sk
```

These passed 72 and 520 cases on the accepted hot batch. They select 154 and
176 maintained functions respectively. A richer Meta fixture can use
`--rewrite-harness`, which includes initialized bootstrap support and
`tests/Support/RewriteProbe.sk`.

Probe output is under `build/probes/NAME/`: `probe`, `Driver.sk`, `Selected.sk`,
`sources.json` and `compile.log`. Inspect the compile log rather than dumping a
large Python exception containing the complete compiler command. The selector
copies maintained function bodies; it is not the retired transpiler. A focused
probe does not replace whole-package release validation or real proof checks.

Important limitation: the current maintained-function catalog starts at `fun`
and does not retain preceding annotations. If annotating a maintained `f_`
function, fix or explicitly account for that selection behavior before claiming
the probe exercises the annotated code. Support files are included verbatim;
the three accepted annotations are in Support files.

The array probe's expected-failure interface is:

```text
build/probes/array-updates/probe old MODE
build/probes/array-updates/probe new MODE
```

Modes are `field-negative`, `field-large`, `field-unavailable`,
`array-unavailable`, `array-empty`, `array-word`, and `array-huge`. Both sides must
exit 86 with the same diagnostic. Results from the accepted batch are in
`build/profiling/2026-11-10-refresh/array-failures.json` and the tracked batch audit.

The inference probe uses `LEAN_SKIP_TEST_INFER_CACHE_FAILURE=old-short` or
`new-short`. Both must exit 86 and contain:

```text
Lean Array index out of bounds (panic recovery is not implemented)
```

The broader `python3 tests/runtime.py` suite supplies independent arithmetic,
state, closure and array checks. Its latest run passed 8,967 vectors/checks and
19 explicit failure boundaries on the earlier clone-plus-chill candidate.
The final private-freeze change has its own focused and whole-proof checks;
do not claim that broad suite was rerun after every later change.
`tests/run.py` belongs to the historical transpiler workflow; it is not the
default validation entry point for these maintained edits.

### Whole-proof comparison

The simple script requested by the user already exists:

```bash
./run-raw.sh --depth 6 --runs 7
```

It performs an incremental check and release build before preparing inputs and
comparing proof execution. If the correct binary is already built, use:

```bash
./run-raw.sh --skip-build --depth 0 --runs 15
./run-raw.sh --skip-build --depth 2 --runs 7
./run-raw.sh --skip-build --depth 6 --runs 7
```

To reproduce the saved latest executable instead of whatever is in `target/`:

```bash
./run-raw.sh --skip-build \
  --binary build/simp-demo/binaries/c1737554b2d8af75cc88e0cea42395228046b0a2/lean4-simp \
  --depth 6 --runs 7
```

The runner sources the pinned Lean build environment when available and verifies
the native Lean revision. It saves a build-ID-specific binary before executing
it. Existing result directories are reused, so rerunning the same binary/mode
can overwrite historical raw logs and `results.json`. Preserve a report before
rerunning if its exact hash is part of prior evidence.

For clean timing, remove inherited `LD_PRELOAD` and diagnostic `LEAN_SKIP_*`
variables, then explicitly use `LEAN_SKIP_PROFILE=0`, `LEAN_SKIP_PHASES=0`,
`LEAN_SKIP_REGIONS=sampled`. The private measurement scripts under
`build/profiling/2026-11-10-refresh/` did this with a filtered environment.
Do not compare `REGIONS=0`, `sampled`, and `all` as if they were the same run.

### Snapshots, inputs and result paths

Executable-specific mapped inputs are based on the depth-1 import snapshot:

```text
build/simp-demo/depth-1-6efef58352b7e377/inputs-BUILD_ID.skstore
build/simp-demo/depth-1-6efef58352b7e377/inputs-BUILD_ID.skstore.json
```

The workload-specific inputs are `data/inputs.jsonl` inside these case directories:

| Depth | Directory under `build/simp-demo/` |
| --- | --- |
| 0 | `depth-0-a351ee8fcef70936` |
| 1 | `depth-1-6efef58352b7e377` |
| 2 | `depth-2-ce51c6bc5fc05cfd` |
| 6 | `depth-6-e6fb9810325c68a7` |

The result path is `CASE/release/BUILD_ID/raw-regions-sampled/results.json`.
The snapshots are tied to executable layout and cannot be reused with a different
binary. Their JSON header encodes the build ID as **decimal bytes separated by
dots**, not a hex string. Validate it with:

```python
bytes(map(int, header['executableBuildId'].split('.'))).hex() == build_id
```

If these ignored artifacts are absent on another machine, rebuild and let
`run-raw.sh` prepare new compatible artifacts. Do not attempt to recover a
historical binary merely by assigning its old build ID to a new one.

### Repeated raw runs and sampling

Native `tools/SimpReference.lean` accepts `--repeat COUNT`. Skip accepts
`--raw-session SNAPSHOT MANIFEST`, with a JSON array of steps containing `label`,
`inputs` and `proof` paths. Each raw step gets fresh proof state. A manifest that
reuses one proof path overwrites it; kernel-check scope must be stated accordingly.

The existing local recipes are `warm.py`, `capture-depth6.py`, `capture-stage.py`
and `measure-stage.py` under `build/profiling/2026-11-10-refresh/`. They are
checkpoint-specific orchestration, not portable public CLIs. `capture-stage.py`
expects a corresponding stage-summary JSON. Read them before reuse, especially
hardcoded case directories and paths. Their absence does not prevent using the
tracked runner, sampler and profiler.

Build the diagnostic preload library with `clang` (plain `cc` was unavailable):

```bash
mkdir -p build/handoff-resume
clang -O2 -shared -fPIC -pthread tools/sample_cpu.c \
  -o build/handoff-resume/sample_cpu.so
```

After the normal runner has validated the binary/snapshot pair, the direct
sampling invocation has this shape:

```bash
SKARGO_BIN=lean4-simp \
LEAN_SKIP_PROFILE=0 LEAN_SKIP_PHASES=0 LEAN_SKIP_SIMP_CACHE=0 \
LEAN_SKIP_REGIONS=sampled \
LD_PRELOAD="$PWD/build/handoff-resume/sample_cpu.so" \
LEAN_SKIP_SAMPLE="$PWD/build/handoff-resume/samples.bin" \
LEAN_SKIP_SAMPLE_STACKS=1 LEAN_SKIP_SAMPLE_TIMESTAMPS=1 \
"$benchmark_binary" --data "$benchmark_snapshot" \
  --mapped-raw-session "$benchmark_manifest" "" \
  > build/handoff-resume/skip.log 2>&1
```

Set the three `benchmark_*` variables to actual validated absolute paths first.
Do not preload the Python wrapper or native Lean checker. Their child processes
can overwrite sampler outputs/maps. Do not sample through the normal
`--raw-session` launcher: its self-exec can truncate the sampler files again.
The mapped invocation is a diagnostic route after validation, not a way to
bypass snapshot compatibility.

Symbolize and restrict the capture to elaboration intervals:

```bash
python3 tools/profile_cpu.py "$benchmark_binary" \
  build/handoff-resume/samples.bin \
  --elaboration-log build/handoff-resume/skip.log \
  --output build/handoff-resume/elaboration.json
```

For the exact current host libc, the private debug ELF is at:

```text
build/agents/rewrite_semantics_lead/libc-resolution/extracted/usr/lib/debug/.build-id/27/027b96e5b8c475fc327aa445bea1c71d37b4e2.debug
```

Pass it as `--debug-symbols /usr/lib/aarch64-linux-gnu/libc.so.6=DEBUG_FILE`
when the identities still match. Do not install/upgrade libc just to symbolize
an old capture. On another machine obtain matching symbols for its actual
mapped library; the old addresses and debug file will not apply.

An independent proof check can be run with the matching case directory on
`LEAN_PATH`:

```bash
LEAN_PATH="$benchmark_case" lean -j1 -s65536 -M8000 \
  --run tools/CheckProof.lean "$benchmark_proof" \
  --import SimpProblem --type-const Goal --json
```

Inspect `accepted` and `typeConstant`. The fresh runner already does this for
every proof. Its edit-session branch was also strengthened to require Goal, but
that branch has not been rerun specifically since the Python change.

## 10. Pending work and a suggested order on resumption

These are next-step proposals within the previously authorized optimization
task, not instructions to run them while paused. No pending draft is accepted
merely because it is archived with this handoff.

### A. Verify the current baseline without restarting the investigation

Inspect `git status`, current source and the saved `c1737554…` executable.
Verify its build ID and matching snapshot. Read the tracked inline measurement
record before deciding whether another baseline run is necessary. A bounded
alternating old/new comparison could improve confidence in the attribution,
but a new full matrix is not mandatory just because a new agent took over.

The useful unanswered measurement questions are post-inline call-site changes,
post-inline CPU distribution and warmed final behavior. Choose the one needed
for the next decision. Do not spend days building a perfect profile before
making a small, evidenced source improvement.

### B. Remove the ordinary-path capture setup in `leanArray`

This is the smallest concrete outstanding source experiment. Read the archived
report and inspect the latest release's `leanArray` assembly. If it still has
the unconditional captured-local cell, outline the persistent materialization
branch into a separate non-inlined helper. Keep the same persistent conversion,
variant behavior, unsupported tracked-materialization failure and return type.

Then type-check; execute the existing array/runtime checks appropriate to the
change; inspect release assembly for loss of the ordinary-path allocation; and
run the actual proof comparison. Zero sampled persistent-arm activity is not
permission to delete the branch or omit its tests. This proposed source change
does not require modifying Skip's compiler or runtime.

### C. Finish the `isDefEqQuickOther` review and validate the draft

The original private directory is:

```text
build/agents/rewrite_execution_lead/defeq-quick-other/
```

Portable copies now live at
[provenance/pending-rewrites/2026-11-10-paused/quick-other/](provenance/pending-rewrites/2026-11-10-paused/quick-other/REVIEW.md).
They are excluded from `sources/build.txt` and normal tests. They have not been
compiled, executed, integrated or accepted.

| Item | Exact identity |
| --- | --- |
| Canonical function | `L4_Lean_Meta_ExprDefEq.f_Lean_Meta_isDefEqQuickOther_f3a8ea9bdf` |
| Current original source | `sources/Modules/Lean/Meta/ExprDefEq/Runtime003.sk` |
| Original catalog body SHA-256 | `0e859b377054d50bafaa1f89e74d74583a8f8131ecfd37f6491d63cc8c8e7b02` |
| Replacement SHA-256 | `202778b4877919f842b111bb83ee6f3e05f56b2858c8e458a125343916d81972` |
| Probe SHA-256 | `191812d2ebfa137094e4980544d529ddf072ef2903b5cbfb20f1d0363fae28a1` |
| Proposed focused cases | 248; not yet run |
| Native reference | `/home/julienv/lean4/src/Lean/Meta/ExprDefEq.lean`, approximately lines 2036–2165; a frozen excerpt is in the packet |

Read the [contract](provenance/pending-rewrites/2026-11-10-paused/quick-other/CONTRACT.md),
[writer review](provenance/pending-rewrites/2026-11-10-paused/quick-other/REVIEW.md)
and [independent review checkpoint](provenance/pending-rewrites/2026-11-10-paused/quick-other/independent-review/CHECKPOINT.md)
before editing. The independent reviewer found no concrete defect at pause but
had not finished the review. That is not approval.

The exact ABI is:

```text
runtime, left Expr, right Expr,
Meta.Context, Meta.State reference,
Core.Context, Core.State reference, world
    -> EST.Out LBool
```

All arguments except `runtime` have the same broad `LeanValue` type. Swapping a
context and reference can type-check. The result contains `LBool`, not `Bool`.

The rewrite removes the 199-slot frame and makes this ordered decision tree
explicit: pattern annotations; expression/eta equality; application heads;
assigned metavariables and instantiation; delayed assignments; same-head argument
handling; assignability; one-sided or two-sided assignment; proof irrelevance,
stuck results and trace publication. A private closure at the assignment join
is simplified to `!rightAssignable`, based on its other captured Boolean being
false at every incoming edge. That proof obligation is part of review.

Trace checks must stay at their original tail positions. Do not run the whole
function again as a fallback after stateful operations. The draft uses the
existing trace-publication helper, including its unsupported `Float.ofBits`
boundary. It assumes complete valid Meta/Core records for those branches;
malformed short records are not claimed to preserve every unused projection
diagnostic. Early context-free exits are tested with unavailable contexts.

The independent review still needs to finish:

1. Original `pc = 2` tail, strict Bool closure simplification, stuck/error result
   wrappers and trace publication ordering against actual helper bodies.
2. Expected probe answers and assignment direction against `isDefEqQuick`,
   same-head comparison, proof irrelevance and the two-mvar helper. Particular
   concerns are both-assigned distinct-fvar `undef`, beta/unequal same-head
   arguments, opaque proof/data cases and missing-mvar errors.
3. Enabled trace and delayed-assignment fixture setup and exact helper ABIs.
4. Frozen packet hashes and the current original body. Do not assume the source
   remained unchanged because these hashes were once correct.

The draft probe proposes 31 named cases over two profiles, two trace
configurations and two opaque world values: 248 comparisons. It asserts exact
old/new results and full refs, preserved inputs, named LBool/error results,
per-metavariable assignments, unchanged Core state and counters excluding elapsed
times. Mutual recursion and shared helpers limit the independence of the old
route, so named expectations and whole-proof checks are necessary.

Optional probe modes through `LEAN_SKIP_TEST_QUICK_OTHER_FAILURE` are:

| Modes | Anticipated retained failure; still unexecuted |
| --- | --- |
| `old-delayed`, `new-delayed` | `not implemented: delayed metavariable assignment [lean_instantiate_expr_mvars]` |
| `old-trace`, `new-trace` | Existing `Float.ofBits [lean_float_of_bits]` unsupported primitive |

Do not report these exact failures as confirmed until running the retained and
replacement modes. Enabled trace success and successful delayed expansion are
not implemented by this draft.

After review, the guarded integration command can use the archived packet:

```bash
mkdir -p build/handoff-resume
python3 tools/rewrite_integrate.py \
  --manifest provenance/pending-rewrites/2026-11-10-paused/quick-other/packet/input-manifest.json \
  --replacement provenance/pending-rewrites/2026-11-10-paused/quick-other/Replacement.sk \
  --destination sources/Modules/Lean/Meta/ExprDefEq/QuickOther.sk \
  --audit build/handoff-resume/quick-other-integration.json
```

That command is a dry run unless `--apply` is added. Integration checks identity,
hashes and ABI, retains originals, and updates manifests; it does not establish
semantic correctness. A draft change after review requires renewed review of
the actual changed portion. Keep audits in `build/`, then record accepted source
hashes and evidence in tracked provenance.

The proposed execution probe requires the integrated canonical/fallback pair:

```bash
python3 tools/probe.py --name quick-other --release --rewrite-harness \
  --driver provenance/pending-rewrites/2026-11-10-paused/quick-other/Probe.sk
```

This is a suggested future command, not one already executed. A compile error or
incorrect fixture expectation is still possible. Do not weaken expected results
merely to make a draft pass. Validate initialization and helper contracts first.

### D. Consider later bounded candidates from a refreshed profile

`Meta.Config.toKey` is already a named rewrite at approximately line 13057 of
`sources/Modules/Lean/Meta/Basic/Part002.sk`; its fallback follows. Do not assign
an agent to remove a frame that is no longer there. It accumulates an `Int` key
but still routes Boolean fields through generic word conversion and boxes enum
converter results. In the post-cache capture, all 53 `leanWordBitsOther` samples
have `Config.toKey` as caller; the config routine itself has 26 self samples.

Its native layout is in `Lean/Meta/Basic.lean`, approximately lines 218–238:

| Config field | Key bits |
| --- | --- |
| transparency, field 9 | 0–2 |
| Boolean fields 0–8 | 3–11, in order |
| iota 12 / beta 13 | 12 / 13 |
| zeta 15 / zetaDelta 16 / univApprox 11 | 14 / 15 / 16 |
| etaStruct 10 | 17–18 |
| proj 14 | 19–20 |
| zetaHave 18 / zetaUnused 17 / canUnfoldPredicateConfig 19 | 21 / 22 / 23 |

A canonical-input fast pack could avoid generic conversions, but must preserve
the existing field-read order, noncanonical word/scalar/natural acceptance,
full-width behavior, malformed-root diagnostic and profiling route. Unexpected
field values could use the retained path. There is no accepted patch or probe
for this proposal. Its measured share is smaller than the confirmed allocation
targets; prioritize using the current profile rather than this table alone.

Larger candidates include argument equality's first pass and `evalNat.visit`,
whose confirmed frames are listed above. Do not expand to entire modules without
new evidence. General typed Expr/constructor representations may eventually
matter, but a previous inline `LeanCtor2`/`LeanCtor3` experiment reduced allocation
while slightly slowing execution and increasing build memory; it was reverted.
That is evidence to measure such designs, not a prohibition or proof of a
compiler limitation.

### E. Return to incrementalization after raw efficiency is adequate

Near parity is still unfinished. When it is reached, revisit the actual
`SimpQueries.sk` boundaries with a fresh-state baseline and edited-input matrix.
Measure first-run cost, rechecks, invalidation correctness, observable effects,
proof construction and independent Goal checking. Preserve the requirement that
SKStore initialization should ideally stay within twice the raw cost.
Do not claim a speedup from whole-theorem result reuse when the intended
demonstration is reuse of intermediate elaboration work.

## 11. Semantic and testing pitfalls already encountered

These are practical failure modes from this codebase, not hypothetical style
preferences.

| Pitfall | What to preserve or check |
| --- | --- |
| Broad boxed ABI | Meta context, Meta state ref, Core context, Core state ref and world all use `LeanValue`. Verify argument roles and effect order manually. |
| Result wrappers | `EST.Out Unit`, `EST.Out Bool`, `EST.Out LBool`, Option and arbitrary result constructors are different. An axiom-recording success is not an unfolding result. |
| Numeric widths | Lean Nat is arbitrary precision. Use `LeanNat` and a large-value path; USize/UInt use all 64 bits with wrapping/unsigned behavior where appropriate. |
| Dormant values | An unavailable value may be carried through an unused field. Moving decoding ahead of an early return changes unsupported behavior. |
| Constructor identities | `LeanTag.Value` identities are globally distinct; Lean constructor ordinals are not. Do not substitute ordinals for named tags. |
| Equality polarity | `native_eq(a, b) == 0` means equal. `leanSameObject(a, b) != 0` means physically identical. The latter returns UInt32, not Bool. |
| Physical identity | Identity proves equality only. Different addresses do not prove unequal expressions. Preserve the correct binder-name/annotation equality mode. |
| Array specialization | `Array[LeanCtor(...)]` can specialize differently from `Array<LeanValue>`. Equal contents do not guarantee exact `native_eq` across those representations. |
| Alias tests | `original = input` followed by comparison against `original` does not detect mutation of the shared input. Copy the relevant observation or test independent snapshots and held values. |
| Publication | Mutable arrays/vectors must be copied/frozen before becoming immutable values or cache results. The special private freeze is justified only at proven ownership boundaries. |
| Snapshots | Cache/state insertion must use the latest state after nested computation; old checkpoints must remain isolated. Do not publish failed or partly computed state. |
| Collision policies | Some inner caches deliberately use approximate hashes and rely on a later full check. Preserve the actual policy, not the map behavior you would prefer. |
| Profile diagnostics | `restoreRaw()` restores counters. Compare deltas from the saved baseline; elapsed times are not expected to match. Preserve diagnostic routes when promised. |
| Natural metadata | Valid bound-variable indices have a packed metadata limit of 1,048,575; arbitrary Nat counters do not authorize invalid Expr metadata. |
| Expression metadata | `Level.zero` metadata is 2221. Preserve width, bit layout, saturating fields and wrapping hashes. |
| Reducibility fixtures | Definition hints and reducibility-extension registration are separate. An abbreviation fixture under reducible transparency must register the extension. |
| Heartbeats | Supported fixtures deliberately select unbounded mode. Bounded heartbeat behavior is still an explicit unsupported path. |
| Tracing | Enabled trace can reach `Float.ofBits`, still unsupported. A missing enabled-trace success test is not trace support. |
| Differential independence | Retained wrappers can share helpers or recurse through the new canonical routine. Document that and add independent expected effects/results. |
| Fixture validity | Use real initialized extensions, valid declarations/types/universes and reference handles. Fix bad fixtures rather than hiding their failures. |
| Compiler validation | `skfmt` only parses; a draft, an agent's completion message or a zero CLI exit does not establish correctness. |

Other useful local conventions: natural arithmetic uses methods such as `.add`;
immutable arrays use `.append` rather than `.push`; mutable vectors use `.push`.
Skip has no `let` in this style of code, uses `!` for mutation, treats unused
locals as errors, and can reject unnecessary tail `return` forms. `children` is
reserved. Avoid carrying translation-shaped frame-slot names into final code.

Before accepting a rewrite, review it on its own for readability as well as
against the original. Keep comments focused on algorithmic or ownership
invariants. Test code also needs review: an earlier array draft tested a private
reimplementation instead of production, used alias-to-self preservation checks,
and mislabeled widened arrays as concrete inputs. That draft was replaced;
only `tests/ArrayUpdatesProbe.sk` is the accepted driver.

## 12. Tooling, inventory and peer work

The useful maintained tools are:

| Tool | What it does and does not establish |
| --- | --- |
| `tools/rewrite_task.py` | Creates bounded packets from current source, hashes original/helper inputs and includes contracts/fixtures. It does not infer semantic argument roles. |
| `tools/rewrite_integrate.py` | Guards original identity/ABI/hash, retains fallback bodies and updates source selection/provenance. It is not a semantic reviewer. |
| `tools/probe.py` | Selects reachable maintained bodies for focused execution. Full release validation remains separate. |
| `tools/select_sources.py` | Catalogs/promotes existing maintained declarations. It is source selection, not Lean IR translation. |
| `tools/rewrite_coverage.py` and `tools/run_rewrite_coverage.py` | Diagnostic execution coverage for the fixed workload. Entry observation is not branch coverage. |
| `tools/measure.py` | Serial build memory measurement and process-group guard. |
| `tools/sample_cpu.c` / `tools/profile_cpu.py` | Diagnostic CPU sampling, elaboration filtering and exact-object symbolization. |
| `tools/simp_demo.py` / `run-raw.sh` | User-facing preparation, execution, Goal checking and performance comparison. |

Integration of recursive closure adapters requires an explicitly reviewed
`--closure-adapter-sha256` when applicable. Preserve fallback self-recursion and
the retained adapter's route. A canonical wrapper that silently calls only the
new helper is not an independent oracle for that helper.

The inventory tracks 1,225 observed functions from a fixed 36-case execution
matrix; the full inventory contains one additional non-observed entry. There
were 197 initial frame candidates. Current accepted counts are **44 frame
rewrites and seven non-frame entries**, with **153 observed frames remaining**
covering 74,262 source lines. The manifest also distinguishes already idiomatic
and compatibility entries from pending review. Counts are not percentages of
the whole Lean codebase and do not establish branch coverage or a performance
completion estimate.

The prior workflow used one primary and three Codex peers, with the primary
owning production integration and the only compiler queue. Private workers used
disjoint directories and supplied source, probes and review reports. On
resumption, delegate only when authorized and within the then-current available
slots; do not infer subscription limits from this session's four-slot allocation.

Peer roles at the pause were:

| Peer | Last work | State |
| --- | --- | --- |
| `rewrite_execution_lead` | Inference cache accepted; QuickOther source/probe drafted | Completed, private QuickOther draft frozen |
| `rewrite_semantics_lead` | Exact libc resolution, array/cache review, leanArray analysis, partial QuickOther review | Paused/completed; review checkpoint saved |
| `unfold_definition` | Array probe review, inlining candidate analysis, Config.toKey inspection | Completed |

Agent identities are workflow history, not a guarantee they can be resumed in a
new session. The files and hashes are the handoff. No agent should be woken just
to continue optimization while the user pause remains in effect.

Vibe produced drafts but did not establish a net time saving. Earlier separate
client pools encountered rate/availability/configuration failures. A later
single-client experiment with ten built-in children completed in 217.52 seconds
without observed provider errors, but source corrections and replacement of
most tests consumed substantial Codex review time. Five corrected routines
eventually passed validation. Do not equate draft generation time with accepted
throughput. Vibe is idle; no further launch is scheduled by this handoff.

## 13. Durable archive versus machine-local evidence

To prevent the next agent losing useful work in an ignored directory, this
documentation task preserved about 197 KB of source/review/evidence files under:

```text
provenance/pending-rewrites/2026-11-10-paused/
```

[ARCHIVE.json](provenance/pending-rewrites/2026-11-10-paused/ARCHIVE.json)
records original paths, copied paths, byte counts and SHA-256 hashes.
The archive contains:

- The unaccepted QuickOther replacement, probe, contract and writer report.
- Its frozen source/reference/helper/test packet and incomplete independent
  review checkpoint.
- Exact leanArray attribution and assembly excerpts.
- Initial caller, libc/allocation-site and map-attribution analysis.

No archived Skip file was added to the active source manifest. The archive is
evidence and a review starting point, not production code or an accepted test.
No provider settings, executable, compiler cache, raw sample binary, debug-symbol
binary or mapped input snapshot was copied into it.

The original QuickOther input manifest is retained as
`packet/original-input-manifest.json`. The usable archived
`packet/input-manifest.json` omits only `.vibe/config.toml` from its input list
and records why. All included input files keep their exact original bytes and
hashes. This makes the packet usable without copying provider configuration.

Useful machine-local directories still present at handoff:

| Directory | Contents |
| --- | --- |
| `build/profiling/2026-11-10-refresh/` | Build logs/memory, all four measurement stages, warm series, captures, disassembly and private orchestration scripts |
| `build/simp-demo/binaries/` | Saved executable versions |
| `build/simp-demo/depth-*/` | Checked input modules, typed JSON, mapped snapshots, proof outputs, native/Skip/checker logs and results |
| `build/probes/array-updates/` | Accepted array probe binary and selected source record |
| `build/probes/inference-cache/` | Accepted cache probe binary and selected source record |
| `build/agents/rewrite_semantics_lead/libc-resolution/` | Private exact debug package/ELF, resolver and raw symbol evidence |
| `build/agents/rewrite_execution_lead/infer-cache/` | Frozen accepted cache packets, draft revisions, integration audits and reviews |
| `build/agents/rewrite_execution_lead/defeq-quick-other/` | Original unaccepted next draft |
| `build/agents/rewrite_semantics_lead/quick-other-review/` | Original incomplete independent review |
| `build/agents/rewrite_semantics_lead/lean-array-attribution/` | Original precise allocation finding |

Do not delete these to make `git status` look small. Conversely, do not commit
the whole `build/` directory. Tracked audits and this selective archive preserve
the important portable record; large execution artifacts can be regenerated
with the pinned tools if necessary.

The earlier `limit < 10` implementation and its approximately 558-times unrelated
edit speedup are recorded in `INCREMENTAL.md` and historical README sections.
That result concerns another workload and an older configuration. It is not
the current conditional-simplifier speedup. Broader Mathlib and GCD plans are
deferred. An old goal-tracker entry may still name the limit example; use the
latest user direction and this handoff to identify the actual active objective.

## 14. A concrete resumption checklist

After the user resumes implementation:

1. Inspect status and read the current pause/handoff notices. Preserve unrelated
   work and identify any newer user constraints. Mark the plan resumed without
   erasing historical measurement evidence.
2. Verify the repository compiler, pinned native Lean and selected executable.
   Retain `target/`. Use the saved latest binary if current source has already
   diverged from the measured checkpoint.
3. Pick one coherent measured change. The leanArray capture-cell removal is
   small and directly evidenced; QuickOther needs its remaining review first.
4. Preserve compatibility and explicit failures, type-check incrementally, then
   run focused semantic checks with independent expectations where helpers are
   shared. Do not claim proposed counts as executed results.
5. Build release once the batch is reviewable. Run paired whole-proof checks
   without concurrent compilation. Record source hashes, build ID, snapshot,
   input, profiling flags, timing phases and proof-check scope.
6. Keep measured improvements and investigate meaningful regressions. Readable
   changes can be valuable without a speedup, but do not claim they prove parity.
7. Commit a coherent checkpoint, update the active plan and skill if a reusable
   lesson was learned, then continue the authorized objective. Do not reactivate
   a broad cold-path rewrite merely to increase completion counts.
8. Once raw execution is close enough, move to SKStore and validate edits and
   first-run overhead. If progress truly requires Skip compiler/runtime changes,
   stop that dependent work and explain the specific blocker to the user.

Communicate the latest result and limitation plainly. At this handoff the
accurate statement is: the raw port constructs real proofs checked by native
Lean; targeted source changes reduced the measured depth-6 elaboration median
from roughly 1.05 seconds to 0.64 seconds; native Lean remains around 0.19 seconds;
raw parity, larger-example demonstration and the subsequent incremental work
are still unfinished.
