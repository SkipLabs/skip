# Reviewer notification: v3 probe binding correction

Parent may requeue the offsets overlay. No compile/probe/test was run by this lane.

- `replacements/f_Meta_evalNat_visit_be1fb46d98.sk:225`: removed only the
  function-final `return` keyword. Final expression is `f_offsets_wave_none(world)`.
- The exact previous visitor bytes can be reconstructed by putting those seven
  bytes (`return `) back; their SHA256 matches the prior bounded static review.
- `write_visitor.py` emits the corrected expression.
- Inspected endings of all 25 replacement functions: no further function-final
  return found. Remaining early returns retain short-circuit/error behavior.
- `Probe.sk:546`: added `assert(checks == 312)` before the success output.
  Arithmetic/result expectations, negative-power sentinel and fallback flag policy
  were not changed. Parent checks exact actual power error and exit 86.
- Other three replacement hashes and `ProbeOracle.sk` hash are unchanged.

Rebind the visitor hash in `reviews/elaboration-offsets-final-static.md` when
reviewing this syntax-only delta; that shared reviewer file was not edited here.
`PACKET.json` and `REVIEW.md` are refrozen.

| File | SHA256 |
|---|---|
| Previous visitor | 741e4c96bc630ad769de6ff9eed0bf0f224dd848920d6209508ef4c5a1e53ef0 |
| Corrected visitor | b6d4005330eb50cd2935ffdb0daa7d0eb79645a74f21787e1b4a32e7599ef2fd |
| Current probe | cb2e56504943845093e8cf283bbc98517a8d0d60766beeea70a3338f40ec5114 |
| Unchanged oracle | 8e87efb152a1535e37754f0c301d42bd58c4cddfc39772ac24fb367b9f2e714f |

## Latest v3 delta (body freeze unchanged)

The full v3 log reported nested `instanceName` shadowing. Probe.sk now uses
purpose-specific names across all setup/loop/lambda/pattern bindings and all
comparison-result locals, not only the failing tuple. Static inventory: 13 probe
functions; 145 main bindings; no function-wide duplicate local bindings. Renaming
180 identifier occurrences reverses to the exact prior file. See the two
probe-binding JSON inventories for scope/line details.

All four replacement bodies, the frozen oracle, expected outcomes, call order,
negative sentinel, fallback flag and 312-check assertion are unchanged. Only
probe local names changed; no compilation/execution or success claim. Parent
may use the current probe hash above when the serialized queue returns here.
