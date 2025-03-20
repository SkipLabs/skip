import type { Entry, ExternalService, Json } from "@skipruntime/core";
import { SkipUnknownResourceError } from "@skipruntime/core";
import { fetchJSON } from "./rest.js";


type Timeout = ReturnType<typeof setInterval>;

/**
 * Encode params for external resource request.
 *
 * Produces a query string consisting of a leading `?` followed by the encoding of the `params` given by [URLSearchParams.toString](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/toString) when `params` is an object and otherwise a single key-value pair `params=JSON.stringify(params)`.
 *
 * @param params - Resource parameters.
 * @returns Query string.
 */
export function defaultParamEncoder(params: Json): string {
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
 * An external service that is refreshed at some polling interval.
 *
 */
export class PolledExternalService implements ExternalService {
  private readonly intervals = new Map<string, Timeout>();

  /**
   * Construct a polled external service.
   *
   * The URL of the external service is formed by appending the given base `url` and the result of `encodeParams(params)` where `params` are the parameters provided when instantiating a resource.
   *
   * Note that the result of `encodeParams` contains the `?` separator, but it need not be at the beginning of the returned string, so some parameters can be used in part of the URL preceding the `?`.
   *
   * @param url - HTTP endpoint of external service to poll.
   * @param interval - Refresh interval, in milliseconds.
   * @param conv - Function to convert data received from external resource to `key`-`value` entries.
   * @param encodeParams - Function to use to encode params of type `Json` for external resource request.
   * @param options - Optional parameters.
   * @param options.headers - Additional headers to add to request.
   * @param options.timeout - Timeout for request, in milliseconds. Defaults to 1000ms.
   */
  constructor(
    private readonly resources: {
      [resource: string]: {
        url: string;
        interval: number;
        conv: (data: Json) => Entry<Json, Json>[];
        encodeParams?: (params: Json) => string;
        options?: { headers?: { [header: string]: string }; timeout?: number };
      };
    },
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
    const resource = this.resources[resourceName];
    if (!resource)
      throw new SkipUnknownResourceError(
        `Unknown resource named '${resourceName}'`,
      );

    const url = `${resource.url}${(resource.encodeParams ?? defaultParamEncoder)(params)}`;
    const call = () => {
      callbacks.loading();
      fetchJSON(url, "GET", resource.options ?? {})
        .then((r) => {
          callbacks.update(resource.conv(r[0] ?? []), true);
        })
        .catch((e: unknown) => {
          callbacks.error(e instanceof Error ? e.message : JSON.stringify(e));
          console.error(e);
        });
    };
    call();
    this.intervals.set(instance, setInterval(call, resource.interval));
  }

  unsubscribe(instance: string): void {
    const interval = this.intervals.get(instance);
    if (interval) {
      clearInterval(interval);
      this.intervals.delete(instance);
    }
  }
  shutdown(): Promise<void> {
    for (const [instance, interval] of Object.entries(this.intervals)) {
      clearInterval(interval);
      this.intervals.delete(instance);
    }
    return Promise.resolve();
  }
}
