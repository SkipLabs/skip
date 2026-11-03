# Incremental LLVM text construction

Status (2026-11-03): native final concatenation passes focused validation and
its first isolated full-workload pair. The subsequent text-span candidate passes
standalone, diagnostic, optimized and full-language correctness gates. The later
[same-host span screen](experiments/incremental-backend-20261101/emission-locality-matched-screen.md)
finds no consistent end-to-end improvement: historical/return updates are
79.428/80.851 seconds without spans and 81.034/80.037 with them. Branch emission
itself falls from 9.474/9.682 to 8.829/8.679 seconds. Each branch has one sample;
retained state is unchanged at 10.972 GB. Both remain opt-in.

The [completed same-host pair](experiments/incremental-backend-20261101/native-concat-full-workload-pair.json)
measures historical/return branches at 82.500/87.631 seconds for the control and
79.233/80.941 with native concatenation. LLVM emission falls from 11.567/12.346
to 9.194/9.200 seconds; Clang still takes 13.011/13.313 seconds in the candidate.
Other phase timings also vary, so the entire elapsed difference is not attributed
to copying. Cold initialization is 328.498/324.708 seconds (control/candidate),
with cold emission 18.623/16.035 seconds. Retained state after return differs
by only 112 bytes, at 12.075 GB in both policies.

Three-sample small-edit medians are 0.810/0.791 seconds for literals,
1.208/1.210 for control flow, 0.934/0.916 for methods and 3.068/2.954 for generic
edits. Cold and each branch direction have one sample. All outputs validate;
both caches were exported, verified and retired. This comparison uses the
frozen `host-reader-blocks`, with block readers and direct class publication
disabled, and delta retention enabled. It is separate from the older focused
`host-native-concat` validation below. The block-reader screen is also complete;
see [its separate results](compiler-reader-blocks.md).

The verified branch CPU diagnostic attributes 2,403 samples to LLVM emission.
Character iteration, byte access and string construction appear among the most
frequent leaf frames. The latest completed indexed branch screen spends 11.682
seconds in emission, separately from 13.152 seconds in Clang. Those observations
motivate these candidates; they do not predict their speedup.

`SKC_NATIVE_EMISSION_CONCAT=1` changes only final module-string concatenation.
The compiler-local binding calls the existing `SKIP_String_concatN` runtime
function, copying UTF-8 fragments directly. The ordinary builder operations and
character counts remain intact. A byte-count guard retains the old path when
the native 32-bit count cannot represent the total. Focused tests cover Unicode,
NUL, escaping, numbers, clear/reuse and repeated finalization, and require
byte-identical LLVM plus unchanged object inodes and timestamps when switching
the policy on an initialized compiler cache. See the
[validation record](experiments/incremental-backend-20261101/native-concat-validation.json).

`SKC_EMISSION_TEXT_SPANS=1` additionally changes literal copying within module
rendering. A monotonic cursor translates character-based reference/debug offsets
to UTF-8 byte boundaries. The output builder retains those spans as strings,
inserts symbols and metadata between them, and concatenates them natively at the
end. Small character writes use a bounded buffer in this mode. Counts remain
character counts; byte offsets do not replace source or IR positions. The
release emission path continues to use its ordinary builder.

The span tests compare prefix and final bytes against the ordinary writer across
different split sizes, repeated offsets, empty strings, NUL and multi-byte code
points. The compiler test switches policies on the same cache, modifies a body,
and restores it, checking every LLVM file and native output. These tests are
passing, alongside 28 incremental regressions, 20 optimized focused checks and
all 1,765 language cases. See [span validation](experiments/incremental-backend-20261101/emission-spans-validation.json).
The new field and bindings postdate the frozen `host-reader-blocks` compiler and
are absent from its measurements.

The experiment sequence isolates final concatenation first, reader blocks on
that same host second, and spans on a subsequent host. Each native comparison
must use a same-host control, separate fresh caches, validated output and Clang
and linker accounting. Fragment counts and peak memory also matter: reduced
character copying is insufficient if fragment allocation offsets the gain.
