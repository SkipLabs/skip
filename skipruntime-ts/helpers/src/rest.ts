import type { Json, Entry } from "@skipruntime/api";
import { NonUniqueValueException } from "@skipruntime/api";

export type Entrypoint = {
  host: string;
  streaming_port: number;
  control_port: number;
  secured?: boolean;
};

function toHttp(entrypoint: Entrypoint) {
  if (entrypoint.secured)
    return `https://${entrypoint.host}:${entrypoint.control_port}`;
  return `http://${entrypoint.host}:${entrypoint.control_port}`;
}

export async function fetchJSON<V extends Json>(
  url: string,
  method: "POST" | "GET" | "PUT" | "PATCH" | "HEAD" | "DELETE" = "GET",
  headers: { [header: string]: string } = {},
  data?: Json,
): Promise<[V | null, Headers]> {
  const body = data ? JSON.stringify(data) : undefined;
  const response = await fetch(url, {
    method,
    body,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      ...headers,
    },
    signal: AbortSignal.timeout(1000),
  });
  if (!response.ok) {
    throw new Error(`${response.status}: ${response.statusText}`);
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
   * @param entrypoint - entry point of backing service
   * @returns - method-call broker to service
   */
  constructor(
    entrypoint: Entrypoint = {
      host: "localhost",
      streaming_port: 8080,
      control_port: 8081,
    },
  ) {
    this.entrypoint = toHttp(entrypoint);
  }

  /**
   * Read the entire contents of a resource.
   *
   * @param resource - name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`
   * @param params - resource instance parameters
   * @returns - all entries in resource
   */
  async getAll<K extends Json, V extends Json>(
    resource: string,
    params: { [param: string]: string },
  ): Promise<Entry<K, V>[]> {
    const qParams = new URLSearchParams(params).toString();
    const [optValues, _headers] = await fetchJSON<Entry<K, V>[]>(
      `${this.entrypoint}/v1/resources/${resource}?${qParams}`,
      "GET",
    );
    const values = optValues ?? [];
    return values;
  }

  /**
   * Read the values a resource associates with a single key.
   * @param resource - name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`
   * @param params - resource instance parameters
   * @param key - key to read
   * @returns - the values associated to the key
   */
  async getArray<V extends Json>(
    resource: string,
    params: { [param: string]: string },
    key: string,
  ): Promise<V[]> {
    const qParams = new URLSearchParams(params).toString();
    const [data, _headers] = await fetchJSON<V[]>(
      `${this.entrypoint}/v1/resources/${resource}/${key}?${qParams}`,
      "GET",
    );
    return data ?? [];
  }

  /**
   * Read the single value a resource associates with a key.
   * @param resource - name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`
   * @param params - resource instance parameters
   * @param key - key to read
   * @returns - the value associated to the key
   * @throws {NonUniqueValueException} when the key is associated to either zero or multiple values
   */
  async getUnique<V extends Json>(
    resource: string,
    params: { [param: string]: string },
    key: string,
  ): Promise<V> {
    return this.getArray<V>(resource, params, key).then((values) => {
      if (values.length !== 1 || values[0] === undefined)
        throw new NonUniqueValueException();
      return values[0];
    });
  }

  /**
   * Write the values for a single key in a collection.
   * @param collection - name of the input collection to update, must be a key of the `Inputs` type parameter of the `SkipService` running at `entrypoint`
   * @param key - key of entry to write
   * @param values - values of entry to write
   * @returns {void}
   */
  async put<K extends Json, V extends Json>(
    collection: string,
    key: K,
    values: V[],
  ): Promise<void> {
    return await this.patch(collection, [[key, values]]);
  }

  /**
   * Write multiple entries to a collection.
   * @param collection - name of the input collection to update, must be a key of the `Inputs` type parameter of the `SkipService` running at `entrypoint`
   * @param entries - entries to write
   * @returns {void}
   */
  async patch<K extends Json, V extends Json>(
    collection: string,
    entries: Entry<K, V>[],
  ): Promise<void> {
    await fetchJSON(
      `${this.entrypoint}/v1/inputs/${collection}`,
      "PATCH",
      {},
      entries,
    );
  }

  /**
   * Remove all values associated with a key in a collection.
   * @param collection - name of the input collection to update, must be a key of the `Inputs` type parameter of the `SkipService` running at `entrypoint`
   * @param key - key of entry to delete
   * @returns {void}
   */
  async deleteKey<K extends Json>(collection: string, key: K): Promise<void> {
    return await this.patch(collection, [[key, []]]);
  }

  /**
   * Create a resource instance UUID.
   * @param resource - name of resource, must be a key of the `resources` field of the `SkipService` running at `entrypoint`
   * @param params - resource instance parameters
   * @returns - UUID that can be used to subscribe to updates to resource instance
   */
  async getStreamUUID(
    resource: string,
    params: { [param: string]: string } = {},
  ): Promise<string> {
    return fetch(`${this.entrypoint}/v1/streams`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource, params }),
    }).then((res) => res.text());
  }

  /**
   * Destroy a resource instance.
   *
   * Under normal circumstances, resource instances are deleted automatically after some period of inactivity; this method enables immediately deleting live streams under exceptional circumstances.
   *
   * @param uuid - resource instance UUID
   * @returns {void}
   */
  async deleteUUID(uuid: string): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/streams/${uuid}`, "DELETE");
  }
}
