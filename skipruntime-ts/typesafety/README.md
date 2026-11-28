# Skip Service API Type-Safety Probes

Positive and negative TypeScript probes exercising the `SkipService<InputDefs, ResourceInputs>` API (`InputCollections`, `AllInputDefs`, `AllSharedCollections`, `ResourceClass<ResourceInputs, Json>`, `asLeader`, `asFollower`, `initService`, `ServiceInstance`, `Watermark`, `SubscriptionID`, and sealed nominal abstract bases).

This directory is excluded from npm workspaces because the negative probes intentionally violate type safety; `bin/check-ts.sh` runs `npm run typecheck` (`node check.mjs`) here to verify that all positive probes compile cleanly and all `tsc`-enforced negative probes fail type-checking.

## Positive Probes

All 8 positive probes pass `tsc --strict` and verify (`check`) under [TScert](https://github.com/cristianoc/TScert/pull/439).

Note on `p05`/`p05b`/`p06`: when defining a service as a standalone unannotated `const service = { ... }` (rather than inline in `runService({ ... })`), TypeScript has no contextual type for `createGraph`, so `createGraph`'s parameter and return types must be annotated explicitly.

| Probe | `tsc --strict` | TScert | Coverage |
| --- | --- | --- | --- |
| `p01-matched-inferred.ts` | pass | verified | Inferred `runService`, pass-through `(ic) => ic`, `Resource.instantiate` and `Mapper.mapEntry` omitting `_context` |
| `p02-derived-graph.ts` | pass | verified | `Mapper`, `LazyCompute`, `Reducer`, runtime-validated `Resource(params: Json)`, and indexed `JsonObject` record |
| `p03-asleader-asfollower.ts` | pass | verified | `asLeader`, `asFollower` with `collections`, and `asFollower` with `lazies` |
| `p04-initservice.ts` | pass | verified | `initService`, `ServiceInstance.subscribe`/`unsubscribe`/`reload`, `Watermark`, and `SubscriptionID` |
| `p05-unannotated-const-service.ts` | pass | verified | Function-local unannotated `const service` passed to `asLeader` and `asFollower` |
| `p05b-unannotated-module-const-service.ts` | pass | verified | Module-level unannotated `const service` passed to `asLeader` and `asFollower` |
| `p06-collection-named-length.ts` | pass | verified | Collection legitimately named `length` accepted in `InputDefs` and `ResourceInputs` (arrays rejected via `keyof T & string`) |
| `p07-asfollower-empty-resource-inputs.ts` | pass | verified | `asFollower` with `collections: []` on `SkipService<Record<string, never>, Record<string, never>>` |

## Negative Probes

All 23 negative probes are refused under TScert (19 in Lean proof search, 4 at the source gate). Under `tsc --strict`:
- 17 of 23 are rejected across TypeScript 5.7+ (enforced by `check.mjs` in `bin/check-ts.sh`).
- 5 (`n02`, `n03`, `n04`, `n09`, `n09b`) pass plain `tsc` because `Mapper`, `Reducer`, `LazyCompute`, and `Resource` keep method syntax for `this`-receiver soundness (and `tsc` checks interface methods bivariantly); TScert refuses all 5 in Lean.
- 1 (`n10`) passes TS 5.7/5.8 due to open-record implicit index signatures and is refused by TS 6.0+ and TScert.

| Probe | `tsc --strict` (5.7 / 5.8) | TScert | Fault |
| --- | --- | --- | --- |
| `n01a-input-type-mismatch-annotated.ts` | reject | refused (`search`) | `InputDefinition<string, number>` into annotated `EagerCollection<string, string>` `createGraph` |
| `n01b-input-type-mismatch-inferred.ts` | reject | refused (`search`) | `InputDefinition<string, number>` flowing via `(ic) => ic` into `Resource<{ names: EagerCollection<string, string> }>` |
| `n02-extra-resource-field.ts` | pass (method bivariance) | refused (`search`) | Resource reading `c.extra` absent from `createGraph` output |
| `n03-narrow-mapper-on-json.ts` | pass (method bivariance) | refused (`search`) | `Mapper<string, number, ...>` applied to `EagerCollection<string, Json>` |
| `n04-narrow-reducer-on-json.ts` | pass (method bivariance) | refused (`search`) | `Reducer<number, number>` applied to `EagerCollection<string, Json>` |
| `n05-non-inputdef.ts` | reject | refused (`search`) | Non-`InputDefinition` value (`42`) in `inputs` |
| `n06-non-collection-output.ts` | reject | refused (`source`) | Non-collection output (`{ count: 42 }`) with `Resource<{ count: number }>` |
| `n06b-non-collection-output-bare.ts` | reject | refused (`search`) | Non-collection output (`{ count: 42 }`) with empty `resources` |
| `n07-unvalidated-resource-params.ts` | reject | refused (`search`) | Resource constructor requiring narrow `{ userId: number }` instead of `Json` |
| `n08-asfollower-typo.ts` | reject | refused (`search`) | Unknown collection name in `asFollower(..., { collections: ["typo_not_names"] })` |
| `n08b-asfollower-lazy-in-collections.ts` | reject | refused (`search`) | Lazy collection name placed in `asFollower` `collections` instead of `lazies` |
| `n08c-asfollower-wrong-lazy-type.ts` | reject | refused (`search`) | `asFollower` `lazies` factory returning mismatched `LazyCollection<K, V>` |
| `n08d-asfollower-missing-eager.ts` | reject | refused (`search`) | `asFollower` `collections` omitting an eager shared collection |
| `n08e-asfollower-empty-collections.ts` | reject | refused (`search`) | `asFollower` with `collections: []` on a service with an eager shared collection |
| `n08f-asfollower-sentinel-bypass.ts` | reject | refused (`search`) | Passing `missingEagerCollections: "ages"` cannot bypass the uninhabited branded `FollowerCoverage` sentinel |
| `n09-default-inputdef-to-narrow.ts` | pass (method bivariance) | refused (`search`) | Default `new InputDefinition()` (`Json`) flowing into narrow `Resource` |
| `n09b-explicit-json-inputdef-to-narrow.ts` | pass (method bivariance) | refused (`search`) | Explicit `new InputDefinition<Json, Json>()` flowing into narrow `Resource` |
| `n10-open-resources-param.ts` | pass (TS 5.7/5.8; reject 6.0+) | refused (`search`) | Open record parameter passed as `resources` (may hold extra non-`ResourceClass` keys at runtime) |
| `n11-custom-abstract-inputdef.ts` | reject | refused (`search`) | Non-`InputDefinition` `AbstractInputDefinition` maps to `AbstractEagerCollection` (not `never`) in `InputCollections` |
| `n12-brand-fake.ts` | reject | refused (`search`) | Structural look-alike objects assigned to the nominal `AbstractInputDefinition` / `AbstractEagerCollection` / `AbstractLazyCollection` |
| `n12b-brand-subclass.ts` | reject | refused (`source`) | External subclasses of `AbstractEagerCollection` / `AbstractLazyCollection` / `AbstractInputDefinition` rejected via sealed protected constructors |
| `n13-array-inputs.ts` | reject | refused (`source`) | Array-typed `InputDefs` (`inputs: [...]`) or `ResourceInputs` rejected via `keyof T & string` |
| `n14-optional-collection.ts` | reject | refused (`source`) | Optional `?` properties in `InputDefs` or `ResourceInputs` rejected via `keyof T & string` |
