import type { SkipService } from "../skipruntime_service.js";
import type { createSKStore as CreateSKStore } from "../skip-runtime.js";
import type { Entry, JSONObject, TJSON } from "../skipruntime_api.js";
import express from "express";

import { runService } from "../skipruntime_runner.js";
import { UnknownCollectionError } from "./skipruntime_impl.js";

export async function runWithRESTServer_(
  service: SkipService,
  createSKStore: typeof CreateSKStore,
  options: Record<string, any>,
) {
  // eslint-disable-next-line  @typescript-eslint/no-unsafe-call
  const app = express();
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  const [runtime, _replication] = await runService(service, createSKStore);
  // READS
  app.get("/v1/:resource/:key", async (req, res) => {
    const key = req.params.key;
    const resourceName = req.params.resource;
    //const params = res.
    try {
      const data = await runtime.getOne(
        resourceName,
        req.query as JSONObject,
        key,
      );
      res.status(200).json(data);
    } catch (e: any) {
      res.status(500).json(e.message);
    }
  });
  app.get("/v1/:resource", async (req, res) => {
    const resourceName = req.params.resource;
    const strReactiveAuth = req.headers["x-reactive-auth"] as string;
    const reactiveAuth = strReactiveAuth
      ? new Uint8Array(Buffer.from(strReactiveAuth, "base64"))
      : undefined;
    try {
      const data = await runtime.getAll(
        resourceName,
        req.query as JSONObject,
        reactiveAuth,
      );
      const header = data.reactive
        ? { "X-Reactive-Responce": JSON.stringify(data.reactive) }
        : {};
      res.header(header).status(200).json(data.values);
    } catch (e: any) {
      res.status(500).json(e.message);
    }
  });
  app.head("/v1/:resource", async (req, res) => {
    const resourceName = req.params.resource;
    const strReactiveAuth = req.headers["x-reactive-auth"] as string;
    if (!strReactiveAuth) throw new Error("X-Reactive-Auth must be specified.");
    const reactiveAuth = new Uint8Array(Buffer.from(strReactiveAuth, "base64"));
    try {
      const data = await runtime.head(
        resourceName,
        req.query as JSONObject,
        reactiveAuth,
      );
      const header = reactiveAuth
        ? { "X-Reactive-Responce": JSON.stringify(data) }
        : {};
      res.header(header).status(200).json({});
    } catch (e: any) {
      res.status(500).json(e.message);
    }
  });
  // WRITES
  app.put("/v1/:collection/:id", async (req, res) => {
    const key = req.params.id;
    const data: TJSON[] = req.body;
    const collectionName = req.params.collection;
    try {
      await runtime.put(collectionName, key, data);
      res.status(200).json({});
    } catch (e: any) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e.message);
      }
    }
  });
  app.patch("/v1/:collection", async (req, res) => {
    const data: TJSON = req.body;
    if (!Array.isArray(data)) {
      res.status(400).json("Bad request");
      return;
    }
    const collectionName = req.params.collection;
    try {
      await runtime.patch(collectionName, data as Entry<TJSON, TJSON>[]);
      res.status(200).json({});
    } catch (e: any) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e.message);
      }
    }
  });
  app.delete("/v1/:collection/:id", async (req, res) => {
    const key = req.params.id;
    const collectionName = req.params.collection;
    try {
      await runtime.delete(collectionName, key);
      res.status(200).json({});
    } catch (e: any) {
      if (e instanceof UnknownCollectionError) {
        res.status(400).json("Bad request");
      } else {
        res.status(500).json(e.message);
      }
    }
  });
  const httpPort = "port" in options ? options["port"] : 3587;
  app.listen(httpPort, () => {
    console.log(`Serve at http://localhost:${httpPort}`);
  });
}
