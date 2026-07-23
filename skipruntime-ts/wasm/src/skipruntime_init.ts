import {
  run,
  type EnvCreator,
  type ModuleInit,
} from "../skipwasm-std/index.js";
import type { ServiceInstanceFactory } from "./internals/skipruntime_module.js";

import { init as runtimeInit } from "../skipwasm-std/sk_runtime.js";
import { init as posixInit } from "../skipwasm-std/sk_posix.js";
import { init as skjsonInit } from "../skipwasm-json/skjson.js";
import { init as skruntimeInit } from "./internals/skipruntime_module.js";
import type { ServiceInstance } from "@skipruntime/core";
import type { AnySkipService } from "@skipruntime/core/internal.js";

const modules: ModuleInit[] = [
  runtimeInit,
  posixInit,
  skjsonInit,
  skruntimeInit,
];

interface Imported {
  default: string;
}

async function wasmUrl(): Promise<URL | string> {
  //@ts-expect-error  ImportMeta is incomplete
  if (import.meta.env || import.meta.webpack) {
    const imported = (await import(
      //@ts-expect-error  Cannot find module './libskipruntime.wasm?url' or its corresponding type declarations.
      "./libskipruntime.wasm?url"
    )) as Imported;
    return imported.default;
  }

  return new URL("./libskipruntime.wasm", import.meta.url);
}

export async function initServiceFor(
  createEnvironment: EnvCreator,
  service: AnySkipService,
): Promise<ServiceInstance> {
  const data = await run(wasmUrl, modules, [], createEnvironment);
  const factory = data.environment.shared.get(
    "ServiceInstanceFactory",
  ) as ServiceInstanceFactory;
  return factory.initService(service);
}
