import express from "express";
import { DebuggingServiceInstance, type ServiceInstance } from "skip-wasm";

export function debuggingService(
  baseService: ServiceInstance,
): express.Express {
  const service = new DebuggingServiceInstance(baseService);

  const app = express();
  app.use(express.json());

  // LOW-LEVEL
  app.get("/v1/debug/raw/dirs", (_req, res) => {
    try {
      const result = service.dirs();
      res.status(200).json(result);
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  return app;
}
