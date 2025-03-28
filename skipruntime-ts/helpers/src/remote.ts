// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";

import type { Entry, ExternalService, Json } from "@skipruntime/core";

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
      evSource.addEventListener("error", (e) => {
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
