# Rewrite lane — paused on user request

No build, test, probe, or benchmark execution by this lane. No production changes.
No file write was in flight when pause arrived. Stopping further edits/investigation.

## Completed packet and corrective writes

All five replacements, Probe.sk, ProbeFailures.sk and REVIEW.md already exist.
Probe.sk and write_probe.py now use distinct meaningful bindings throughout;
inverse renaming reproduced their prior bytes exactly. Probe hash after naming
fix: e88edee2b5454ccbe0289642333df94fe16bb80cee965ac87827c4ea2973387f.
Source-only scan found no repeated/reserved/unused probe bindings. Writer literal
reconstruction matched Probe.sk without executing either writer or probe.

Four replacements and write_replacements.py also received alpha-renames only:
- index: selectionOptions (hash 12c3aec795aff8eb83b0fe41747ff9997e2f5c6a0cb3479396180b827b305999)
- simproc: distinct terminal/continuation composition and result bindings (hash a5aebce1841b51ca5aa8a47ebbae5562c9002c0108567bf913fa68e0663bbeda)
- theorem go: distinct trace locals and _validatedTraceOptions; original validation call retained (hash 7d17976db7f111cf9b98a6b0a33335ce80b5bcca4f36fa024322d7c7d6e7e41b)
- candidate: distinct debug/backward trace/message bindings (hash f0b0783418273be45c3839fcc668ec1fd1054595f5036d8a09b23218e87ee3d3)
Decide replacement unchanged. Inverse alpha-renaming and AST literal reconstruction
verified all changed replacements and synchronized writer. These new hashes are
UNREVIEWED and UNCOMPILED; prior review hashes are STALE. No semantic change made.

## Exact remaining blocker / partial-edit state

Read reviews/elaboration-rewrite-final-static.md, R-P1. Its required trace split
has NOT been implemented. Probe.sk still schedules 96 comparisons, including
trace-on cases that reach unsupported lean_float_of_bits. Do not accept it as a
positive executable packet yet. REVIEW.md still describes the old 96-case matrix
and has not been updated with naming corrections or R-P1. No trace driver installed.
ProbeFailures.sk still lacks explicit old|new validation. No exact count assert yet.

## Next action after resume

Keep existing trace-off expected outcomes. Split the four direct-go trace-on
fixtures plus empty-index trace-on fixture into separately invoked old/new exact
unsupported Float.ofBits negative modes, with profiling off/on; do not implement
Float support. Recount positive schedule: 86 comparisons = 82 differential + 4
same-wrapper assertions; add exact count assertion after independently checking.
Expected trace negatives: five fixtures x two profiles x old/new = 20 invocations;
existing six failure modes x old/new = 12. Validate old|new explicitly in failure
CLI. Confirm exact reached primitive/diagnostic from source and document commands.
Finish source-only binding/reserved/unused/return audit, synchronize writers,
update REVIEW.md/hashes, then freeze and notify coordinator. Parent owns all
compilation/execution. No further action until resumed.
