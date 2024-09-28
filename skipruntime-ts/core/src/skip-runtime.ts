import { run, type ModuleInit } from "std";
import type { SkipService, Resource } from "./skipruntime_service.js";
import { check } from "./internals/skipruntime_impl.js";
import type {
  SKStore,
  SKStoreFactory,
  TJSON,
  JSONObject,
  Accumulator,
  CallResourceCompute,
  SkipRuntime,
  Entry,
  EntryPoint,
  EagerCollection,
  SkipBuilder,
  ReactiveResponse,
} from "./skipruntime_api.js";
import { runService as runService_ } from "./internals/skipruntime_process.js";
export type { Opaque } from "./internals/skipruntime_module.js";
export { TimedQueue } from "./internals/skipruntime_module.js";
export { runService as initService } from "./skipruntime_runner.js";

export type {
  SKStore,
  TJSON,
  JSONObject,
  Accumulator,
  SkipService,
  Resource,
  SkipRuntime,
  Entry,
  ReactiveResponse,
};

export type {
  AValue,
  Mapper,
  Param,
  RefreshToken,
  EagerCollection,
  NonEmptyIterator,
  LazyCollection,
  LazyCompute,
  AsyncLazyCompute,
  Loadable,
  AsyncLazyCollection,
  EntryPoint,
  ExternalCall,
} from "./skipruntime_api.js";

export { ValueMapper } from "./skipruntime_api.js";
export { Sum, Min, Max } from "./skipruntime_utils.js";

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

export type CreateSKStore = (
  init: (
    skstore: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) => CallResourceCompute,
  inputs: Record<string, [TJSON, TJSON][]>,
  remotes?: Record<string, EntryPoint>,
  tokens?: Record<string, number>,
) => Promise<SkipBuilder>;

export async function createSKStore(
  init: (
    skstore: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) => CallResourceCompute,
  inputs: Record<string, [TJSON, TJSON][]>,
  remotes: Record<string, EntryPoint> = {},
  tokens: Record<string, number> = {},
): Promise<SkipBuilder> {
  const data = await run(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, inputs, remotes, tokens);
}

export function freeze<T>(value: T): T {
  const type = typeof value;
  if (type == "string" || type == "number" || type == "boolean") {
    return value;
  } else if (type == "object") {
    if ((value as any).__sk_frozen) {
      return value;
    } else if (Object.isFrozen(value)) {
      check(value);
      return value;
    } else if (Array.isArray(value)) {
      Object.defineProperty(value, "__sk_frozen", {
        enumerable: false,
        writable: false,
        value: true,
      });
      const length: number = value.length;
      for (let i = 0; i < length; i++) {
        value[i] = freeze(value[i]);
      }
      return Object.freeze(value) as T;
    } else {
      const jso = value as Record<string, any>;
      Object.defineProperty(value, "__sk_frozen", {
        enumerable: false,
        writable: false,
        value: true,
      });
      for (const key of Object.keys(jso)) {
        jso[key] = freeze(jso[key]);
      }
      return Object.freeze(jso) as T;
    }
  } else {
    throw new Error("'" + type + "' cannot be frozen.");
  }
}

export async function runService(service: SkipService, port: number = 443) {
  return runService_(service, createSKStore, port);
}

function toHttp(entrypoint: EntryPoint) {
  if (entrypoint.secured)
    return `https://${entrypoint.host}:${entrypoint.port}`;
  return `http://${entrypoint.host}:${entrypoint.port}`;
}

export async function fetchJSON<V>(
  url: string,
  method: "POST" | "GET" | "PUT" | "PATCH" | "HEAD" | "DELETE" = "GET",
  headers: Record<string, string>,
  data?: TJSON,
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
  const responseJSON = method != "HEAD" ? ((await response.json()) as V) : null;
  if (!response.ok) {
    throw new Error(JSON.stringify(responseJSON));
  }
  return [responseJSON, response.headers];
}

export class SkipRESTRuntime {
  private entrypoint: string;

  constructor(
    entrypoint: EntryPoint = {
      host: "localhost",
      port: 3587,
    },
  ) {
    this.entrypoint = toHttp(entrypoint);
  }

  async getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array | string,
  ): Promise<{ values: Entry<K, V>[]; reactive?: ReactiveResponse }> {
    const qParams = new URLSearchParams(params).toString();
    let header = {};
    if (reactiveAuth) {
      if (typeof reactiveAuth == "string") {
        header = {
          "X-Reactive-Auth": reactiveAuth,
        };
      } else {
        header = {
          "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString(
            "base64",
          ),
        };
      }
    }
    const [optValues, headers] = await fetchJSON<Entry<K, V>[]>(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "GET",
      header,
    );
    const strReactiveResponse = headers.get("x-reactive-response");
    const reactive = strReactiveResponse
      ? (JSON.parse(strReactiveResponse) as ReactiveResponse)
      : undefined;
    const values = optValues ?? [];
    return reactive ? { values, reactive } : { values };
  }

  async head(
    resource: string,
    params: Record<string, string>,
    reactiveAuth: Uint8Array | string,
  ): Promise<ReactiveResponse> {
    const qParams = new URLSearchParams(params).toString();
    const header = this.header(reactiveAuth);
    const [_data, headers] = await fetchJSON(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "HEAD",
      header,
    );
    const reactiveResponse = headers.get("x-reactive-response");
    if (!reactiveResponse)
      throw new Error("Reactive response must be suplied.");
    return JSON.parse(reactiveResponse) as ReactiveResponse;
  }

  async getOne<V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    key: string,
    reactiveAuth?: Uint8Array | string,
  ): Promise<V[]> {
    const qParams = new URLSearchParams(params).toString();
    const header = this.header(reactiveAuth);
    const [data, _headers] = await fetchJSON<V[]>(
      `${this.entrypoint}/v1/${resource}/${key}?${qParams}`,
      "GET",
      header,
    );
    return data ?? [];
  }

  async put<V extends TJSON>(
    collection: string,
    key: string,
    value: V[],
  ): Promise<void> {
    await fetchJSON(
      `${this.entrypoint}/v1/${collection}/${key}`,
      "PUT",
      {},
      value,
    );
  }

  async patch<K extends TJSON, V extends TJSON>(
    collection: string,
    values: Entry<K, V>[],
  ): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/${collection}`, "PATCH", {}, values);
  }

  async delete(collection: string, key: string): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/${collection}/${key}`, "DELETE", {});
  }

  private header(reactiveAuth?: Uint8Array | string): Record<string, string> {
    if (reactiveAuth) {
      if (typeof reactiveAuth == "string") {
        return {
          "X-Reactive-Auth": reactiveAuth,
        };
      } else {
        return {
          "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString(
            "base64",
          ),
        };
      }
    }
    return {};
  }
}
