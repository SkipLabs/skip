// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import { EventSource } from "eventsource";

import {
  type AllInputDefs,
  type AllSharedCollections,
  type AbstractEagerCollection,
  type AbstractLazyCollection,
  type Entry,
  type ExternalService,
  type Json,
  type Resource,
  type SharedCollections,
  type SkipService,
  type Context,
  EagerCollectionImpl,
} from "@skipruntime/core";
import { SkipError } from "@skipruntime/core";

import type { Entrypoint } from "./rest.js";

interface Closable {
  close(): void;
}

/**
 * An external Skip reactive service.
 *
 * `SkipExternalService` provides an implementation of `ExternalService` for an external Skip service.
 */
export class SkipExternalService implements ExternalService {
  private readonly resources = new Map<string, Closable>();

  /**
   * @param url - URL to use for the service's streaming interface.
   * @param control_url - URL to use for the service's control interface.
   */
  constructor(
    private readonly url: string,
    private readonly control_url: string,
  ) {}

  /**
   * Constructor accepting an `Entrypoint`.
   *
   * @param entrypoint - The entry point for the external Skip service.
   * @returns An `ExternalService` to interact with the service running at `entrypoint`.
   */
  // TODO: Support Skip external services going through a gateway.
  static direct(entrypoint: Entrypoint): SkipExternalService {
    let url = `http://${entrypoint.host}:${entrypoint.streaming_port.toString()}`;
    let control_url = `http://${entrypoint.host}:${entrypoint.control_port.toString()}`;
    if (entrypoint.secured) {
      url = `https://${entrypoint.host}:${entrypoint.streaming_port.toString()}`;
      control_url = `https://${entrypoint.host}:${entrypoint.control_port.toString()}`;
    }
    return new SkipExternalService(url, control_url);
  }

  async subscribe(
    instance: string,
    resource: string,
    params: Json,
    callbacks: {
      update: (
        updates: Entry<Json, Json>[],
        isInitial: boolean,
      ) => Promise<void>;
      error: (error: unknown) => void;
    },
  ): Promise<void> {
    const resp = await fetch(`${this.control_url}/v1/streams/${resource}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    });
    const uuid = await resp.text();
    return new Promise<void>((resolve, reject) => {
      const evSource = new EventSource(`${this.url}/v1/streams/${uuid}`);
      evSource.addEventListener("open", () => {
        this.resources.set(instance, evSource);
        resolve();
      });
      evSource.addEventListener("init", (e: MessageEvent<string>) => {
        const updates = JSON.parse(e.data) as Entry<Json, Json>[];
        callbacks.update(updates, true).catch(console.error);
      });
      evSource.addEventListener("update", (e: MessageEvent<string>) => {
        const updates = JSON.parse(e.data) as Entry<Json, Json>[];
        callbacks.update(updates, false).catch(console.error);
      });
      evSource.addEventListener("error", (e: MessageEvent<unknown>) => {
        if (this.resources.has(instance)) callbacks.error(e.data);
        else reject(e.data as Error);
      });
    });
  }

  unsubscribe(instance: string) {
    const closable = this.resources.get(instance);
    if (closable) {
      closable.close();
      this.resources.delete(instance);
    }
  }

  shutdown(): Promise<void> {
    for (const res of this.resources.values()) {
      res.close();
    }
    return Promise.resolve();
  }
}

class LeaderResource implements Resource<SharedCollections> {
  private collection: string;

  constructor(param: Json) {
    if (typeof param == "string") this.collection = param;
    else
      throw new SkipError(
        "Followers must specify a shared collection to mirror from leader.",
      );
  }

  instantiate(collections: SharedCollections): AbstractEagerCollection {
    if (this.collection in collections) {
      const maybeEagerCollection = collections[this.collection]!;
      if (maybeEagerCollection instanceof EagerCollectionImpl)
        return maybeEagerCollection;
      throw new SkipError(
        `Unknown eager shared collection in leader: ${this.collection}`,
      );
    }
    throw new SkipError(
      `Unknown shared collection in leader: ${this.collection}`,
    );
  }
}

/**
 * Run a `SkipService` as the *leader* in a leader-follower topology.
 *
 * Instead of running a `service` on one machine, it can be distributed across multiple in a leader-follower architecture, with one "leader" maintaining the shared computation graph and one or more "followers" across which client-requested resource instances are distributed.
 *
 * @returns The *leader* component to run `service` in such a configuration.
 */
export function asLeader<
  InputDefs extends AllInputDefs<InputDefs>,
  ResourceInputs extends AllSharedCollections<ResourceInputs>,
>(
  service: SkipService<InputDefs, ResourceInputs>,
): SkipService<InputDefs, SharedCollections> {
  //TODO: add mechanism to split externals between leader/follower
  return {
    inputs: service.inputs,
    ...(service.externalServices !== undefined
      ? { externalServices: service.externalServices }
      : {}),
    resources: { leader: LeaderResource },
    createGraph: (inputs, ctx) =>
      service.createGraph(inputs, ctx) as unknown as SharedCollections,
  };
}

/**
 * Keys of `T` whose values are definitely eager collections.
 *
 * The `[T[K]] extends [never]` guard prevents `never`-valued index signatures
 * (such as `Record<string, never>`) from classifying `string` as an eager key,
 * since `never extends AbstractEagerCollection` holds vacuously.
 *
 * Keys whose value type is a union of eager and lazy collections (e.g.
 * `SharedCollections`) or optional (`| undefined`) do not satisfy
 * `extends AbstractEagerCollection` and are excluded from both `EagerKeys` and
 * `LazyKeys`.
 */
type EagerKeys<T> = {
  [K in keyof T & string]: [T[K]] extends [never]
    ? never
    : T[K] extends AbstractEagerCollection
      ? K
      : never;
}[keyof T & string];

/**
 * Keys of `T` whose values are definitely lazy collections.
 *
 * Guarded against `never` (e.g. `Record<string, never>`) for the same reason as
 * `EagerKeys`; union eager/lazy or optional keys are similarly excluded.
 */
type LazyKeys<T> = {
  [K in keyof T & string]: [T[K]] extends [never]
    ? never
    : T[K] extends AbstractLazyCollection
      ? K
      : never;
}[keyof T & string];

type FollowerLazies<ResourceInputs> = [LazyKeys<ResourceInputs>] extends [never]
  ? {
      readonly lazies?: { readonly [K in never]: never };
    }
  : {
      readonly lazies: {
        readonly [K in LazyKeys<ResourceInputs>]: (
          context: Context,
        ) => ResourceInputs[K];
      };
    };

/**
 * Uninhabited brand attached to `FollowerCoverage`'s error sentinel so callers
 * cannot bypass the missing-collections check by supplying a dummy
 * `missingEagerCollections` property.
 */
declare const _missingEagerCollectionsBrand: unique symbol;

/**
 * Static exhaustiveness check for `asFollower`'s `collections`: when some eager
 * key of `ResourceInputs` is missing from `Eager`, requires a property whose
 * type names the missing keys inside an uninhabited branded tuple, so the call
 * fails to type-check with an error listing them and no cast-free value can
 * satisfy it.
 */
type FollowerCoverage<ResourceInputs, Eager extends readonly string[]> = [
  Exclude<EagerKeys<ResourceInputs>, Eager[number]>,
] extends [never]
  ? unknown
  : {
      readonly missingEagerCollections: readonly [
        typeof _missingEagerCollectionsBrand,
        Exclude<EagerKeys<ResourceInputs>, Eager[number]>,
      ];
    };

/**
 * Run a `SkipService` as a *follower* in a leader-follower topology.
 *
 * Instead of running a `service` on one machine, it can be distributed across multiple in a leader-follower architecture, with one "leader" maintaining the shared computation graph and one or more "followers" across which client-requested resource instances are distributed.
 *
 * The two kinds of shared collection are obtained differently. Eager collections, named in `collections`, are *mirrored* from the leader: the leader maintains them and streams their updates to the follower. Lazy collections cannot be mirrored, since they hold no maintained state to stream; each is instead *rebuilt locally* by the follower, `lazies` mapping its shared name to a function which, given the follower's `Context`, produces the corresponding lazy collection. Together, the two are expected to cover the `ResourceInputs` of `service`.
 *
 * @remarks
 * `collections` is checked statically to contain only eager collection names from `ResourceInputs` and, when given as a literal, to list every one of them (a missing name is reported as a `missingEagerCollections` type error naming it); `lazies` must provide a typed factory for every lazy collection in `ResourceInputs`. Each property of `ResourceInputs` must have a definite eager or lazy collection type: keys whose value type is a union of eager and lazy collections (including erased `SharedCollections`) or optional (`| undefined`) are excluded from both `collections` and `lazies` and therefore cannot be mirrored or rebuilt by `asFollower`. At runtime, `asFollower` throws a `SkipError` if a name appears in both `collections` and `lazies` or a `lazies` entry is not a function. Since `ResourceInputs` is a compile-time type only, coverage cannot be re-checked at runtime for non-literal `collections`, and the follower trusts that the leader serves mirrored collections matching their key/value types.
 *
 * @returns The *follower* component to run `service` in such a configuration.
 */
export function asFollower<
  InputDefs extends AllInputDefs<InputDefs>,
  ResourceInputs extends AllSharedCollections<ResourceInputs>,
  const Eager extends readonly EagerKeys<ResourceInputs>[],
>(
  service: SkipService<InputDefs, ResourceInputs>,
  leader: {
    readonly leader: {
      host: string;
      streaming_port: number;
      control_port: number;
    };
    readonly collections: Eager;
  } & FollowerLazies<ResourceInputs> &
    FollowerCoverage<ResourceInputs, Eager>,
): SkipService<Record<string, never>, ResourceInputs> {
  checkFollowerConfig(leader.collections, leader.lazies);
  return {
    inputs: {},
    externalServices: {
      ...service.externalServices,
      __skip_leader: SkipExternalService.direct(leader.leader),
    },
    resources: service.resources,
    createGraph: (_inputs, context: Context): ResourceInputs => {
      const mirroredCollections: {
        [name: string]: AbstractEagerCollection | AbstractLazyCollection;
      } = {};
      for (const collection of leader.collections) {
        mirroredCollections[collection] = context.useExternalResource({
          service: "__skip_leader",
          identifier: "leader",
          params: collection,
        });
      }
      if (leader.lazies) {
        const lazies = leader.lazies as Readonly<
          Record<
            string,
            ((context: Context) => AbstractLazyCollection) | undefined
          >
        >;
        for (const [collection, lCollectionGetter] of Object.entries(lazies)) {
          if (lCollectionGetter) {
            mirroredCollections[collection] = lCollectionGetter(context);
          }
        }
      }
      // The follower trusts the leader's runtime collection types (and that
      // `collections` covers all eager keys of `ResourceInputs`).
      return mirroredCollections as unknown as ResourceInputs;
    },
  };
}

/**
 * Runtime validation of the parts of `asFollower`'s configuration that can be
 * checked without the (compile-time only) `ResourceInputs` type.
 */
function checkFollowerConfig(
  collections: readonly string[],
  lazies: { readonly [name: string]: unknown } | undefined,
): void {
  if (lazies === undefined) return;
  const eager = new Set(collections);
  const both: string[] = [];
  const notFunctions: string[] = [];
  for (const [name, factory] of Object.entries(lazies)) {
    if (eager.has(name)) both.push(name);
    if (factory !== undefined && typeof factory !== "function")
      notFunctions.push(name);
  }
  if (both.length > 0)
    throw new SkipError(
      `asFollower: shared collection(s) listed in both \`collections\` and \`lazies\`: ${both.join(", ")}.`,
    );
  if (notFunctions.length > 0)
    throw new SkipError(
      `asFollower: \`lazies\` entries must be functions producing a lazy collection: ${notFunctions.join(", ")}.`,
    );
}
