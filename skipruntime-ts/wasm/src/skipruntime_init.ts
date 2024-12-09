import { run, type ModuleInit } from "@skip-wasm/std";
import type { SkipService } from "@skipruntime/api";
import type { ServiceInstanceFactory } from "./internals/skipruntime_module.js";

import { init as runtimeInit } from "@skip-wasm/std/runtime.js";
import { init as posixInit } from "@skip-wasm/std/posix.js";
import { init as skjsonInit } from "@skip-wasm/json";
import { init as skruntimeInit } from "./internals/skipruntime_module.js";
import type { ServiceInstance } from "@skipruntime/core";

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
      //@ts-expect-error  Cannot find module './skstore.wasm?url' or its corresponding type declarations.
      "./libskip-runtime-ts.wasm?url"
    )) as Imported;
    return imported.default;
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
