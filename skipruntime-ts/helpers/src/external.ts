import type { Entry, ExternalService, Json } from "@skipruntime/api";
import { fetchJSON } from "./rest.js";

export interface ExternalResource {
  open(
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void;

  close(params: Json): void;
}

export class GenericExternalService implements ExternalService {
  constructor(
    private readonly resources: { [name: string]: ExternalResource },
  ) {}

  subscribe(
    resourceName: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new Error(`Unkonwn resource named '${resourceName}'`);
    }
    resource.open(params, callbacks);
  }

  unsubscribe(resourceName: string, params: Json) {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new Error(`Unkonwn resource named '${resourceName}'`);
    }
    resource.close(params);
  }

  shutdown(): void {
    return;
  }
}

type Timeout = ReturnType<typeof setInterval>;

export class TimerResource implements ExternalResource {
  private readonly intervals = new Map<string, { [name: string]: Timeout }>();

  open(
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const time = new Date().getTime();
    const values: Entry<string, number>[] = [];
    for (const name of Object.keys(params)) {
      values.push([name, [time]]);
    }
    callbacks.update(values, true);
    const id = toId(params);
    const intervals: { [name: string]: Timeout } = {};
    for (const [name, duration] of Object.entries(params)) {
      const ms = Number(duration);
      if (ms > 0) {
        intervals[name] = setInterval(() => {
          const newvalue: Entry<Json, Json> = [name, [new Date().getTime()]];
          callbacks.update([newvalue], true);
        }, ms);
      }
    }
    this.intervals.set(id, intervals);
  }

  close(params: Json): void {
    const intervals = this.intervals.get(toId(params));
    if (intervals != null) {
      for (const interval of Object.values(intervals)) {
        clearInterval(interval);
      }
    }
  }
}

function defaultParamEncoder(params: Json): string {
  if (typeof params == "object") {
    const queryParams: { [param: string]: string } = {};
    for (const [key, value] of Object.entries(params)) {
      if (typeof value == "object") queryParams[key] = JSON.stringify(value);
      else queryParams[key] = value.toString();
    }
    return new URLSearchParams(queryParams).toString();
  } else return `params=${JSON.stringify(params)}`;
}

export class Polled<S extends Json, K extends Json, V extends Json>
  implements ExternalResource
{
  private readonly intervals = new Map<string, Timeout>();

  constructor(
    private readonly url: string,
    private readonly duration: number,
    private readonly conv: (data: S) => Entry<K, V>[],
    private readonly encodeParams: (
      params: Json,
    ) => string = defaultParamEncoder,
  ) {}

  open(
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
    this.close(params);
    const url = `${this.url}?${this.encodeParams(params)}`;
    const call = () => {
      callbacks.loading();
      fetchJSON(url, "GET", {})
        .then((r) => {
          callbacks.update(this.conv(r[0] as S), true);
        })
        .catch((e: unknown) => {
          callbacks.error(e instanceof Error ? e.message : JSON.stringify(e));
          console.error(e);
        });
    };
    call();
    this.intervals.set(toId(params), setInterval(call, this.duration));
  }

  close(params: Json): void {
    const interval = this.intervals.get(toId(params));
    if (interval) {
      clearInterval(interval);
    }
  }
}

function toId(params: Json): string {
  if (typeof params == "object") {
    const strparams = Object.entries(params)
      .map(([key, value]) => `${key}:${btoa(JSON.stringify(value))}`)
      .sort();
    return `[${strparams.join(",")}]`;
  } else return btoa(JSON.stringify(params));
}
