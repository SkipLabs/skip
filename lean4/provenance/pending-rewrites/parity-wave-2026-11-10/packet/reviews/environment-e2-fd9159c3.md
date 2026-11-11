# Environment E-2: fixed-layout reconstruction still differs

Static reviewer foundations/fd9159c3. **Hold modifyStateCore and recordExtGenAccess. Other environment targets are not yet finally approved.** No probe/test/compiler execution by reviewer. E-1 branch-local short-field projection replay is present, but does not address this separate output-ABI issue.

## Concrete blocker

`replacements/f_Lean_EnvExtension_modifyStateCore_4449449a88.sk:51-52,70` uses leanReplaceField to rebuild kernel/visibility/environment. Current reviewed SHA256 is `82503d291d70bce92d7beada78a83fad992020e8f05582d749832135ae9fa075`; the same issue exists in ready-sha256 hash `d3a90451ee685f67b902906af2b73e5ac745eb41153a17f66f683b072f142381`.

Actual `src/Support/Values.sk:190-202` leanReplaceField clones the **entire** existing fields array, changes one slot, and preserves its concrete class/length. Original local-mode construction in `environment/originals/f_Lean_EnvExtension_modifyStateCore_4449449a88.sk:592-638` explicitly constructs kernel9, visibility2 and environment15 fields. Generation-bump construction at original `:204-249` has the same fixed-layout behavior. Original required-field projections are only lower-bound checks, not exact-arity validation, so extra fields are accepted then omitted when those records are rebuilt.

Concrete independent fixture: start from any valid local-mode environment/extension, no generation bump, identity transform. Append one `LeanUnavailable` sentinel to the outer environment fields (16 fields), retaining the correct tag and all valid required fields. Both versions accept the input; original returns a15-field environment while rewrite returns16. Put the extra sentinel separately on private kernel or visibility and the same difference is9 vs10 /2 vs3. The original input object remains unchanged in either case. This is a returned shape/representation mismatch, not merely an untested fatal error.

`replacements/f_Lean_recordExtGenAccess_5d4ca21401.sk:93`, SHA256 `9f1f6568ae9da3d7c5320dff6cc4deddb65ed84327592962f22d41ad13857169`, likewise preserves surplus Core.State and RecordedDeps fields. Original `environment/originals/f_Lean_recordExtGenAccess_5d4ca21401.sk:334-365` rebuilds exactly6-field RecordedDeps and10-field Core.State before reference put. On a first new generation recording with a valid generation index, append a surplus dormant field separately to either record: old stores fixed arity, new retains surplus. Assert reference state and exact EST world/result independently. Duplicate/disabled early returns should still preserve the original untouched state, not eagerly normalize it.

## Required correction and coverage

- Rebuild exactly the original records, with original tags, array representation, known field order and arity, at those original reconstruction points. Retain already restored branch-local ascending required-field projections and callback/get/take/put order. Do not add an exact-length rejection: original accepts these records and rebuilds them.
- Do not change shared leanReplaceField semantics; this is a lane-local reconstruction choice. Readability helpers are fine if their fixed-layout contract is explicit.
- Add independent surplus-field tests for each rebuilt record family, generation bump and local modify paths, and recording append versus duplicate/disabled paths. Expected outputs must be explicitly fixed-layout, not computed with leanReplaceField on the overlong fixture.
- Narrow concrete constructor field arrays are another reason to preserve original explicit Array[fields...] publication rather than clone incoming concrete storage. Source ABI argument suffices to identify the surplus-field blocker; no speculative runtime behavior is needed.

## Freeze note

During review ready-sha256.json became stale relative to getStateUnsafe, modifyStateCore, type-cache insertion and all three Probe*.sk files; replacement line counts were unchanged. No current-file final approval is inferred from the old readiness manifest. Refresh exact hashes once author/compiler-only edits are complete. At last read the reconstruction sites above remained.

Earlier six-expression, bindings, and allocation approvals remain bounded to their separate reports/hashes and are unaffected by this environment hold. Filename checked absent before creation.
