import express from "express";
import type { Entry, JSONObject, TJSON, SkipRuntime } from "@skipruntime/core";
import { UnknownCollectionError } from "@skipruntime/core";

export function createRESTServer(runtime: SkipRuntime): express.Express {
  const app = express();
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  // READS
  app.head("/v1/:resource", (req, res) => {
    const resourceName = req.params.resource;
    const strReactiveAuth = req.headers["x-reactive-auth"] as string;
    if (!strReactiveAuth) throw new Error("X-Reactive-Auth must be specified.");
    const reactiveAuth = new Uint8Array(Buffer.from(strReactiveAuth, "base64"));
    try {
      const data = runtime.head(
        resourceName,
        req.query as JSONObject,
        reactiveAuth,
      );
      res.set("X-Reactive-Response", JSON.stringify(data));
      res.status(200).json({});
    } catch (e: unknown) {
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });
  app.get("/v1/:resource/:key", (req, res) => {
    const key = req.params.key;
    const resourceName = req.params.resource;
    try {
      const data = runtime.getOne(resourceName, req.query as JSONObject, key);
      res.status(200).json(data);
    } catch (e: unknown) {
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });
  app.get("/v1/:resource", (req, res) => {
    const resourceName = req.params.resource;
    const strReactiveAuth = req.headers["x-reactive-auth"] as string;
    const reactiveAuth = strReactiveAuth
      ? new Uint8Array(Buffer.from(strReactiveAuth, "base64"))
      : undefined;
    try {
      const data = runtime.getAll(
        resourceName,
        req.query as Record<string, string>,
        reactiveAuth,
      );
      if (data.reactive) {
        res.set("X-Reactive-Response", JSON.stringify(data.reactive));
      }
      res.status(200).json(data.values);
    } catch (e: unknown) {
      res.status(500).json(e instanceof Error ? e.message : e);
    }
  });
  // WRITES
  app.put("/v1/:collection/:id", (req, res) => {
    if (!Array.isArray(req.body)) {
      res.status(400).json(`Bad request body ${JSON.stringify(req.body)}`);
      return;
    }
    const key = req.params.id;
    const data = req.body as TJSON[];
    const collectionName = req.params.collection;
    try {
      runtime.put(collectionName, key, data);
      res.status(200).json({});
    } catch (e: unknown) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e instanceof Error ? e.message : e);
      }
    }
  });
  app.patch("/v1/:collection", (req, res) => {
    if (!Array.isArray(req.body)) {
      res.status(400).json(`Bad request body ${JSON.stringify(req.body)}`);
      return;
    }
    const data = req.body as TJSON[];
    if (!Array.isArray(data)) {
      res.status(400).json("Bad request");
      return;
    }
    const collectionName = req.params.collection;
    try {
      runtime.patch(collectionName, data as Entry<TJSON, TJSON>[]);
      res.status(200).json({});
    } catch (e: unknown) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e instanceof Error ? e.message : e);
      }
    }
  });
  app.delete("/v1/:collection/:id", (req, res) => {
    const key = req.params.id;
    const collectionName = req.params.collection;
    try {
      runtime.delete(collectionName, key);
      res.status(200).json({});
    } catch (e: unknown) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e instanceof Error ? e.message : e);
      }
    }
  });

  return app;
}
