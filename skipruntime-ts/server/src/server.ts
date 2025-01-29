/**
 * This package provides functionality to take a reactive service definition and spawn the http servers to expose it through HTTP/SSE.
 *
 * @packageDocumentation
 */

import { type SkipService, ServiceInstance } from "@skipruntime/core";
import { controlService, streamingService } from "./rest.js";

/**
 * A running Skip server.
 */
export type SkipServer = {
  /**
   * Stop accepting new connections, close existing connections, and halt a running service.
   */
  close: () => void;
};

/**
 * Initialize and start a reactive Skip service.
 *
 * Calling `runService` will start a reactive service based on the `service` specification and `options`.
 * The service offers two interfaces over HTTP: a control API on `options.control_port`, and a streaming API on `options.streaming_port`.
 *
 * The service exposes resources and input collections specified by `service: SkipService`.
 * Resources can be read and input collections can be written.
 * Each input _collection_ has a _name_, and associates _keys_ to _values_.
 * Each resource has a _name_ and identifies a collection that associates _keys_ to _values_.
 *
 * The control API responds to the following HTTP requests:
 *
 * - `POST /v1/snapshot/:resource`:
 *   Synchronous read of an entire resource.
 *
 *  The body of the request must be a JSON-encoded value, which is passed as parameters to the resource constructor.
 *  Responds with the current contents of the named `resource` with the given parameters, instantiating the resource if needed.
 *  Data is returned as a JSON-encoded array of key/value entries, with each entry a tuple of the form `[key, [value1, value2, ...]]`.
 *
 * - `POST /v1/snapshot/:resource/lookup`:
 *   Synchronous read of a specific key in a resource.
 *
 *  The body of the request must be a JSON-encoded object with a `key` field and a `params` field.
 *  Responds with the values associated to `key` in the named `resource` with the given parameters, instantiating the resource if needed.
 *  Data is returned as a JSON-encoded array of values.
 *
 * - `PATCH /v1/inputs/:collection`:
 *   Partial write (update only the specified keys) of an input collection.
 *
 *   The `collection` must be the name of one of the service's input collections, that is, one of the keys of the `Inputs` type parameter.
 *   The body of the request must be a JSON-encoded value of type `CollectionUpdate.values`, that is `[Json, Json[]][]`: an array of entries each of which associates a key to an array of its new values.
 *   Updates the named `collection` with the key-values entries in the request body.
 *
 * - `POST /v1/streams/:resource`:
 *   Instantiate a resource and return a UUID to subscribe to updates.
 *
 *   Requires the request to have a `Content-Type: application/json` header.
 *   The body of the request must be a JSON-encoded value, which will be passed as parameters to the resource constructor.
 *   Instantiates the named `resource` with the given parameters and responds with a UUID that can be used to subscribe to updates.
 *
 * - `DELETE /v1/streams/:uuid`:
 *   Destroy a resource instance.
 *
 *   Destroys the resource instance identified by `uuid`.
 *   Under normal circumstances, resource instances are deleted automatically after some period of inactivity; this interface enables immediately deleting live streams under exceptional circumstances.
 *
 * The streaming API responds to the following HTTP requests:
 *
 * - `GET /v1/streams/:uuid`:
 *   Server-sent events endpoint to subscribe to updates of the resource instance represented by the UUID.
 *
 *   Requires the request to have an `Accept: text/event-stream` header.
 *   The `uuid` must have been obtained from a `POST /v1/streams` request, and not yet `DELETE`d.
 *   Provides an HTTP server-sent event stream of updates to the resource identified by `uuid`.
 *   Each event will be a serialization of a `CollectionUpdate` of the form:
 * ```
 *     event: (init | update)\n
 *     id: <watermark>\n
 *     data: <values>\n\n
 * ```
 *
 * @typeParam Inputs - Named collections from which the service computes.
 * @typeParam ResourceInputs - Named collections provided to resource computations.
 * @param service - The SkipService definition to run.
 * @param options - Service configuration options.
 * @param options.control_port - Port on which control service will listen.
 * @param options.streaming_port - Port on which streaming service will listen.
 * @param options.platform - Skip runtime platform to be used to run the service: either `wasm` (the default), `native`, or `auto` (which will prefer `native` if available).
 * @returns Object to manage the running server.
 */
export async function runService(
  service: SkipService,
  options: {
    streaming_port: number;
    control_port: number;
    platform?: "wasm" | "native" | "auto";
  } = {
    streaming_port: 8080,
    control_port: 8081,
    platform: "wasm",
  },
): Promise<SkipServer> {
  let instance: ServiceInstance;

  const initNative = async () => {
    try {
      const runtime = await import("@skipruntime/native");
      return await runtime.initService(service);
    } catch {
      throw new Error(
        'Error loading Skip runtime for specified "native" platform.',
      );
    }
  };

  const initWasm = async () => {
    try {
      const runtime = await import("@skipruntime/wasm");
      return await runtime.initService(service);
    } catch {
      throw new Error(
        'Error loading Skip runtime for specified "wasm" platform.',
      );
    }
  };
  switch (options.platform) {
    case "auto":
      // TODO: investigate and fix "symbol lookup error" when native platform is unavailable
      try {
        instance = await initNative();
      } catch (_e: any) {
        try {
          instance = await initWasm();
        } catch {
          throw new Error(
            "No Skip runtime found; one of `@skipruntime/native` (on a supported platform) or `@skipruntime/wasm` is required.",
          );
        }
      }
      break;
    case "native":
      instance = await initNative();
      break;
    case "wasm":
    default:
      instance = await initWasm();
      break;
  }
  const controlHttpServer = controlService(instance).listen(
    options.control_port,
    () => {
      console.log(
        `Skip control service listening on port ${options.control_port.toString()}`,
      );
    },
  );
  const streamingHttpServer = streamingService(instance).listen(
    options.streaming_port,
    () => {
      console.log(
        `Skip streaming service listening on port ${options.streaming_port.toString()}`,
      );
    },
  );

  return {
    close: () => {
      controlHttpServer.close();
      instance.close();
      streamingHttpServer.close();
    },
  };
}
