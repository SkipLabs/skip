import { run, type ModuleInit } from "std";
import type { SkipRuntime, SkipService } from "./skipruntime_api.js";
import type { SkipRuntimeFactory } from "./internals/skipruntime_module.js";

import { init as runtimeInit } from "std/runtime.js";
import { init as posixInit } from "std/posix.js";
import { init as skjsonInit } from "skjson";
import {
  check,
  isSkFrozen,
  sk_freeze,
  init as skruntimeInit,
} from "./internals/skipruntime_module.js";

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

/**
 * _Deep-freeze_ an object, returning the same object that was passed in.
 *
 * This function is similar to
 * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze | `Object.freeze()`}
 * but freezes the object and deep-freezes all its properties,
 * recursively. The object is then not only _immutable_ but also
 * _constant_. Note that as a result all objects reachable from the
 * parameter will be frozen and no longer mutable or extensible, even from
 * other references.
 *
 * The primary use for this function is to satisfy the requirement that all
 * parameters to Skip `Mapper` constructors must be deep-frozen: objects
 * that have not been constructed by Skip can be passed to `freeze()` before
 * passing them to a `Mapper` constructor.
 *
 * @param value - The object to deep-freeze.
 * @returns The same object that was passed in.
 */
export function freeze<T>(value: T): T {
  if (
    typeof value == "string" ||
    typeof value == "number" ||
    typeof value == "boolean"
  ) {
    return value;
  } else if (typeof value == "object") {
    if (value === null) {
      return value;
    } else if (isSkFrozen(value)) {
      return value;
    } else if (Object.isFrozen(value)) {
      check(value);
      return value;
    } else if (Array.isArray(value)) {
      const length: number = value.length;
      for (let i = 0; i < length; i++) {
        value[i] = freeze(value[i]);
      }
      return Object.freeze(sk_freeze(value));
    } else {
      const jso = value as Record<string, any>;
      for (const key of Object.keys(jso)) {
        jso[key] = freeze(jso[key]);
      }
      return Object.freeze(sk_freeze(jso)) as T;
    }
  } else {
    throw new Error(`'${typeof value}' cannot be frozen.`);
  }
}
