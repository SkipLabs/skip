import type { ServiceInstance, SkipService } from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_browser.js";

export async function initService(
  service: SkipService,
): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment, service);
}
