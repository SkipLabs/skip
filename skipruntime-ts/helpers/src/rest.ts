import type { Json, Entry } from "@skipruntime/core";
import { SkipNonUniqueValueError, SkipFetchError } from "@skipruntime/core";

/**
 * An entry point of a Skip reactive service.
 *
 * URLs for the service's control and streaming APIs can be constructed from an `Entrypoint`.
 */
export type Entrypoint = {
  /**
   * Hostname of the service.
   */
  host: string;

  /**
   * Port to use for the service's streaming interface.
   */
  streaming_port: number;

  /**
   * Port to use for the service's control interface.
   */
  control_port: number;

  /**
   * Flag that when set indicates that https should be used instead of http.
   */
  secured?: boolean;
};

function toHttp(entrypoint: Entrypoint) {
  if (entrypoint.secured)
    return `https://${entrypoint.host}:${entrypoint.control_port}`;
  return `http://${entrypoint.host}:${entrypoint.control_port}`;
}

/**
 * Perform an HTTP fetch where input and output data is `Json`.
 *
 * @typeParam V - Type response is *assumed* to have.
 * @param url - URL from which to fetch.
 * @param method - HTTP method of request.
 * @param options - Optional parameters.
 * @param options.headers - Additional headers to add to request.
 * @param options.body - Data to convert to JSON and send in request body.
 * @param options.timeout - Timeout for request, in milliseconds. Defaults to 1000ms.
 * @returns Response parsed as JSON, and headers.
 */
export async function fetchJSON<V extends Json>(
  url: string,
  method: "POST" | "GET" | "PUT" | "PATCH" | "HEAD" | "DELETE" = "GET",
  options: {
    headers?: { [header: string]: string };
    body?: Json;
    timeout?: number;
  } = {
    headers: {},
    timeout: 1000,
  },
): Promise<[V | null, Headers]> {
  const body = options.body ? JSON.stringify(options.body) : undefined;
  const response = await fetch(url, {
    method,
    body,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      ...options.headers,
    },
    signal: AbortSignal.timeout(options.timeout ?? 1000),
  });
  if (!response.ok) {
    throw new SkipFetchError(`${response.status}: ${response.statusText}`);
  }
  const responseText = await response.text();
  const responseJSON =
    responseText.length > 0 && responseText != response.statusText
      ? JSON.parse(responseText)
      : null;
  return [responseJSON, response.headers];
}

/**
 * Wrapper providing a method-call interface to the Skip service HTTP APIs.
 *
 * Skip services, as started by `runService`, support an HTTP interface for reading from resources and writing to input collections.
 * `SkipServiceBroker` provides a method-call interface to the backing HTTP interface.
 */
export class SkipServiceBroker {
  private readonly entrypoint: string;

  /**
   * Construct a broker for a Skip service at the given entry point.
   *
   * @param entrypoint - Entry point of backing service.
   * @param timeout - Timeout for request, in milliseconds. Defaults to 1000ms.
   * @returns Method-call broker to service.
   */
  constructor(
    entrypoint: Entrypoint = {
      host: "localhost",
      streaming_port: 8080,
      control_port: 8081,
    },
    private timeout?: number,
  ) {
    this.entrypoint = toHttp(entrypoint);
  }

  /**
   * Read the entire contents of a resource.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param resource - Name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`.
   * @param params - Resource instance parameters.
   * @returns All entries in resource.
   */
  async getAll<K extends Json, V extends Json>(
    resource: string,
    params: Json,
  ): Promise<Entry<K, V>[]> {
    const [data, _headers] = await fetchJSON<Entry<K, V>[]>(
      `${this.entrypoint}/v1/snapshot/${resource}`,
      "POST",
      { body: params, timeout: this.timeout },
    );
    return data ?? [];
  }

  /**
   * Read the values a resource associates with a single key.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param resource - Name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`.
   * @param params - Resource instance parameters.
   * @param key - Key to read.
   * @returns The values associated to the key.
   */
  async getArray<K extends Json, V extends Json>(
    resource: string,
    params: Json,
    key: K,
  ): Promise<V[]> {
    const [data, _headers] = await fetchJSON<V[]>(
      `${this.entrypoint}/v1/snapshot/${resource}/lookup`,
      "POST",
      { body: { key, params }, timeout: this.timeout },
    );
    return data ?? [];
  }

  /**
   * Read the single value a resource associates with a key.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param resource - Name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`.
   * @param params - Resource instance parameters.
   * @param key - Key to read.
   * @returns The value associated to the key.
   * @throws `SkipNonUniqueValueError` when the key is associated to either zero or multiple values.
   */
  async getUnique<K extends Json, V extends Json>(
    resource: string,
    params: Json,
    key: K,
  ): Promise<V> {
    return this.getArray<K, V>(resource, params, key).then((values) => {
      if (values.length !== 1 || values[0] === undefined)
        throw new SkipNonUniqueValueError();
      return values[0];
    });
  }

  /**
   * Write multiple entries to a collection.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param collection - Name of the input collection to update, must be a key of the `Inputs` type parameter of the `SkipService` running at `entrypoint`.
   * @param entries - Entries to write.
   * @returns {void}
   */
  async update<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/inputs/${collection}`, "PATCH", {
      body: entries,
      timeout: this.timeout,
    });
  }

  /**
   * Remove all values associated with a key in a collection.
   *
   * @typeParam K - Type of keys.
   * @param collection - Name of the input collection to update, must be a key of the `Inputs` type parameter of the `SkipService` running at `entrypoint`.
   * @param key - Key of entry to delete.
   * @returns {void}
   */
  async deleteKey<K extends Json>(collection: string, key: K): Promise<void> {
    return await this.update(collection, [[key, []]]);
  }

  /**
   * Create a resource instance UUID.
   *
   * @typeParam K - Type of keys.
   * @typeParam V - Type of values.
   * @param resource - Name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`.
   * @param params - Resource instance parameters.
   * @returns UUID that can be used to subscribe to updates to resource instance.
   */
  async getStreamUUID(resource: string, params: Json = {}): Promise<string> {
    const url = `${this.entrypoint}/v1/streams/${resource}`;
    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(params),
      signal: AbortSignal.timeout(this.timeout ?? 1000),
    });
    if (!response.ok) {
      throw new SkipFetchError(
        `Unable to connect to ${url}: ${response.status} - ${response.statusText}`,
      );
    }
    return await response.text();
  }

  /**
   * Destroy a resource instance.
   *
   * Under normal circumstances, resource instances are deleted automatically after some period of inactivity; this method enables immediately deleting live streams under exceptional circumstances.
   *
   * @param uuid - Resource instance UUID.
   * @returns {void}
   */
  async deleteUUID(uuid: string): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/streams/${uuid}`, "DELETE", {
      timeout: this.timeout,
    });
  }
}
