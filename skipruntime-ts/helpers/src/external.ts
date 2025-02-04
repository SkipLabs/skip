import type { Entry, ExternalService, Json } from "@skipruntime/core";
import { SkipUnknownResourceError } from "@skipruntime/core";
import { fetchJSON } from "./rest.js";

/**
 * Interface required by `GenericExternalService` for external resources.
 */
export interface ExternalResource {
  open(
    instance: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void;

  close(instance: string): void;
}

/**
 * A generic external service providing external resources.
 *
 * `GenericExternalService` provides an implementation of `ExternalService` for external resources by lifting the `open` and `close` operations from `ExternalResource` to the `subscribe` and `unsubscribe` operations required by `ExternalService`.
 */
export class GenericExternalService implements ExternalService {
  private readonly instances = new Map<string, ExternalResource>();

  /**
   * @param resources - Association of resource names to `ExternalResource`s.
   */
  constructor(
    private readonly resources: { [name: string]: ExternalResource },
  ) {}

  subscribe(
    instance: string,
    resourceName: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const resource = this.resources[resourceName] as
      | ExternalResource
      | undefined;
    if (!resource) {
      throw new SkipUnknownResourceError(
        `Unknown resource named '${resourceName}'`,
      );
    }
    this.instances.set(instance, resource);
    resource.open(instance, params, callbacks);
  }

  unsubscribe(instance: string) {
    const resource = this.instances.get(instance);
    if (resource) {
      resource.close(instance);
      this.instances.delete(instance);
    }
  }

  shutdown(): void {
    return;
  }
}

type Timeout = ReturnType<typeof setInterval>;
type Timeouts = { [name: string]: Timeout };

export class TimerResource implements ExternalResource {
  private readonly intervals = new Map<string, { [name: string]: Timeout }>();

  open(
    instance: string,
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
    const intervals: Timeouts = {};
    for (const [name, duration] of Object.entries(params)) {
      const ms = Number(duration);
      if (ms > 0) {
        intervals[name] = setInterval(() => {
          const newvalue: Entry<Json, Json> = [name, [new Date().getTime()]];
          callbacks.update([newvalue], true);
        }, ms);
      }
    }
    this.intervals.set(instance, intervals);
  }

  close(instance: string): void {
    const intervals = this.intervals.get(instance);
    if (intervals != null) {
      for (const interval of Object.values(intervals)) {
        clearInterval(interval);
      }
      this.intervals.delete(instance);
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
    return `?${new URLSearchParams(queryParams).toString()}`;
  } else return `?params=${JSON.stringify(params)}`;
}

/**
 * An external resource that is refreshed at some polling interval.
 *
 * @typeParam S - Type of data received from external resource.
 * @typeParam K - Type of keys.
 * @typeParam V - Type of values.
 */
export class Polled<S extends Json, K extends Json, V extends Json>
  implements ExternalResource
{
  private readonly intervals = new Map<string, Timeout>();

  /**
   * Construct a `Polled` external resource.
   *
   * The URL of the external resource is formed by appending the given base `url` and the result of `encodeParams(params)` where `params` are the parameters provided when instantiating the resource.
   * The default `encodeParams` function produces a query string consisting of a leading `?` followed by the encoding of the `params` given by [URLSearchParams.toString](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/toString) when `params` is an object and otherwise a single key-value pair `params=JSON.stringify(params)`.
   *
   * Note that the result of `encodeParams` contains the `?` separator, but it need not be at the beginning of the returned string, so some parameters can be used in part of the URL preceding the `?`.
   *
   * @param url - HTTP endpoint of external resource to poll.
   * @param duration - Refresh interval, in milliseconds.
   * @param conv - Function to convert data of type `S` received from external resource to `key`-`value` entries.
   * @param encodeParams - Function to use to encode params of type `Json` for external resource request.
   * @param options - Optional parameters.
   * @param options.headers - Additional headers to add to request.
   * @param options.timeout - Timeout for request, in milliseconds. Defaults to 1000ms.
   */
  constructor(
    private readonly url: string,
    private readonly duration: number,
    private readonly conv: (data: S) => Entry<K, V>[],
    private readonly encodeParams: (
      params: Json,
    ) => string = defaultParamEncoder,
    private readonly options?: {
      headers?: { [header: string]: string };
      timeout?: number;
    },
  ) {}

  open(
    instance: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ) {
    const url = `${this.url}${this.encodeParams(params)}`;
    const call = () => {
      callbacks.loading();
      fetchJSON(url, "GET", this.options)
        .then((r) => {
          callbacks.update(this.conv(r[0] as S), true);
        })
        .catch((e: unknown) => {
          callbacks.error(e instanceof Error ? e.message : JSON.stringify(e));
          console.error(e);
        });
    };
    call();
    this.intervals.set(instance, setInterval(call, this.duration));
  }

  close(instance: string): void {
    const interval = this.intervals.get(instance);
    if (interval) {
      clearInterval(interval);
      this.intervals.delete(instance);
    }
  }
}
