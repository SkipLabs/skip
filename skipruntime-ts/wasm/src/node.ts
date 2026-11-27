import type {
  ServiceInstance,
  AnySkipService,
  ServiceOptions,
} from "@skipruntime/core";

import { initServiceFor } from "./skipruntime_init.js";
import { environment as createEnvironment } from "../skipwasm-std/sk_node.js";

function isEnvEnabled(value: string | undefined): boolean {
  return (
    value !== undefined &&
    value !== "" &&
    value !== "0" &&
    value.toLowerCase() !== "false"
  );
}

export async function initService(
  service: AnySkipService,
  options?: ServiceOptions,
): Promise<ServiceInstance> {
  const resolvedOptions: ServiceOptions = {
    ...options,
    checkReducers:
      options?.checkReducers ??
      isEnvEnabled(process.env["SKIP_CHECK_REDUCERS"]),
  };
  return await initServiceFor(createEnvironment, service, resolvedOptions);
}
