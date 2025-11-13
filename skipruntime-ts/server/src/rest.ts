import express from "express";
import {
  ServiceInstance,
  SkipUnknownCollectionError,
  SkipResourceInstanceInUseError,
  SkipRESTError,
} from "@skipruntime/core";
import type { CollectionUpdate, Entry, Json } from "@skipruntime/core";

export function controlService(service: ServiceInstance): express.Express {
  const app = express();
  app.use(express.json({ strict: false }));

  // Streaming control API.
  app.post("/v1/streams/:resource", (req, res) => {
    const uuid = crypto.randomUUID();
    service
      .instantiateResource(uuid, req.params.resource, req.body as Json)
      .then(() => {
        const prefix = process.env["SKIP_RESOURCE_PREFIX"];
        res.status(201).send(prefix ? `${prefix}/${uuid}` : uuid);
      })
      .catch((e: unknown) => {
        console.log(e);
        res.status(500).json(e instanceof Error ? e.message : e);
      });
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
      service
        .getAll(req.params.resource, req.body as Json)
        .then((data) => {
          res.status(200).json(data);
        })
        .catch((err: unknown) => {
          res.status(500).json(err instanceof Error ? err.message : err);
        });
    } catch (e: unknown) {
      console.log(e);
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });

  app.post("/v1/snapshot/:resource/lookup", (req, res) => {
    try {
      if (
        typeof req.body != "object" ||
        !("key" in req.body) ||
        !("params" in req.body)
      )
        throw new SkipRESTError(
          `Invalid request body for synchronous lookup: ${JSON.stringify(req.body)}`,
        );
      service
        .getArray(req.params.resource, req.body.key, req.body.params as Json)
        .then((data) => {
          res.status(200).json(data);
        })
        .catch((err: unknown) => {
          res.status(500).json(err instanceof Error ? err.message : err);
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

    service
      .update(req.params.collection, req.body as Entry<Json, Json>[])
      .then(() => res.sendStatus(200))
      .catch((e: unknown) => {
        if (e instanceof SkipUnknownCollectionError) {
          res.sendStatus(404);
        } else {
          console.error(e);
          res.status(500).json(e instanceof Error ? e.message : e);
        }
      });
  });

  app.get("/v1/healthcheck", (_, res) => {
    res.sendStatus(200);
  });

  return app;
}

export function streamingService(service: ServiceInstance): express.Express {
  const app = express();

  app.get("/v1/streams/:uuid", (req, res) => {
    if (!req.accepts("text/event-stream")) {
      res.sendStatus(406);
      return;
    }
    try {
      const uuid = req.params.uuid;
      const subscriptionID = service.subscribe(uuid, {
        subscribed: () => {
          res.set("Content-Type", "text/event-stream");
          res.set("Connection", "keep-alive");
          res.set("Cache-Control", "no-cache");
          res.status(200);
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
      const heartbeat = setInterval(() => {
        res.write("event: update\ndata:[]\n\n");
      }, 30000);

      req.on("close", () => {
        clearInterval(heartbeat);
        service.unsubscribe(subscriptionID);
      });
    } catch (e: unknown) {
      console.log(e);
      if (e instanceof SkipUnknownCollectionError) {
        res.sendStatus(404);
      } else if (e instanceof SkipResourceInstanceInUseError) {
        res.sendStatus(409);
      } else {
        res.sendStatus(500);
      }
    }
  });

  return app;
}
