import express from "express";
import crypto from "crypto";
import type { Entry, Json, ServiceInstance, CollectionUpdate } from "skip-wasm";
import { UnknownCollectionError } from "skip-wasm";

export function createRESTServer(service: ServiceInstance): express.Express {
  const app = express();
  app.use(express.json());
  // READS
  app.get("/v1/:resource/:key", (req, res) => {
    try {
      service.getArray(
        req.params.resource,
        req.params.key,
        req.query as { [param: string]: string },
        {
          resolve: (data: Json) => {
            res.status(200).json(data);
          },
          reject: (err: unknown) => {
            res.status(500).json(err instanceof Error ? err.message : err);
          },
        },
      );
    } catch (e: unknown) {
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });
  app.get("/v1/:resource", (req, res) => {
    try {
      res.format({
        "text/event-stream": function () {
          // TODO: Use watermark in `Last-Event-ID` header if provided
          // (upon reconnecting).
          const uuid = crypto.randomUUID();
          service.instantiateResource(
            uuid,
            req.params.resource,
            req.query as { [param: string]: string },
          );
          res.writeHead(200, {
            Connection: "keep-alive",
            "Cache-Control": "no-cache",
          });
          const subscriptionID = service.subscribe(
            uuid,
            (update: CollectionUpdate<string, Json>) => {
              if (update.isInitial) {
                res.write(`event: init\n`);
              } else {
                res.write(`event: update\n`);
              }
              res.write(`id: ${update.watermark}\n`);
              res.write(`data: ${JSON.stringify(update.values)}\n\n`);
            },
          );
          req.on("close", () => {
            service.unsubscribe(subscriptionID);
            res.end();
          });
        },
        default: function () {
          service.getAll(
            req.params.resource,
            req.query as Record<string, string>,
            {
              resolve: (data: Entry<Json, Json>[]) => {
                res.status(200).json(data.values);
              },
              reject: (err: unknown) => {
                res.status(500).json(err instanceof Error ? err.message : err);
              },
            },
          );
        },
      });
    } catch (e: unknown) {
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });
  // WRITES
  app.patch("/v1/:collection", (req, res) => {
    if (!Array.isArray(req.body)) {
      res.status(400).json(`Bad request body ${JSON.stringify(req.body)}`);
      return;
    }
    const data = req.body as Entry<Json, Json>[];
    const collectionName = req.params.collection;
    try {
      service.update(collectionName, data);
      res.sendStatus(200);
    } catch (e: unknown) {
      if (e instanceof UnknownCollectionError) {
        res.sendStatus(404);
      } else {
        res.status(500).json(e instanceof Error ? e.message : e);
      }
    }
  });
  return app;
}
