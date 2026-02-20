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
      if (value === undefined) continue;
      if (typeof value == "object") queryParams[key] = JSON.stringify(value);
      else queryParams[key] = value.toString();
    }
    return `?${new URLSearchParams(queryParams).toString()}`;
  } else return `?params=${JSON.stringify(params)}`;
}

/**
 * Description of an external HTTP endpoint and how to poll it.
 *
 * The URL of the external resource is formed by appending the given base `url` and the result of `encodeParams(params)` where `params` are the parameters provided to [`Context#useExternalResource`](https://skiplabs.io/docs/api/core/interfaces/Context#useexternalresource)
 */
export interface PolledHTTPResource {
  /**
   * Base URL of resource to poll.
   */
  url: string;
  /**
   * The interval of time to wait before refreshing the data, given in milliseconds
   */
  interval: number;
  /**
   * Function to convert data received from external resource to `key`-`value` entries.
   */
  conv: (data: Json) => Entry<Json, Json>[];
  /**
   * Function to use to encode params of type `Json` for external resource request.
   *
   * Note that the result of `encodeParams` may contain a `?` separator, but it need not be at the beginning of the returned string, so some parameters can be used in part of the URL preceding the `?`.
   */
  encodeParams?: (params: Json) => string;
  /**
   * Optional parameters: additional `headers` to add to request, and `timeout` for request, in milliseconds. (default 1000ms)
   */
  options?: { headers?: { [header: string]: string }; timeout?: number };
}

/**
 * An external HTTP service that is kept up-to-date by polling.
 *
 * A `PolledExternalService` may be composed of one or more [`PolledHTTPResource`](https://skiplabs.io/docs/api/helpers/interfaces/PolledHTTPResource)s, each of which describes a single endpoint and how to poll it.
 */
export class PolledExternalService implements ExternalService {
  private readonly intervals = new Map<string, Timeout>();

  /**
   * Construct a polled external service.
   *
   * @param resources - Specification(s) of external resource(s) to poll
   */
  constructor(
    private readonly resources: {
      [resource: string]: PolledHTTPResource;
    },
  ) {}

  async subscribe(
    instance: string,
    resourceName: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: unknown) => void;
    },
  ): Promise<void> {
    const resource = this.resources[resourceName];
    if (!resource)
      throw new SkipUnknownResourceError(
        `Unknown resource named '${resourceName}'`,
      );
    const url = `${resource.url}${(resource.encodeParams ?? defaultParamEncoder)(params)}`;
    const call = async (init: boolean) => {
      const [data, _] = await fetchJSON(url, "GET", resource.options ?? {});
      await callbacks.update(resource.conv(data ?? []), init);
    };
    await call(true);
    this.intervals.set(
      instance,
      setInterval(() => {
        call(false).catch((e: unknown) => {
          callbacks.error(e);
          console.error(e);
        });
      }, resource.interval),
    );
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
      clearInterval(interval as Timeout);
      this.intervals.delete(instance);
    }
    return Promise.resolve();
  }
}
