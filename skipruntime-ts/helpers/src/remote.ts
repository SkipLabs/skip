// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";

import type {
  Context,
  EagerCollection,
  Entry,
  ExternalService,
  Json,
  NamedCollections,
  Resource,
  SkipService,
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

  subscribe(
    instance: string,
    resource: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInitial: boolean) => void;
      // FIXME: What is `error()` used for?
      error: (error: Json) => void;
      // FIXME: What is `loading()` used for?
      loading: () => void;
    },
  ): void {
    // TODO Manage Status
    fetch(`${this.control_url}/v1/streams/${resource}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    })
      .then((resp) => resp.text())
      .then((uuid) => {
        const evSource = new EventSource(`${this.url}/v1/streams/${uuid}`);
        evSource.addEventListener("init", (e: MessageEvent<string>) => {
          const updates = JSON.parse(e.data) as Entry<Json, Json>[];
          callbacks.update(updates, true);
        });
        evSource.addEventListener("update", (e: MessageEvent<string>) => {
          const updates = JSON.parse(e.data) as Entry<Json, Json>[];
          callbacks.update(updates, false);
        });
        evSource.onerror = (e) => {
          console.log(e);
        };
        this.resources.set(instance, evSource);
      })
      .catch((e: unknown) => {
        console.log(e);
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

class LeaderResource implements Resource {
  private collection: string;

  constructor(param: Json) {
    if (typeof param == "string") this.collection = param;
    else
      throw new SkipError(
        "Followers must specify a shared collection to mirror from leader.",
      );
  }

  instantiate(collections: NamedCollections): EagerCollection<Json, Json> {
    if (this.collection in collections) return collections[this.collection]!;
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
export function asLeader(service: SkipService): SkipService {
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
 * @returns The *follower* component to run `service` in such a configuration, given the leader's address and the names of the shared computation graph collections to be mirrored from it (typically the `ResourceInputs` of `service`).
 */
export function asFollower(
  service: SkipService,
  leader: {
    leader: { host: string; streaming_port: number; control_port: number };
    collections: string[];
  },
): SkipService {
  return {
    ...service,
    initialData: {},
    externalServices: {
      ...service.externalServices,
      __skip_leader: SkipExternalService.direct(leader.leader),
    },
    createGraph(_inputs: object, context: Context): NamedCollections {
      const mirroredCollections: NamedCollections = {};
      for (const collection of leader.collections) {
        mirroredCollections[collection] = context.useExternalResource({
          service: "__skip_leader",
          identifier: "leader",
          params: collection,
        });
      }
      return mirroredCollections;
    },
  };
}
