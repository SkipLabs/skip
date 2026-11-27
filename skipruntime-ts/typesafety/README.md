# Skip Service API Type-Safety Probes

Positive and negative TypeScript probes exercising the `SkipService<InputDefs, ResourceInputs>` API (`InputCollections`, `AllInputDefs`, `AllSharedCollections`, `ResourceClass<ResourceInputs, Json>`, `asLeader`, `asFollower`, `initService`, `ServiceInstance`, `Watermark`, and `SubscriptionID`).

This directory is excluded from npm workspaces because the negative probes intentionally violate type safety; `bin/check-ts.sh` runs `npm run typecheck` (`node check.mjs`) here to verify that all positive probes compile cleanly and all required negative probes fail type-checking.

## Positive Probes

All 8 positive probes pass `tsc --strict` (verified on TypeScript 5.7.x; CI also runs against ~5.8.0, ~6.0.0, and ~7.0.0); the 6 probes checked under TScert (an external sound-subtyping verifier, not bundled in this repo) all verify.

Note on `p05`/`p05b`: when defining a service as a standalone unannotated `const service = { ... }` (rather than inline in `runService({ ... })`), TypeScript has no contextual type for `createGraph`, so `createGraph`'s parameter and return types must be annotated explicitly.

| Probe | `tsc --strict` (5.7 / 5.8 / 6.0 / 7.0) | TScert | Coverage |
| --- | --- | --- | --- |
| `p01-matched-inferred.ts` | pass | verified | Inferred `runService`, pass-through `(ic) => ic`, `Resource.instantiate` and `Mapper.mapEntry` omitting `_context` |
| `p02-derived-graph.ts` | pass | verified | `Mapper`, `LazyCompute`, `Reducer`, runtime-validated `Resource(params: Json)`, and indexed `JsonObject` record |
| `p03-asleader-asfollower.ts` | pass | verified | `asLeader`, `asFollower` with `collections`, and `asFollower` with `lazies` |
| `p04-initservice.ts` | pass | verified | `initService`, `ServiceInstance.subscribe`/`unsubscribe`/`reload`, `Watermark`, and `SubscriptionID` |
| `p05-unannotated-const-service.ts` | pass | verified | Function-local unannotated `const service` (explicit `createGraph` param types) passed to `asLeader` and `asFollower` |
| `p05b-unannotated-module-const-service.ts` | pass | verified | Module-level unannotated `const service` (explicit `createGraph` param types) passed to `asLeader` and `asFollower` |
| `p06-collection-named-length.ts` | pass | n/a | Collection legitimately named `length` accepted in `InputDefs` and `ResourceInputs` (arrays rejected via `[Symbol.iterator]?: never`) |
| `p07-asfollower-empty-resource-inputs.ts` | pass | n/a | `asFollower` with `collections: []` on a `SkipService<Record<string, never>, Record<string, never>>` |

## Negative Probes

All 16 negative probes checked under TScert are refused (the 5 probes marked `n/a` below were added after the TScert run). Under `tsc --strict`:
- 20 of 21 are rejected on TypeScript 5.7.x, 5.8.x, 6.0.x, and 7.0.x (enforced by `check.mjs` in `bin/check-ts.sh`).
- `n10-open-resources-param.ts` passes on TypeScript 5.7.x/5.8.x due to structural open-record assignability to readonly index signatures and is rejected on TypeScript 6.0.x/7.0.x and TScert.

| Probe | `tsc` 5.7 / 5.8 | `tsc` 6.0 / 7.0 | TScert | Fault |
| --- | --- | --- | --- | --- |
| `n01a-input-type-mismatch-annotated.ts` | reject | reject | refused | `InputDefinition<string, number>` into annotated `EagerCollection<string, string>` `createGraph` |
| `n01b-input-type-mismatch-inferred.ts` | reject | reject | refused | `InputDefinition<string, number>` flowing via `(ic) => ic` into `Resource<{ names: EagerCollection<string, string> }>` |
| `n02-extra-resource-field.ts` | reject | reject | refused | Resource reading `c.extra` absent from `createGraph` output |
| `n03-narrow-mapper-on-json.ts` | reject | reject | refused | `Mapper<string, number, ...>` applied to `EagerCollection<string, Json>` |
| `n04-narrow-reducer-on-json.ts` | reject | reject | refused | `Reducer<number, number>` applied to `EagerCollection<string, Json>` |
| `n05-non-inputdef.ts` | reject | reject | refused | Non-`InputDefinition` value (`42`) in `inputs` |
| `n06-non-collection-output.ts` | reject | reject | refused | Non-collection output (`{ count: 42 }`) with `Resource<{ count: number }>` |
| `n06b-non-collection-output-bare.ts` | reject | reject | refused | Non-collection output (`{ count: 42 }`) with empty `resources` |
| `n07-unvalidated-resource-params.ts` | reject | reject | refused | Resource constructor requiring narrow `{ userId: number }` instead of `Json` |
| `n08-asfollower-typo.ts` | reject | reject | refused | Unknown collection name in `asFollower(..., { collections: ["typo_not_names"] })` |
| `n08b-asfollower-lazy-in-collections.ts` | reject | reject | refused | Lazy collection name placed in `asFollower` `collections` instead of `lazies` |
| `n08c-asfollower-wrong-lazy-type.ts` | reject | reject | refused | `asFollower` `lazies` factory returning mismatched `LazyCollection<K, V>` |
| `n08d-asfollower-missing-eager.ts` | reject | reject | n/a | `asFollower` `collections` omitting an eager shared collection (error names it via `missingEagerCollections`) |
| `n08e-asfollower-empty-collections.ts` | reject | reject | n/a | `asFollower` with `collections: []` on a service with an eager shared collection |
| `n08f-asfollower-sentinel-bypass.ts` | reject | reject | n/a | Passing `missingEagerCollections: "ages"` cannot bypass the uninhabited branded `FollowerCoverage` sentinel |
| `n09-default-inputdef-to-narrow.ts` | reject | reject | refused | Default `new InputDefinition()` (`Json`) flowing into narrow `Resource` |
| `n09b-explicit-json-inputdef-to-narrow.ts` | reject | reject | refused | Explicit `new InputDefinition<Json, Json>()` flowing into narrow `Resource` |
| `n10-open-resources-param.ts` | pass (unsound) | reject | refused | Open record parameter passed as `resources` (may hold extra non-`ResourceClass` keys at runtime) |
| `n11-custom-abstract-inputdef.ts` | reject | reject | refused | Subclass of `AbstractInputDefinition` must not map to `never` in `InputCollections` |
| `n12-brand-fake.ts` | reject | reject | n/a | Structural look-alike objects (formerly public `__sk_*Brand` fields) assigned to the nominal `AbstractInputDefinition` / `AbstractEagerCollection` / `AbstractLazyCollection` |
| `n13-array-inputs.ts` | reject | reject | n/a | Array-typed `InputDefs` (`inputs: [...]`) or `ResourceInputs` (the runtime builds plain objects keyed by collection name) |
