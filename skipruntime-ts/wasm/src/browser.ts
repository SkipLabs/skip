import type {
  AllInputDefs,
  AllSharedCollections,
  ServiceInstance,
  SkipService,
} from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_browser.js";

export async function initService<
  InputDefs extends AllInputDefs<InputDefs>,
  ResourceInputs extends AllSharedCollections<ResourceInputs>,
>(service: SkipService<InputDefs, ResourceInputs>): Promise<ServiceInstance> {
  return await initServiceFor(createEnvironment, service);
}
