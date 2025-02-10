import type { ServiceInstance, SkipService } from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_node.js";
import type { EnvCreator } from "../skipwasm-std/sk_types.js";

export async function initService(
  service: SkipService,
): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment as EnvCreator, service);
}
