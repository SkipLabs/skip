export type * from "@skipruntime/api";
export type { ServiceInstance } from "@skipruntime/core";
export { OneToOneMapper, ManyToOneMapper } from "@skipruntime/api";
export {
  UnknownCollectionError,
  SkipExternalService,
  Sum,
  Min,
  Max,
  CountMapper,
  type Entrypoint,
} from "@skipruntime/core";
export {
  type ExternalResource,
  GenericExternalService,
  Polled,
} from "@skipruntime/helpers";

export { fetchJSON, SkipServiceBroker } from "@skipruntime/helpers/rest.js";

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
