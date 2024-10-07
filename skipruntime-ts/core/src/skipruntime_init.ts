import { run, type ModuleInit } from "std";
import type {
  SKStore,
  RuntimeFactory,
  TJSON,
  CallResourceCompute,
  Entrypoint,
  EagerCollection,
  CollectionWriter,
  SkipRuntime,
} from "./skipruntime_api.js";

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

export type CreateRuntime = typeof createRuntime;

export async function createRuntime(
  init: (
    context: Context,
    inputs: Record<string, EagerCollection<TJSON, TJSON>>,
  ) => CallResourceCompute,
  inputs: Record<string, [TJSON, TJSON][]>,
  remotes: Record<string, Entrypoint> = {},
  tokens: Record<string, number> = {},
  writers: Record<string, CollectionWriter<TJSON, TJSON>> = {},
): Promise<SkipRuntime> {
  const data = await run(wasmUrl, modules, [], "SKDB_factory");
  const factory = data.environment.shared.get(
    "SkipRuntimeFactory",
  ) as RuntimeFactory;
  return factory.createRuntime(init, inputs, remotes, tokens, writers);
}
