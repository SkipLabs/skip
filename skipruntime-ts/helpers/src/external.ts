import type { Entry, ExternalService, Json } from "@skipruntime/core";
import { SkipUnknownResourceError } from "@skipruntime/core";
import { fetchJSON } from "./rest.js";

type Timeout = ReturnType<typeof setTimeout>;

/**
 * Polling interval specification for a {@link PolledHTTPResource}.
 *
 * May be either a fixed delay in milliseconds, or a function computing the delay (in milliseconds) before the next poll.
 * When given as a function, it is invoked after each poll completes with the resource `params` and the JSON payload returned by the latest poll (or `null` if the response had an empty body or the poll failed).
 * Returning a non-positive, non-finite, or `null` value stops further polling for that subscription instance.
 */
export type PollingInterval =
  | number
  | ((params: Json, lastData: Json | null) => number | null);

type SubscriptionState = {
  timer: Timeout | null;
  active: boolean;
};

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
   * Delay before refreshing the data, in milliseconds, or a function returning the next delay in milliseconds (or `null` / non-positive / non-finite to stop polling).
   */
  interval: PollingInterval;
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
  private readonly subscriptions = new Map<string, SubscriptionState>();

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
    this.unsubscribe(instance);
    const state: SubscriptionState = { timer: null, active: true };
    this.subscriptions.set(instance, state);

    const url = `${resource.url}${(resource.encodeParams ?? defaultParamEncoder)(params)}`;
    const call = async (init: boolean): Promise<Json | null> => {
      const [data, _] = await fetchJSON(url, "GET", resource.options ?? {});
      if (!state.active) return null;
      await callbacks.update(resource.conv(data ?? []), init);
      return data;
    };

    const scheduleNext = (lastData: Json | null) => {
      if (!state.active) return;
      let delay: number | null;
      try {
        delay =
          typeof resource.interval === "function"
            ? resource.interval(params, lastData)
            : resource.interval;
      } catch (e: unknown) {
        callbacks.error(e);
        console.error(e);
        if (this.subscriptions.get(instance) === state) {
          this.subscriptions.delete(instance);
        }
        state.active = false;
        return;
      }
      if (delay === null || !Number.isFinite(delay) || delay <= 0) {
        if (this.subscriptions.get(instance) === state) {
          this.subscriptions.delete(instance);
        }
        state.active = false;
        return;
      }
      state.timer = setTimeout(() => {
        state.timer = null;
        if (!state.active) return;
        call(false)
          .then((data) => {
            scheduleNext(data);
          })
          .catch((e: unknown) => {
            if (!state.active) return;
            callbacks.error(e);
            console.error(e);
            scheduleNext(null);
          });
      }, delay);
    };

    let initialData: Json | null;
    try {
      initialData = await call(true);
    } catch (e: unknown) {
      if (this.subscriptions.get(instance) === state) {
        this.subscriptions.delete(instance);
      }
      state.active = false;
      throw e;
    }
    scheduleNext(initialData);
  }

  unsubscribe(instance: string): void {
    const state = this.subscriptions.get(instance);
    if (state) {
      state.active = false;
      if (state.timer !== null) {
        clearTimeout(state.timer);
        state.timer = null;
      }
      this.subscriptions.delete(instance);
    }
  }

  shutdown(): Promise<void> {
    for (const [instance, state] of this.subscriptions.entries()) {
      state.active = false;
      if (state.timer !== null) {
        clearTimeout(state.timer);
        state.timer = null;
      }
      this.subscriptions.delete(instance);
    }
    return Promise.resolve();
  }
}
