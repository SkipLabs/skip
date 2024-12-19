/**
 * The @skipruntime/runtime package contains internal implementation detail for @skipruntime/server and should not need to be used directly. See the public API exposed by the @skipruntime/server package.
 *
 * @packageDocumentation
 */

import { initService as wasmInitService } from "@skipruntime/wasm";
import type { ServiceInstance } from "@skipruntime/core";
import type { SkipService } from "@skipruntime/api";

export async function initService(
  service: SkipService,
): Promise<ServiceInstance> {
  try {
    if ("bun" in process.versions) throw new Error("In bun");
    const addon = await import("@skipruntime/addon");
    const instance = await addon.initService(service);
    return instance;
  } catch (_e: any) {
    console.warn(
      "Warning: The native version cannot be used on your system. The WASM version will be used.",
    );
    const instance = await wasmInitService(service);
    return instance;
  }
}
