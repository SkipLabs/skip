import type { Entry, ExternalService, Json } from "@skipruntime/api";

import type { Entrypoint } from "./rest.js";

interface Closable {
  close(): void;
}

export class SkipExternalService implements ExternalService {
  private resources = new Map<string, Closable>();

  constructor(private url: string) {}

  static direct(entrypoint: Entrypoint): SkipExternalService {
    let url = `http://${entrypoint.host}:${entrypoint.port.toString()}`;
    if (entrypoint.secured)
      url = `https://${entrypoint.host}:${entrypoint.port.toString()}`;
    return new SkipExternalService(url);
  }

  subscribe(
    resource: string,
    params: Record<string, string>,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      // FIXME: What is `error()` used for?
      error: (error: Json) => void;
      // FIXME: What is `loading()` used for?
      loading: () => void;
    },
  ): void {
    // TODO Manage Status
    const evSource = new EventSource(
      `${this.url}?${new URLSearchParams(params)}`,
    );
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
  }

  unsubscribe(resource: string, params: Record<string, string>) {
    const closable = this.resources.get(this.toId(resource, params));
    if (closable) closable.close();
  }

  shutdown(): void {
    for (const res of this.resources.values()) {
      res.close();
    }
  }

  private toId(resource: string, params: Record<string, string>): string {
    // TODO: This is equivalent to `querystring.encode(params, ',', ':')`.
    const strparams: string[] = [];
    for (const key of Object.keys(params).sort()) {
      strparams.push(`${key}:${params[key]}`);
    }
    return `${resource}[${strparams.join(",")}]`;
  }
}
