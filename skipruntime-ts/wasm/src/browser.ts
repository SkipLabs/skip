import type {
  ServiceInstance,
  AnySkipService,
  ServiceOptions,
} from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_browser.js";

export async function initService(
  service: AnySkipService,
  options?: ServiceOptions,
): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment, service, options);
}
