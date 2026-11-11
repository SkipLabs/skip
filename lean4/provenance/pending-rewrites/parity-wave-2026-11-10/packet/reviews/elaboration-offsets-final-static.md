# Offsets frozen packet — final bounded static review

**Decision: all four frozen bodies and authored probe/oracle pass bounded static review; no concrete semantic body blocker found.** Parent may advance the family overlay compile/guarded integration. This is not execution validation. No build, test, probe or benchmark run by reviewer; no production edits.

## Bodies

All four hashes match independently reviewed provisional bodies; see `elaboration-provisional-body-review.md` for detailed invariants. Preserve the cross-file f_offsets_wave helpers once, as a family.

| Replacement stem | SHA-256 |
|---|---|
| f_Lean_Meta_evalNat_6bfbb6a56e | 68d584291331245f31e421633615087ea7880f50c352f8158ee194027d5d3976 |
| f_Lean_Meta_isDefEqOffset_4916547658 | b57aa73689e9979845a6d713aaa31fc1c45079a9cf40c721dceca3506c953bca |
| f_Lean_Meta_isOffset_cecda6b311 | 6c4d2a3d868e54cdb28674fa2f2aea3a9cf4ac595535b4c5ad09f0db8b8b3fd8 |
| f_Meta_evalNat_visit_be1fb46d98 | 741e4c96bc630ad769de6ff9eed0bf0f224dd848920d6209508ef4c5a1e53ef0 |

## Oracle independently verified

Read the generation script, but did NOT run it. An independently written read-only slicer reversed identifier renaming and the two explicit Offset-helper qualifications in the actual ProbeOracle.sk. All eight recovered bodies matched exactly: four selected originals plus actual production getOffset/evalPow/mkOffset/isNatZero. Original-body hashes agree with the embedded pre-renaming hashes. No remaining unqualified external f_ call found.

Read the four small wrapper bodies and local call routing. The local family cycles stay frozen:
- isOffset ↔ getOffset
- evalNat ↔ visit; visit → evalPow → evalNat
- isDefEqOffset → mkOffset → isNatZero → evalNat

Qualified production closure adapters remain shared by design; they implement type guard/residual equality, not renamed local recursion. matchesInstance, withNewMCtxDepth, instantiation, testers, inference, general defeq, checkExponent and expression/Nat runtime still shared. General defeq can reenter canonical offsets; this is local-family isolation, not the entire old Meta graph. Independent expected outcomes remain necessary.

Oracle SHA-256: `8e87efb152a1535e37754f0c301d42bd58c4cddfc39772ac24fb367b9f2e714f` (6223 lines). Never integrate these test-only frames into production.

## Probe review

Read all 547 lines and the actual fixture/helper contracts. Static count independently confirmed:
`2 * (19 + 17*2 + 6*(2+4) + 7 + 7*2 + 21 + 13 + 1 + 1 + 1 + 2 + 1 + 4 + 2) = 312`.

- Fixed exact arithmetic values include 2^64 and beyond, saturating subtraction, division/modulo zero and exponent zero. Visitor does not invent zero-multiply/base-one/exponent-zero shortcuts when the other operand is blocked.
- Distinct assigned-mvar literal vs successor/application behavior and metadata placement are explicit.
- Every homogeneous/heterogeneous operator family, Pow and OfNat included; structural instance rejection before operand evaluation.
- Offset right-before-left, nested/zero offsets and original metadata base preservation checked.
- All top-level defeq branch orientations represented; LBool constructors explicit. Residual equalities deliberately use identical OfNat expressions to avoid undeclared imported implementation assumptions.
- Original-left Nat type guard independently challenged by changed Nat.add interface; older type/instance mvars remain unassigned under new depth.
- Exact recursion-depth EST error/world, warning before blocked base, warning avoidance on earlier exits, and repeat-warning deduplication asserted.
- profileRuntime off/on; expression/context inputs copied separately; old/new refs compared. Some cases additionally demand refs unchanged.

## Concrete gates / limitations

1. Probe:546 only prints the count. Add `assert(checks == 312)` before final success output so authored-count drift cannot masquerade as completion.
2. Probe:292 sentinel is `expected Nat.pow exponent is too big`, containing the real expected diagnostic substring. **Do not accept substring/nonzero matching alone.** Parent must reject this sentinel and require the actual production Nat.pow error from both old/new modes. No huge result should be allocated; threshold and exponent 2^32 permit reaching runtime bound.
3. Probe:69 tests environment-variable presence, not equality to `1`; unset it for default eight-function oracle, set it only for secondary canonical-fallback run.
4. During review parent aligned fallback suffixes from `_canonical_fallback` to `_fallback`; PACKET.json records that integration-only rename. Probe now hashes `960ccce682631d3ed7bde621d707750b64a78072a65ce7b6875e0ad93147f8a2`; initial inspected logic hash was `cd582fd0b4c1112248082c6f37fd7cd1ea26638356ca5624677791dcccabe1cc`. Recheck final files after any compile/guard repairs.
5. This probe uses raw execution; no tracked-store dependency parity established. Common RewriteProbe compares result/refs only, not every checkpoint field. Input checks occur after both routes and do not deep-copy all specialized value kinds. `retainedRefs == saved.refs` is weaker than an independent frozen expected root. Named unchanged cases and independent older-mvar checks mitigate that limit.
6. Warning tests assert changed then stable message roots, not independent full warning text/count. Active timed traces, cancellation, stuck exceptions, imported instance unfolding and very deep expression recursion remain outside this bounded probe coverage, as author discloses.

Current metadata hashes observed:
- REVIEW.md `35e86c8031ceb0ba1ca599753290dbfcb2dfd21193cc6e47d46ca6f59839908c`
- PACKET.json `b597b27f3e979ccc9cc850f2154c7e70194164a97159128756f94f1a2f26a3c2`

No static semantic reason to delay compilation. Final execution acceptance requires successful serial compile, planned assertions, correctly classified paired negative results, and the parent's imported-Goal correctness checks; no performance claim.

## v3 scoped delta recheck — passed

Read author REVIEW-NOTICE.md and actual corrected files. Independent reconstruction verifies that adding only the terminal `return ` back at visitor line225 reproduces prior SHA `741e4c96bc630ad769de6ff9eed0bf0f224dd848920d6209508ef4c5a1e53ef0`. Removing only `assert(checks == 312)` from the new Probe reproduces prior SHA `960ccce682631d3ed7bde621d707750b64a78072a65ce7b6875e0ad93147f8a2`.

Approval now binds visitor `b6d4005330eb50cd2935ffdb0daa7d0eb79645a74f21787e1b4a32e7599ef2fd` and Probe `c3e20e200f09b00f6e5078f071cf96541c190fd8cc9e534be0ffb278e009383e`. Other bodies and oracle unchanged. Count-guard issue1 is closed. Negative sentinel classification still applies. This is static syntax-delta verification only, not a successful compile/run claim.
