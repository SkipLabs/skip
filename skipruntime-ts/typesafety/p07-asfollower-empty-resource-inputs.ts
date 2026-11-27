import type { SkipService } from "@skipruntime/core";
import { asFollower } from "@skipruntime/helpers";
import { runService, type SkipServer } from "@skipruntime/server";

// A service with `Record<string, never>` `ResourceInputs` has no eager or lazy
// shared collections: `EagerKeys` / `LazyKeys` must guard `[T[K]] extends [never]`
// so `asFollower` with `collections: []` compiles cleanly instead of requiring
// `missingEagerCollections` for `string`.
const emptyService: SkipService<
  Record<string, never>,
  Record<string, never>
> = {
  inputs: {},
  resources: {},
  createGraph: () => ({}),
};

export function startEmptyFollower(): Promise<SkipServer> {
  return runService(
    asFollower(emptyService, {
      leader: { host: "localhost", streaming_port: 8080, control_port: 8081 },
      collections: [],
    }),
  );
}
