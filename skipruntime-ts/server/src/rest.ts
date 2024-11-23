import express from "express";
import { UnknownCollectionError } from "skip-wasm";
import type { Entry, Json, ServiceInstance, CollectionUpdate } from "skip-wasm";

export function controlService(service: ServiceInstance): express.Express {
  const app = express();
  app.use(express.json());

  // Streaming control API.
  app.post("/v1/streams", (req, res) => {
    try {
      const uuid = crypto.randomUUID();
      service.instantiateResource(
        uuid,
        req.body.resource as string,
        req.body.params as { [param: string]: string },
      );
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
  app.get("/v1/resources/:resource/:key", (req, res) => {
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
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  app.get("/v1/resources/:resource", (req, res) => {
    try {
      service.getAll(req.params.resource, req.query as Record<string, string>, {
        resolve: (data: Entry<Json, Json>[]) => {
          res.status(200).json(data);
        },
        reject: (err: unknown) => {
          res.status(500).json(err instanceof Error ? err.message : err);
        },
      });
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

  app.put("/v1/inputs/:collection/:key", (req, res) => {
    if (!Array.isArray(req.body)) {
      res.status(400).json(`Bad request body ${JSON.stringify(req.body)}`);
      return;
    }
    try {
      service.update(req.params.collection, [
        [req.params.key, req.body as Json[]],
      ]);
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
    res.writeHead(200, {
      "Content-Type": "text/event-stream",
      Connection: "keep-alive",
      "Cache-Control": "no-cache",
    });
    res.flushHeaders();

    try {
      const subscriptionID = service.subscribe(
        req.params.uuid,
        (update: CollectionUpdate<string, Json>) => {
          if (update.isInitial) {
            res.write(`event: init\n`);
          } else {
            res.write(`event: update\n`);
          }
          res.write(`id: ${update.watermark}\n`);
          res.write(`data: ${JSON.stringify(update.values)}\n\n`);
        },
        // TODO: React upon resource instance deletion.
      );
      req.on("close", () => {
        service.unsubscribe(subscriptionID);
        res.end();
      });
    } catch (e: unknown) {
      res.end();
      console.log(e);
    }
  });

  return app;
}
