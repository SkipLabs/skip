import express from "express";
import { ServiceInstance, UnknownCollectionError } from "@skipruntime/core";
import type { CollectionUpdate, Entry, Json } from "@skipruntime/api";

export function controlService(service: ServiceInstance): express.Express {
  const app = express();
  app.use(express.json({ strict: false }));

  // Streaming control API.
  app.post("/v1/streams/:resource", (req, res) => {
    try {
      const uuid = crypto.randomUUID();
      service.instantiateResource(uuid, req.params.resource, req.body as Json);
      res.status(201).send(uuid);
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  app.delete("/v1/streams/:uuid", (req, res) => {
    try {
      service.closeResourceInstance(req.params.uuid);
      res.sendStatus(200);
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  // READS
  app.post("/v1/snapshot/:resource", (req, res) => {
    try {
      const callbacks = {
        resolve: (data: Json[]) => {
          res.status(200).json(data);
        },
        reject: (err: unknown) => {
          res.status(500).json(err instanceof Error ? err.message : err);
        },
      };
      service.getAll(req.params.resource, req.body as Json, callbacks);
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  app.post("/v1/snapshot/:resource/lookup", (req, res) => {
    try {
      const callbacks = {
        resolve: (data: Json[]) => {
          res.status(200).json(data);
        },
        reject: (err: unknown) => {
          res.status(500).json(err instanceof Error ? err.message : err);
        },
      };
      if (
        typeof req.body != "object" ||
        !("key" in req.body) ||
        !("params" in req.body)
      )
        throw new Error(
          `Invalid request body for synchronous lookup: ${JSON.stringify(req.body)}`,
        );
      service.getArray(
        req.params.resource,
        req.body.key,
        req.body.params as Json,
        callbacks,
      );
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  // WRITES
  app.patch("/v1/inputs/:collection", (req, res) => {
    if (!Array.isArray(req.body)) {
      res.status(400).json(`Bad request body ${JSON.stringify(req.body)}`);
      return;
    }
    try {
      service.update(req.params.collection, req.body as Entry<Json, Json>[]);
      res.sendStatus(200);
    } catch (e: unknown) {
      if (e instanceof UnknownCollectionError) {
        res.sendStatus(404);
      } else {
        console.log(e);
        res.status(500).json(e instanceof Error ? e.message : e);
      }
    }
  });

  return app;
}

export function streamingService(service: ServiceInstance): express.Express {
  const app = express();
  app.use(express.json());

  app.get("/v1/streams/:uuid", (req, res) => {
    if (!req.accepts("text/event-stream")) {
      res.sendStatus(406);
      return;
    }
    try {
      const uuid = req.params.uuid;
      const subscriptionID = service.subscribe(uuid, {
        subscribed: () => {
          res.writeHead(200, {
            "Content-Type": "text/event-stream",
            Connection: "keep-alive",
            "Cache-Control": "no-cache",
          });
          res.flushHeaders();
        },
        notify: (update: CollectionUpdate<string, Json>) => {
          if (update.isInitial) {
            res.write(`event: init\n`);
          } else {
            res.write(`event: update\n`);
          }
          res.write(`id: ${update.watermark}\n`);
          res.write(`data: ${JSON.stringify(update.values)}\n\n`);
        },
        close: () => {
          res.end();
        },
      });
      req.on("close", () => {
        service.unsubscribe(subscriptionID);
      });
    } catch (e: unknown) {
      console.log(e);
      if (e instanceof UnknownCollectionError) {
        res.sendStatus(404);
      } else {
        res.sendStatus(500);
      }
    }
  });

  return app;
}
