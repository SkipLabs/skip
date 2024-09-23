// prettier-ignore
import { runUrl, type ModuleInit } from "#std/sk_types.js";
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
import { runWithRESTServer_ } from "./internals/skipruntime_process.js";
export type { Opaque } from "./internals/skipruntime_module.js";
export { TimedQueue } from "./internals/skipruntime_module.js";
export { runService } from "./skipruntime_runner.js";

export type {
  SKStore,
  TJSON,
  JSONObject,
  Accumulator,
  SkipService,
  Resource,
  SkipRuntime,
  Entry,
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

const modules: ModuleInit[] = [];
/*--MODULES--*/

async function wasmUrl(): Promise<URL> {
  //@ts-expect-error  ImportMeta is incomplete
  if (import.meta.env || import.meta.webpack) {
    /* eslint-disable @typescript-eslint/no-unsafe-return */
    //@ts-expect-error  Cannot find module './skstore.wasm?url' or its corresponding type declarations.
    return await import("./libskip-runtime.wasm?url");
    /* eslint-enable @typescript-eslint/no-unsafe-return */
  }

  return new URL("./libskip-runtime.wasm", import.meta.url);
}

export async function createSKStore(
  init: (
    skstore: SKStore,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) => CallResourceCompute,
  inputs: string[],
  remotes: Record<string, EntryPoint> = {},
  tokens: Record<string, number> = {},
  initLocals?: () => Promise<Record<string, [TJSON, TJSON][]>>,
): Promise<SkipBuilder> {
  const data = await runUrl(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get("SKStore") as SKStoreFactory;
  return factory.runSKStore(init, inputs, remotes, tokens, initLocals);
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

export async function runWithRESTServer(
  service: SkipService,
  options: Record<string, any> = { port: 3587 },
) {
  return runWithRESTServer_(service, createSKStore, options);
}

function toHttp(entrypoint: EntryPoint) {
  if (entrypoint.secured)
    return `https://${entrypoint.host}:${entrypoint.port}`;
  return `http://${entrypoint.host}:${entrypoint.port}`;
}

async function send(
  url: string,
  method: "POST" | "GET" | "PUT" | "PATCH" | "HEAD" | "DELETE" = "GET",
  headers: Record<string, string>,
  data?: TJSON,
) {
  try {
    const body = data ? JSON.stringify(data) : undefined;
    console.log("fetch", url, method, body);
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
    const responseJSON = await response.json();
    if (!response.ok) {
      throw new Error(JSON.stringify(responseJSON));
    }
    return [responseJSON, response.headers];
  } catch (e: any) {
    throw e;
  }
}

export class SkipRESTRuntime implements SkipRuntime {
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
    reactiveAuth?: Uint8Array,
  ): Promise<{ values: Entry<K, V>[]; reactive?: ReactiveResponse }> {
    const qParams = new URLSearchParams(params).toString();
    let header = {};
    if (reactiveAuth) {
      header = {
        "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString("base64"),
      };
    }
    const [values, headers] = await send(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "GET",
      header,
    );
    const strReactiveResponse = headers["X-Reactive-Response"];
    const reactive = strReactiveResponse
      ? JSON.parse(strReactiveResponse)
      : undefined;
    return reactive ? { values, reactive } : { values };
  }
  async head(
    resource: string,
    params: Record<string, string>,
    reactiveAuth: Uint8Array,
  ): Promise<ReactiveResponse> {
    const qParams = new URLSearchParams(params).toString();
    let header = {};
    if (reactiveAuth) {
      header = {
        "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString("base64"),
      };
    }
    const [_data, headers] = await send(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "HEAD",
      header,
    );
    return JSON.parse(headers["X-Reactive-Response"]);
  }
  async getOne<V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    key: string,
  ): Promise<V[]> {
    const qParams = new URLSearchParams(params).toString();
    let header = {};
    const [data, _headers] = await send(
      `${this.entrypoint}/v1/${resource}/${key}?${qParams}`,
      "GET",
      header,
    );
    return data;
  }
  async put<V extends TJSON>(
    collection: string,
    key: string,
    value: V[],
  ): Promise<void> {
    await send(`${this.entrypoint}/v1/${collection}/${key}`, "PUT", {}, value);
  }
  async patch<K extends TJSON, V extends TJSON>(
    collection: string,
    values: Entry<K, V>[],
  ): Promise<void> {
    await send(`${this.entrypoint}/v1/${collection}`, "PATCH", {}, values);
  }
  async delete(collection: string, key: string): Promise<void> {
    await send(`${this.entrypoint}/v1/${collection}/${key}`, "DELETE", {});
  }
}
