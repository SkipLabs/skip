import { run, type ModuleInit } from "std";
import type { SkipRuntime, SkipService } from "./skipruntime_api.js";
import type { SkipRuntimeFactory } from "./internals/skipruntime_module.js";

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

export async function initService(service: SkipService): Promise<SkipRuntime> {
  const data = await run(wasmUrl, modules, []);
  const factory = data.environment.shared.get(
    "SkipRuntime",
  ) as SkipRuntimeFactory;
  return factory.initService(service);
}
