// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";

import type { Entry, ExternalService, Json } from "@skipruntime/api";

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
    fetch(`${this.control_url}/v1/streams`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        resource,
        params,
      }),
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
        this.resources.set(this.toId(resource, params), evSource);
      })
      .catch((e: unknown) => {
        console.log(e);
      });
  }

  unsubscribe(resource: string, params: Json) {
    const closable = this.resources.get(this.toId(resource, params));
    if (closable) closable.close();
  }

  shutdown(): void {
    for (const res of this.resources.values()) {
      res.close();
    }
  }

  private toId(resource: string, params: Json): string {
    if (typeof params == "object") {
      const strparams = Object.entries(params)
        .map(([key, value]) => `${key}:${btoa(JSON.stringify(value))}`)
        .sort();
      return `${resource}[${strparams.join(",")}]`;
    } else return `${resource}[${btoa(JSON.stringify(params))}]`;
  }
}
