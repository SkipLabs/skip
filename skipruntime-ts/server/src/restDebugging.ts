import express from "express";
import { DebuggingServiceInstance, type ServiceInstance } from "skip-wasm";

export function debuggingService(
  baseService: ServiceInstance,
): express.Express {
  // @ts-expect-error error TS6133: '_service' is declared but its value is never read.
  const _service = new DebuggingServiceInstance(baseService);

  const app = express();
  app.use(express.json());

  return app;
}
