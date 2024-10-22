import { run, type ModuleInit } from "std";
import type {
  CollectionUpdate,
  Entry,
  ReactiveResponse,
  SkipService,
  SubscriptionID,
  TJSON,
  Watermark,
} from "./skipruntime_api.js";
import type { ServiceInstanceFactory } from "./internals/skipruntime_module.js";

import { init as runtimeInit } from "std/runtime.js";
import { init as posixInit } from "std/posix.js";
import { init as skjsonInit } from "skjson";
import { init as skruntimeInit } from "./internals/skipruntime_module.js";

const modules: ModuleInit[] = [
  runtimeInit,
  posixInit,
  skjsonInit,
  skruntimeInit,
];

async function wasmUrl(): Promise<URL> {
  //@ts-expect-error  ImportMeta is incomplete
  if (import.meta.env || import.meta.webpack) {
    /* eslint-disable @typescript-eslint/no-unsafe-return */
    //@ts-expect-error  Cannot find module './skstore.wasm?url' or its corresponding type declarations.
    return await import("./libskip-runtime-ts.wasm?url");
    /* eslint-enable @typescript-eslint/no-unsafe-return */
  }

  return new URL("./libskip-runtime-ts.wasm", import.meta.url);
}

export async function initService(
  service: SkipService,
): Promise<ServiceInstance> {
  const data = await run(wasmUrl, modules, []);
  const factory = data.environment.shared.get(
    "ServiceInstanceFactory",
  ) as ServiceInstanceFactory;
  return factory.initService(service);
}

/**
 * An `ServiceInstance` is the result of `initService`
 * It gives access to a service's reactively computed resources, and allows to manage sessions or shut down the service.
 */
export interface ServiceInstance {
  /**
   * Creates if not exists and get all current values of specified resource
   * @param resource - the resource name corresponding to a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current values of the corresponding resource with reactive responce token to allow subscription
   */
  getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): { values: Entry<K, V>[]; reactive?: ReactiveResponse };

  /**
   * Creates specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The reactive responce token to allow subscription
   */
  createResource(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): ReactiveResponse;

  /**
   * Creates if not exists and get the current value of specified key in specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param key - the key of value to return
   * @param reactiveAuth - the client user Skip session authentification
   * @returns The current value of specified key in the corresponding resource
   */
  getOne<V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    key: string | number,
    reactiveAuth?: Uint8Array,
  ): V[];

  /**
   * Close the specified resource
   * @param resource - the resource name correspond to the a key in remotes field of SkipService
   * @param params - the parameters of the resource used to build the resource with the corresponding constructor specified in remotes field of SkipService
   * @param reactiveAuth - the client user Skip session authentification
   */
  closeResource(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): void;

  /**
   * Close of the resources corresponding the specified reactiveAuth
   * @param reactiveAuth - the client user Skip session authentification
   */
  closeSession(reactiveAuth?: Uint8Array): void;

  /**
   * Subscribe to a reactive ressource according a given reactive response
   * @param reactiveId - the reactive response collection
   * @param since - the reactive response watermark
   * @param f - the callback called on collection updates
   * @param reactiveAuth The client user Skip session authentification corresponding to the reactive response
   * @returns The subcription identifier
   */
  subscribe<K extends TJSON, V extends TJSON>(
    reactiveId: string,
    since: Watermark,
    f: (update: CollectionUpdate<K, V>) => void,
    reactiveAuth?: Uint8Array,
  ): SubscriptionID;

  /**
   * Unsubscribe to a reactive ressource according a given subcription identifier
   * @param id - the subcription identifier
   */
  unsubscribe(id: SubscriptionID): void;

  /**
   * Update an inout collection
   * @param input - the name of the input collection to update
   * @param values - the values of the input collection to update
   */
  update<K extends TJSON, V extends TJSON>(
    input: string,
    values: Entry<K, V>[],
  ): void;

  /**
   * Close all the resource and shutdown the SkipService
   */
  close(): void;
}
