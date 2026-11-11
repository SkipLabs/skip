# Allocation: bounded static approval

Reviewer foundations/fd9159c3; baseline HEAD `41bb486d9`.

## Decision

**APPROVED for parent integration and serialized validation of the three support replacements at the hashes below.** No semantic blocker found in the four changes. Static review only: this reviewer ran no compiler, tests, probes or benchmarks and edited no production/config files. This is not a claim of execution success.

Parent reports initial allocation compilation caught a None<_> invariant/type issue and an unused probe parameter; author is correcting those. The explicit `?LeanValue` annotation added to References.sk during review is included in this approval. Further edits, especially to support bodies, require a refreshed hash/delta review. Probe compilation/execution still belongs to the parent queue.

## Approved files and baseline identity

Prefix `build/parity-wave/allocation/replacements/`:

| File | Approved SHA256 | Baseline SHA256 |
|---|---|---|
| `Primitives.sk` | `1dbc4c12b6ed1abf85d1d7753211c6430a9eca267cfe77cf63613b5906985984` | `e65e7e12b59707c4dc653f560055f8a049ac7bd8ea9665c5234ccbded1f4ce69` |
| `References.sk` | `98cd51eff761d71e00919b3e378507bcecc1c7f9e0334ce54a2393b5c6cacef1` | `0ed639305d7f7f67aec3e50e6dc1c8ee1f3c78aedb3c005f80edfe5fb69904d5` |
| `Values.sk` | `86ea04dfa4d8ed29b0bca9e590ded38d48ed802f8665c1935ec9c39dfb198d2a` | `268b7215ee00efb9b870dd53cebff12d23fba6595c55ab576a4e97ce63332caa` |

Each original is byte-for-byte current `src/Support/<file>` and matches coordinator `baseline-source-hashes.json`. Full-file diffs contain only leanApply saturation branching, primitive swap/to_list delegation plus two helpers, and shared-blank/fresh-working reference-page initialization. Public identities/signatures, LeanValue variants and remaining code are unchanged. INVENTORY.json was refreshed to the References hash above after its explicit filler type annotation. Integrator must recheck shared-file baseline before replacement; do not overwrite intervening support changes.

## Exact-saturation representation and sharing

- `Values.sk:206-230`: empty args return the input object before decoding closure or arity. Nonempty nonclosure diagnostics unchanged. Partial application still captures `captured.concat(args)` in order. Overapplication retains invoke-before-drop-before-recursion, including zero/negative arity take/drop behavior. Callback exceptions and reference effects are not intercepted or reordered.
- Exact saturation uses the same fresh immutable concat result directly instead of making a second full-length take. Both arrays have the **concat receiver concrete class**, not necessarily an abstract base Array normalization. Read actual Skip Array implementation at `skiplang/prelude/src/core/primitives/Array.sk:84-85,411-420,458-463`: clone/take/concat allocate via receiver `static`; concat always fills a new array. Consequently callback input is physically distinct from incoming args and captured inputs in both versions, while contained values preserve their identities. The removed intermediate is never externally exposed.
- Initial A-1 empty-capture `all = args` bypass remains removed; do not restore it. The source comment claiming normalization to callback Array storage is imprecise: the reason the rewrite is safe is retaining receiver-class concat and removing only a same-class take. Recommend correcting that explanation, not changing semantics.
- No public wrapper change: result is exactly callback result; ST world/error wrappers produced by callbacks or task-map remain untouched. Arbitrary Nat/word values inside args remain dormant unless the callback inspects them.

## Array swap and list

- `Primitives.sk:247-253,357-406`: helper receives the original whole args array, so short-vector argument access is not eagerly reordered. Flat/persistent paths preserve first index decode/check/read before second index decode/check/read. `leanArrayReadIndex` remains authority for arbitrary Nat bounds before conversion and unsigned USize/modulo adapters. Both source values are read before updates.
- Flat size <=128 gets one private clone, two writes and trusted freeze; >128 still promotes to Persistent even for equal indices. Persistent gets one clone, two writes and chill. `Extensions.sk:92-134` baseline write policy matches. Skip vector clone copies its mutable tail, shares only immutable roots; set path-copies immutable root nodes and mutates only private tail (`PersistentRadixTreeVector.sk:140-166,239-256,716+`). No alias defect found.
- Tracked/override/unsupported branch remains the literal original two reads and nested two writes. Dependency access, missing generation/state, raw-context errors, shadowed overrides and equal-index collapse are unchanged. No new recordArrayWrite call: baseline swap did not record one. Outer primitive counter increments after success only, unchanged.
- `Primitives.sk:408-429`: persistent to_list removes temporary materialization but still emits List.cons in original element order with exact element identities. Reverse vector reads are pure for valid vectors; LeanUnavailable/reference/closure elements are not decoded. All other shapes still call leanArray, retaining tracked/override/unavailable rejection. Private forged invalid radix-tree internals and allocation exhaustion are outside this bounded argument.

## Reference page alias safety / publication

- `References.sk:6-12,73-87`: pages share the **immutable** 256-None saved image. Every new page receives its own `Array::mfill(..., (None() : ?LeanValue))` working array. set uses that private array. The common saved image is never mutated.
- Page snapshot still chills working into an immutable saved image and clears working; first later write still clones saved. Snapshot restore builds distinct page objects with no working array, sharing only immutable saved arrays. Append inside an existing last page clones on demand; append at a boundary creates a fresh private working page. Table count/index, taken slots and reference identities unchanged.
- Actual `Execution.sk` region/checkpoint and `Values.sk:131+` publication contracts were read: region success **and exception** adopt post-action references/initializers (not rollback); refs/unavailable values nested in arrays/closures/tasks still cannot be published. No execution/cache/publication policy changed.

## Probe-source review, independent oracles and limits

Reviewed sources, not executed by reviewer:

| File under allocation/ | Reviewed SHA256 |
|---|---|
| `Probe.sk` | `7431b053f6f539915d570cddfe8498ecabc428b403d6fbcc7411c094854e4518` |
| `ProbeEffects.sk` | `c36d42d99d7cbd4ad064ba7dd65cdd965d70dce84ae15eaca899de06928ba66f` |
| `ProbeBaseline.sk` | `16e89d85d1058a1da427495835f12a57b5f0112bb56eb4fe6f4d9d5430b427d6` |
| `run-probe.py` | `e08f41b360b75c6805528c4f9f9a114e6de7ab4c339fa8bf8b1b83e1e6da302e` |

Baseline leanApply, primitive core, profiling wrapper and all reference classes were mechanically checked against actual lane originals after exact symbol/self-recursion renaming: match. Old primitive callbacks redirect to old leanApply. But checkpoint/region/ST operations on LeanExecution still use the current reference table; separate original-table probes supply that differential comparison. Do not describe the whole process as two entirely isolated runtime stacks.

Positive sources include:
- Concrete incoming Array<LeanText>, Array<LeanCtor>, Array<LeanNatural> and mixed values; empty/nonempty captures; independent expected args and SKIP_physEq non-alias assertions; element identity, partial completion retention, exact callback once, overapplication order, zero/negative arity and exception-side effects.
- Profiled failed task callback has independent expected ref=9 and successful primitive count/time=0. Success callback/ST chain has independent state 0->1->2 and exact opaque world.
- Flat/persistent swap across sizes1,2,32,127,128,129,256,1025, narrow/mixed arrays, both index conventions, equal/reversed endpoint pairs; independent per-index element identities and promotion tags; source-root retention; subsequent write/push/pop and checkpoint publication. List checks all element identities/order and terminal nil, including empty.
- Tracked slots/overrides use real store fixtures, independent swapped values and raw reads of override slots; missing root stays dormant. Actual dependency-event logs are not compared.
- Counts0,1,255,256,257 and769->1025: common blank saved physical sharing, independent working page values, tail None, multiple restores/forks, old-table comparison, boundary appends, taken slots, retained earlier snapshots. Region success/error tests independently expect ref71, new ref513/value72 and initializer survival.
- Runner has27 negative cases x old/new with independent exact diagnostics/exit86 and explicit callback-before-surplus marker. Includes missing second argument with poisoned first index, large Nat, unsigned negative USize, tracked/raw/generation errors, taken ref, unsupported primitive and nested publication restrictions.

Nonblocking gaps/parent validation notes:
1. Execute corrected probe files before claiming runtime parity. `run-probe.py:54-56` has no explicit release flag; parent should select the intended supported build mode given the separately observed debug stack-trace linkage issue, without weakening its independent expected diagnostics.
2. Extend exact-saturation fixtures to nonempty **narrow concrete captured arrays**, not only narrow incoming arrays; current receiver-class source argument covers them, but the distinction was central to A-1. Keep concrete-class old/new comparison plus independent expected representation appropriate to that receiver, not an assumed universal base Array.
3. The shared comparison checks refs, initializer/identity tables and counters excluding ns, but not every execution setting/cache field. No new setting/cache writes were found in the production delta. Tracked tests share a store context across calls and are not a proof of exact dependency-event ordering; the relevant branch is unchanged.
4. Keep normal runtime and existing array/materialization/constructor/primitive adapters plus end-to-end proof/reject checks in parent queue. No benchmark or measured speedup is claimed.
5. New `f_allocationArraySwap`/`f_allocationArrayToList` names remain as authored. If parent applies the requested lean-style helper rename, update references/inventory/probe selection and supply exact final hashes; no existing canonical ABI needs renaming.

Report filename checked absent before creation.
