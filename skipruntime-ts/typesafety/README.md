# Skip Service API Type-Safety Probes

Positive and negative TypeScript probes exercising the `SkipService<InputDefs, ResourceInputs>` API (`InputCollections`, `AllInputDefs`, `AllSharedCollections`, `ResourceClass<ResourceInputs, Json>`, `asLeader`, `asFollower`, `initService`, `ServiceInstance`, `Watermark`, and `SubscriptionID`).

This directory is excluded from npm workspaces because the negative probes intentionally violate type safety.

## Positive Probes

All 6 positive probes pass `tsc --strict` and verify under TScert.

| Probe | `tsc --strict` | TScert | Coverage |
| --- | --- | --- | --- |
| `p01-matched-inferred.ts` | pass | verified | Inferred `runService`, pass-through `(ic) => ic`, `Resource.instantiate` and `Mapper.mapEntry` omitting `_context` |
| `p02-derived-graph.ts` | pass | verified | `Mapper`, `LazyCompute`, `Reducer`, runtime-validated `Resource(params: Json)`, and indexed `JsonObject` record |
| `p03-asleader-asfollower.ts` | pass | verified | `asLeader`, `asFollower` with `collections`, and `asFollower` with `lazies` |
| `p04-initservice.ts` | pass | verified | `initService`, `ServiceInstance.subscribe`/`unsubscribe`/`reload`, `Watermark`, and `SubscriptionID` |
| `p05-unannotated-const-service.ts` | pass | verified | Function-local unannotated `const service` passed to `asLeader` and `asFollower` |
| `p05b-unannotated-module-const-service.ts` | pass | verified | Module-level unannotated `const service` passed to `asLeader` and `asFollower` |

## Negative Probes

All 13 negative probes are refused under TScert. Six (`n02`, `n03`, `n04`, `n09`, `n09b`, `n10`) pass `tsc --strict` because of TypeScript's bivariant method checking or structural open-record assignability to readonly index signatures.

| Probe | `tsc --strict` | TScert | Fault |
| --- | --- | --- | --- |
| `n01a-input-type-mismatch-annotated.ts` | reject | refused | `InputDefinition<string, number>` into annotated `EagerCollection<string, string>` `createGraph` |
| `n01b-input-type-mismatch-inferred.ts` | reject | refused | `InputDefinition<string, number>` flowing via `(ic) => ic` into `Resource<{ names: EagerCollection<string, string> }>` |
| `n02-extra-resource-field.ts` | pass (unsound) | refused | Resource reading `c.extra` absent from `createGraph` output |
| `n03-narrow-mapper-on-json.ts` | pass (unsound) | refused | `Mapper<string, number, ...>` applied to `EagerCollection<string, Json>` |
| `n04-narrow-reducer-on-json.ts` | pass (unsound) | refused | `Reducer<number, number>` applied to `EagerCollection<string, Json>` |
| `n05-non-inputdef.ts` | reject | refused | Non-`InputDefinition` value (`42`) in `inputs` |
| `n06-non-collection-output.ts` | reject | refused | Non-collection output (`{ count: 42 }`) with `Resource<{ count: number }>` |
| `n06b-non-collection-output-bare.ts` | reject | refused | Non-collection output (`{ count: 42 }`) with empty `resources` |
| `n07-unvalidated-resource-params.ts` | reject | refused | Resource constructor requiring narrow `{ userId: number }` instead of `Json` |
| `n08-asfollower-typo.ts` | reject | refused | Unknown collection name in `asFollower(..., { collections: ["typo_not_names"] })` |
| `n09-default-inputdef-to-narrow.ts` | pass (unsound) | refused | Default `new InputDefinition()` (`Json`) flowing into narrow `Resource` |
| `n09b-explicit-json-inputdef-to-narrow.ts` | pass (unsound) | refused | Explicit `new InputDefinition<Json, Json>()` flowing into narrow `Resource` |
| `n10-open-resources-param.ts` | pass (unsound) | refused | Open record parameter passed as `resources` (may hold extra non-`ResourceClass` keys at runtime) |
