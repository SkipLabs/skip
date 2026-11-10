# Bounded allocation-site inspection

`calloc-sites.json` narrows the recovered memset bucket to the **3,796 samples whose captured LR-4 is a direct BL to SKIP_Obstack_calloc**. The six direct memset samples in Map.growCapacity are excluded: its calloc-only ownership is 186, while its full memset ownership is 192.

The three largest individual calloc sites are all container/representation allocations, rather than translated local-variable frames:

| Caller and exact BL address | Samples | Requested byte count | Source purpose |
| --- | ---: | --- | --- |
| `leanArrayWrite`, `0x43b330` | 155 | `16 + 8 * inputArrayLength` | New ordinary array from `mapWithIndex`, replacing one element and retaining the others. |
| `Map.growCapacity.1`, `0x999e64` | 131 | `16 + 24 * slotCount` | New native Map entry array, initialized with empty entries. |
| `leanReplaceField`, `0x4c26cc` | 107 | `16 + 8 * fieldCount` | New LeanCtor field array from `fields.mapWithIndex`. |

These byte counts are the allocation-size expressions decoded from the frozen executable. The sampler does not capture the live size-register values, so the actual size distribution and allocated-byte totals are unknown.

`leanArrayWrite` loads the ordinary array length into `w24`, shifts it by three, and adds 16 immediately before the call. After allocation it writes the array header and fills each result element through the map callback. This corresponds to `src/Support/Extensions.sk:104`, the final ordinary-array branch. The other cases have independent tracked/override/persistent representation behavior; this capture does not authorize changing that contract.

`Map.growCapacity` has two calloc sites. The leading site `0x999e10` (55 samples) allocates `16 + 4 * (1 << log2NumSlots)` bytes for the index table; the leading memset writes its empty-index marker. The larger site `0x999e64` allocates the 24-byte entry slots. They correspond to `Array::mfill` calls at `/home/julienv/skip/skiplang/prelude/src/stdlib/collections/mutable/Map.sk:968` and `:969`. This is existing Skip library code, outside the authorized rewrite scope. Application code can be examined for avoidable Map creation/growth without modifying the library/compiler/runtime.

`leanReplaceField` loads the old field-array length into `w23`, shifts it by three, and adds 16 immediately before the call. The result gets an array header, then a callback fills every slot. This corresponds to `src/Support/Values.sk:200`. The operation rebuilds a constructor representation; eliminating a translated caller frame alone does not imply this cost disappears.

Saved evidence: `array-write-site-disassembly.txt`, `map-growth-site-disassembly.txt`, and `replace-field-site-disassembly.txt`. The complete calloc-only owning-function counts and individual call-site addresses are in `calloc-sites.json`. Their top owners are Map.growCapacity (186), leanArrayWrite (155), evalNat.visit (116), isDefEqQuickOther (109), leanReplaceField (107), and isDefEqArgsFirstPass (103). Source-purpose attribution beyond the three inspected sites remains open.
