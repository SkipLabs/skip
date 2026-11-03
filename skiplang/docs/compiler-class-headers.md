# Keyed class state through optimization

Status (2026-11-03): rejected performance screen; still opt-in. Diagnostic and optimized compilers pass
twelve focused cases, all 28 optimized incremental regressions, and both policies
pass 50 finite-state cycles. All 1,765 language cases pass, but the
full-workload screen exposes a severe invalidation regression. It follows the measured lack of benefit from
[direct class publication alone](compiler-class-inputs.md).

`SKC_COLLECTION_CLASS_HEADERS=1`, together with `--collection-classes`,
`--collection-functions` and collection emission, removes the complete class
snapshot from the shared IR and optimizer headers when inlining, IPA and full
debug are disabled. The ordinary and release paths keep their existing
representations. The performance-based fallback restriction described below is
newer than the original performance host. Its diagnostic gate now passes the
twelve class-header regressions together with three declaration regressions.

The initial header reads only active runtime and constant roots from the keyed
function plan. These are membership reads, including absence; allocating an ID
from the lazy identity registry does not prove that a function still exists.
The unused full identity aggregate is suppressed on this path. Ordinary classes
and synthetic return tuples retain the existing keyed ownership and collision
checks.

Optimizer rounds forward class rows directly. Coroutine replacements keep their
deterministic origin ordering. Precise function passes use tracked class reads;
coroutine handling and generated-function verification reconstruct complete
views where needed. Those views are transient, rather than shared records
propagated through every round. Inlining, interprocedural optimization and full
debug retain the existing shared environment under the new fallback restriction.

Constant initialization also uses tracked class readers, including scalar field
layout and emission verification. Its plan publishes just the updated synthetic
constant singleton. Other classes flow from the preceding round without being
collected and republished through the constant plan. Constant accesses read the
current singleton override and current ordinary class rows.

The final optimizer output selects keyed classes using a separate class-membership
projection, following the existing function-selection protocol. Directory
replacement, removed keys and live policy changes remain tracked. The subsequent
escape analysis still traverses a complete class graph; its input now reads only
class rows. A function body change must not cause that traversal merely because
functions and classes share an upstream directory.

The focused suite extends the class collection regressions with newly reachable
helper calls, unrelated layout changes beside constants, live header-policy
changes, and inline/IPA/debug fallbacks. Existing tuple, coroutine, removal,
constant ordering and failure-recovery cases pass. The full language gate also
passes all 1,765 cases. Global escape,
vtable and graph work remain separate costs; this candidate does not claim to
eliminate them.

The [same-host screen](experiments/incremental-backend-20261101/class-header-boundary-rejected-screen.md)
rejects this implementation. Cold time rises from 317.261 to 392.789 seconds,
with 74.122 seconds of the increase in optimization. Two candidate literal
updates take 72.994 and 72.755 seconds versus the control's three-sample median
of 0.785 seconds. Every recorded output validates. The screen stopped after the
second literal edit; other candidate edit categories and branch cases remain
unmeasured. Both caches were exported, verified and removed.

`ClassInputs.readAll` traverses a mixed class/function collection and records a
whole-collection dependency. Consequently, any function-body change invalidates
the coroutine and verification consumers using that fallback. They also rebuild
the class map independently. The first candidate literal edit spends 28.959
seconds in function optimization, 28.734 in input preparation and 14.470 in
generated-function verification. A class-only shared fallback view is now applied.
Its first compiled diagnostic passes 16 of 20 focused regressions, including
unrelated-body locality and required class-layout invalidation, but exposes four
missing-view failures during live policy changes. A correction registers the
lazy view handles for every optimizer round. That correction passes all six
targeted regressions and all 28 broad incremental regressions, with serialized
class comparison, variance-index verification and native workers enabled in the
broad suite. No optimized performance result exists for this correction. Keeping classes out
of ordinary shared headers remains useful
only if these remaining full-view consumers avoid mixed-collection reads.

The matched small-fixture [retention check](experiments/incremental-backend-20261101/class-headers-retention-validation.json)
passes 103 successful builds per policy, including failed-update recovery.
Final reachable state is 285,789,472 bytes for the control and 286,031,144 with
class headers, an increase of 241,672 bytes. Both have a 14,480-byte
live-minus-reachable residual. This does not establish a full-workload memory
benefit. The additional final class-membership projection has its own metadata
cost; retained maps already share many underlying values.

The fallback fixture initially supplied both `-O0` and `-O2`; the CLI correctly
rejected it. After correcting those arguments, changing a populated cache from
`-O0` to `-O2` exposed an optimizer error (`still OptPartial in LowerGC`). The
same error reproduces on the preceding native-artifact host and with this
candidate disabled. Fresh `-O2` initialization and subsequent body changes pass
in both controls. The focused fallback test now starts at `-O2`, then enables
and disables debug output while keeping the optimization policy fixed; it
passes. The twelve diagnostic cases therefore span the initial eleven passes
and the corrected fallback run. The
[controls and reproduction](experiments/incremental-backend-20261101/class-headers-optimization-mode-controls.json)
are preserved separately. A later trace shows the completed optimizer
continuation reentered with 455 pending functions. Rechecking its tracked
pending-work row before returning a completed result fixes all three reproduced
transitions. The [repair gate](experiments/incremental-backend-20261101/optimizer-resume-validation-result.json)
passes five transition/fresh-cache probes and six executable regressions,
including repeated policy switches with constants and coroutines. Broader
integration continues with the class-view correction.

The [full language run](experiments/incremental-backend-20261101/class-headers-language-validation.json)
takes 3,079.700 seconds with four concurrent jobs, versus 2,044.160 seconds on
the preceding native-artifact host. This is a performance concern, not a matched
policy comparison. The language fixtures keep IPA enabled, where the candidate
reconstructs full class views per consumer. The subsequent
[same-host cold IPA screen](experiments/incremental-backend-20261101/class-header-fallback-cost.json)
reproduces the regression: headers off/on/on/off takes 6.390/10.783/10.725/6.416
seconds, with validated output in each fresh cache. Clang object active time is
0.804/0.808/0.826/0.819 seconds; final linking is about 0.023 seconds. The additional
cost therefore occurs inside the compiler, rather than native compilation.

The worktree now restricts narrow headers to configurations with inlining, IPA
and full debug disabled. Those full-environment modes retain the existing shared
class map. Direct-class availability uses the same effective predicate, so
downstream consumers cannot select an empty keyed source when the fallback is
active. This correction passes all twelve class-header regressions on the new
diagnostic host, including fresh O2, body changes, and debug toggles, alongside
three declaration regressions. Optimized performance confirmation remains open.
The rejected comparison used the already frozen binary; both timed policies
disable inlining and IPA. Generated language outputs have been removed, reclaiming
3,395,063,808 allocated bytes.
