import type { ServiceInstance, AnySkipService } from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_node.js";

export async function initService(
  service: AnySkipService,
): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment, service);
}
