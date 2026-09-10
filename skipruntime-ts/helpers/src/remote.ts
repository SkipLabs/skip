// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import { EventSource } from "eventsource";

import {
  type AnySkipService,
  type AbstractEagerCollection,
  type AbstractLazyCollection,
  type Entry,
  type ExternalService,
  type Json,
  type NamedEagerCollections,
  type Resource,
  type SharedCollections,
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
export function asLeader(service: AnySkipService): AnySkipService {
  //TODO: add mechanism to split externals between leader/follower
  return {
    ...service,
    resources: { leader: LeaderResource },
  };
}

/**
 * Run a `SkipService` as a *follower* in a leader-follower topology.
 *
 * Instead of running a `service` on one machine, it can be distributed across multiple in a leader-follower architecture, with one "leader" maintaining the shared computation graph and one or more "followers" across which client-requested resource instances are distributed.
 *
 * The two kinds of shared collection are obtained differently. Eager collections, named in `collections`, are *mirrored* from the leader: the leader maintains them and streams their updates to the follower. Lazy collections cannot be mirrored, since they hold no maintained state to stream; each is instead *rebuilt locally* by the follower, `lazies` mapping its shared name to a function which, given the follower's `Context`, produces the corresponding lazy collection. Together, the two are expected to cover the `ResourceInputs` of `service`.
 *
 * @returns The *follower* component to run `service` in such a configuration.
 */
export function asFollower(
  service: AnySkipService,
  leader: {
    leader: { host: string; streaming_port: number; control_port: number };
    collections: string[];
    lazies?: {
      [name: string]: (context: Context) => AbstractLazyCollection;
    };
  },
): AnySkipService {
  return {
    ...service,
    inputs: {},
    externalServices: {
      ...service.externalServices,
      __skip_leader: SkipExternalService.direct(leader.leader),
    },
    createGraph(
      _inputs: NamedEagerCollections,
      context: Context,
    ): SharedCollections {
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
        for (const [collection, lCollectionGetter] of Object.entries(
          leader.lazies,
        )) {
          mirroredCollections[collection] = lCollectionGetter(context);
        }
      }
      return mirroredCollections;
    },
  };
}
