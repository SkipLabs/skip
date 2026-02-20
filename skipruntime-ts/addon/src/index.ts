import type { Exception as IException } from "@skipruntime/core/internal.js";
import { ServiceInstance, ToBinding } from "@skipruntime/core";
import type { FromBinding as SkipRuntimeFromBinding } from "@skipruntime/core/binding.js";
import {
  buildJsonConverter,
  type Binding as JsonBinding,
  type Pointer,
} from "@skipruntime/core/json.js";
import { createRequire } from "node:module";
const require = createRequire(import.meta.url);

type AddOn = {
  getJsonBinding: () => JsonBinding;
  getSkipRuntimeFromBinding: () => SkipRuntimeFromBinding;
  initSkipRuntimeToBinding: (binding: ToBinding) => void;
  runWithGC: <T>(fn: () => T) => T;
  unsafeAsyncRunWithGC: <T>(fn: () => Promise<T>) => Promise<T>;
  getErrorObject: (skExc: Pointer<IException>) => Error;
};

const skip_runtime: AddOn = require("../build/Release/skip_runtime.node");

import type { SkipService } from "@skipruntime/core";

const jsonBinding: JsonBinding = skip_runtime.getJsonBinding();
const jsonConverter = buildJsonConverter(jsonBinding);
const fromBinding = skip_runtime.getSkipRuntimeFromBinding();
const tobinding = new ToBinding(
  fromBinding,
  skip_runtime.runWithGC,
  skip_runtime.unsafeAsyncRunWithGC,
  () => jsonConverter,
  skip_runtime.getErrorObject,
);

export function initService(service: SkipService): Promise<ServiceInstance> {
  skip_runtime.initSkipRuntimeToBinding(tobinding);
  try {
    return Promise.resolve(tobinding.initService(service));
  } catch (e: unknown) {
    return Promise.reject<ServiceInstance>(e as Error);
  }
}
