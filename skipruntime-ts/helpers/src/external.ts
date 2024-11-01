import type { Entry, ExternalSupplier, TJSON } from "@skipruntime/api";
import { fetchJSON } from "./rest.js";

export interface ExternalResource {
  open(
    params: Record<string, string | number>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ): void;

  close(
    params: Record<string, string | number>,
    reactiveAuth?: Uint8Array,
  ): void;
}

export class ExternalService implements ExternalSupplier {
  constructor(private resources: Record<string, ExternalResource>) {}

  subscribe(
    resourceName: string,
    params: Record<string, string | number>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ): void {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new Error(`Unkonwn resource named '${resourceName}'`);
    }
    resource.open(params, callbacks, reactiveAuth);
  }

  unsubscribe(
    resourceName: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ) {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new Error(`Unkonwn resource named '${resourceName}'`);
    }
    resource.close(params, reactiveAuth);
  }

  shutdown(): void {
    return;
  }
}

type Timeout = ReturnType<typeof setInterval>;

export class TimeCollection implements ExternalResource {
  private intervals = new Map<string, Record<string, Timeout>>();

  open(
    params: Record<string, string | number>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ) {
    const time = new Date().getTime();
    const values: Entry<string, number>[] = [];
    for (const name of Object.keys(params)) {
      values.push([name, [time]]);
    }
    callbacks.update(values, true);
    const id = toId(params, reactiveAuth);
    const intervals: Record<string, Timeout> = {};
    for (const [name, duration] of Object.entries(params)) {
      const ms = Number(duration);
      if (ms > 0) {
        intervals[name] = setInterval(() => {
          const newvalue: Entry<TJSON, TJSON> = [name, [new Date().getTime()]];
          callbacks.update([newvalue], true);
        }, ms);
      }
    }
    this.intervals.set(id, intervals);
  }

  close(
    params: Record<string, string | number>,
    reactiveAuth?: Uint8Array,
  ): void {
    const intervals = this.intervals.get(toId(params, reactiveAuth));
    if (intervals != null) {
      for (const interval of Object.values(intervals)) {
        clearInterval(interval);
      }
    }
  }
}

export class Polled<S extends TJSON, K extends TJSON, V extends TJSON>
  implements ExternalResource
{
  private intervals = new Map<string, number | object>();

  constructor(
    private url: string,
    private duration: number,
    private conv: (data: S) => Entry<K, V>[],
  ) {}

  open(
    params: Record<string, string | number>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ): void {
    this.close(params, reactiveAuth);
    const querieParams: Record<string, string> = {};
    for (const [key, value] of Object.entries(params)) {
      querieParams[key] = value.toString();
    }
    const strParams = new URLSearchParams(querieParams).toString();
    const url = `${this.url}?${strParams}`;
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
    this.intervals.set(
      toId(params, reactiveAuth),
      setInterval(call, this.duration),
    );
  }

  close(
    params: Record<string, string | number>,
    reactiveAuth?: Uint8Array,
  ): void {
    const interval = this.intervals.get(toId(params, reactiveAuth));
    if (interval) {
      clearInterval(interval as number);
    }
  }
}

function toId(
  params: Record<string, string | number>,
  reactiveAuth?: Uint8Array,
): string {
  const strparams = Object.entries(params)
    .map(([key, value]) => `${key}:${value.toString()}`)
    .sort();
  const hex = reactiveAuth ? Buffer.from(reactiveAuth).toString("hex") : "";
  return `[${strparams.join(",")}]${hex}`;
}
