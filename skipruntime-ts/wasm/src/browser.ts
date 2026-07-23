import type { ServiceInstance } from "@skipruntime/core";
import type { AnySkipService } from "@skipruntime/core/internal.js";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_browser.js";

export async function initService(
  service: AnySkipService,
): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment, service);
}
