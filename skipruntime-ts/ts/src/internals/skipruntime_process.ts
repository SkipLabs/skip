import type { SkipService } from "../skipruntime_service.js";
import { createSKStore as CreateSKStore } from "../skip-runtime.js";
import type {
  Entry,
  JSONObject,
  TJSON,
  SkipRuntime,
  SkipReplication,
} from "../skipruntime_api.js";
import express from "express";

import { runService as initService } from "../skipruntime_runner.js";
import { UnknownCollectionError } from "./skipruntime_impl.js";

import { WebSocket, WebSocketServer, type MessageEvent } from "ws";

import { Protocol } from "skipruntime-replication-client";

import * as http from "http";

class TailingSession {
  private subsessions = new Map<string, bigint>();

  constructor(
    private replication: SkipReplication<
      string,
      TJSON
    > /*, private pubkey: ArrayBuffer*/,
  ) {}

  subscribe(
    collection: string,
    since: bigint,
    callback: (
      updates: Array<Entry<string, TJSON>>,
      isInit: boolean,
      tick: bigint,
    ) => void,
  ) {
    // FIXME: Pass pubkey down to replication.
    const subsession = this.replication.subscribe(
      collection,
      since.toString(),
      (v, w, u) => {
        callback(v, !u, BigInt(w));
      },
    );
    this.subsessions.set(collection, subsession);
  }

  unsubscribe(collection: string) {
    // TODO: Throw if not found.
    this.replication.unsubscribe(this.subsessions.get(collection)!);
    this.subsessions.delete(collection);
  }

  close() {
    for (let collection in this.subsessions) {
      this.unsubscribe(collection);
    }
  }
}

class ReplicationServerError {
  constructor(
    public code: number,
    public msg: string,
  ) {}
}

async function handleMessage(
  data: any,
  session: TailingSession,
  ws: WebSocket,
): Promise<void> {
  if (!(data instanceof ArrayBuffer)) {
    // Required by Bun.
    if (data instanceof Uint8Array) {
      data = data.buffer;
    } else {
      throw new ReplicationServerError(1001, "Received string WebSocket msg.");
    }
  }

  const msg = Protocol.decodeMsg(data);
  switch (msg.type) {
    case "auth":
      throw new ReplicationServerError(1001, "Unexpected auth");
    case "ping": {
      ws.send(
        Protocol.encodeMsg({
          type: "pong",
        }),
      );
      return;
    }
    case "tail": {
      // FIXME: Respond with error 1004 if collection does not exist
      // (for current user).
      session.subscribe(msg.collection, msg.since, (updates, isInit, tick) => {
        ws.send(
          Protocol.encodeMsg({
            type: "data",
            collection: msg.collection,
            isInit,
            tick,
            payload: JSON.stringify(updates),
          }),
        );
      });
      return;
    }
    case "aborttail": {
      session.unsubscribe(msg.collection);
      return;
    }
    case "tailbatch":
      throw new Error("TODO");
  }
}

async function handleAuthMessage(data: any): Promise<boolean> {
  if (!(data instanceof ArrayBuffer)) {
    // Required by Bun.
    if (data instanceof Uint8Array) {
      data = data.buffer;
    } else {
      throw new ReplicationServerError(1001, "Received string WebSocket msg.");
    }
  }

  const msg = Protocol.decodeMsg(data);
  if (msg.type != "auth") {
    throw new ReplicationServerError(
      1002,
      "Authentication failed: Invalid message",
    );
  }
  // FIXME: Check nonce uniqueness to avoid replay attack.
  // Timestamp allowed 60 seconds of drift.
  if (Math.abs(Date.now() - Number(msg.timestamp) * 1000) > 60 * 1000) {
    throw new ReplicationServerError(
      1002,
      "Authentication failed: Invalid timestamp",
    );
  }

  const pubkey = await Protocol.importKey(msg.pubkey);
  return await Protocol.verify(pubkey, msg.nonce, msg.timestamp, msg.signature);
}

export class ReplicationServer {
  private auth = new Map<WebSocket, Promise<boolean>>();
  private sessions = new Map<WebSocket, TailingSession>();

  constructor(
    private wss: WebSocketServer,
    private replication: SkipReplication<string, TJSON>,
  ) {
    wss.on("connection", (ws) => this.onconnection(ws));
  }

  close() {
    for (const [ws, session] of this.sessions) {
      session.close();
      void ws.send(
        Protocol.encodeMsg({
          type: "goaway",
          code: 1000,
          msg: "Server shutting down",
        }),
      );
    }
    this.wss.close();
  }

  private onconnection(ws: WebSocket) {
    ws.binaryType = "arraybuffer";
    ws.onmessage = (event) => this.onmessage(ws, event);
    ws.onclose = (_event) => this.onclose(ws);
  }

  private onmessage(ws: WebSocket, event: MessageEvent) {
    // First message must be auth.
    const authRequest = this.auth.get(ws);
    if (!authRequest) {
      const authPromise = handleAuthMessage(event.data)
        .then((authOk) => {
          if (authOk) {
            this.sessions.set(ws, new TailingSession(this.replication));
            return true;
          } else {
            throw new ReplicationServerError(
              1002,
              "Authentication failed: Invalid credentials",
            );
          }
        })
        .catch((error) => {
          this.errorHandler(ws, error);
          return false;
        });
      this.auth.set(ws, authPromise);
    } else {
      void authRequest
        .then((_) => handleMessage(event.data, this.sessions.get(ws)!, ws))
        .catch((error) => this.errorHandler(ws, error));
    }
  }

  private onclose(ws: WebSocket) {
    this.sessions.get(ws)?.close();
    this.auth.delete(ws);
    this.sessions.delete(ws);
  }

  private errorHandler(ws: WebSocket, error: any) {
    if (error instanceof ReplicationServerError) {
      ws.send(
        Protocol.encodeMsg({
          type: "goaway",
          code: error.code,
          msg: error.msg,
        }),
      );
      ws.close();
    } else {
      throw error;
    }
  }
}

export async function runService(
  service: SkipService,
  createSKStore: typeof CreateSKStore,
  port: number = 443,
): Promise<{ close: () => void }> {
  const [runtime, replication] = await initService(service, createSKStore);
  const app = await runRESTServer(runtime);
  const httpServer = http.createServer();
  httpServer.on("request", app);
  const wss = new WebSocketServer({ server: httpServer });
  const replicationServer = new ReplicationServer(wss, replication);
  httpServer.listen(port, () => {
    console.log(`Reactive service listening on port ${port}`);
  });

  return {
    close: () => {
      replicationServer.close();
      httpServer.close();
    },
  };
}

async function runRESTServer(runtime: SkipRuntime): Promise<express.Express> {
  // eslint-disable-next-line  @typescript-eslint/no-unsafe-call
  const app = express();
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  // READS
  app.head("/v1/:resource", async (req, res) => {
    const resourceName = req.params.resource;
    try {
      const strReactiveAuth = req.headers["x-reactive-auth"] as string;
      if (!strReactiveAuth)
        throw new Error("X-Reactive-Auth must be specified.");
      const reactiveAuth = new Uint8Array(
        Buffer.from(strReactiveAuth, "base64"),
      );
      const data = await runtime.head(
        resourceName,
        req.query as JSONObject,
        reactiveAuth,
      );
      res.set("X-Reactive-Response", JSON.stringify(data));
      res.status(200).json({});
    } catch (e: any) {
      res.status(500).json(e.message);
    }
  });
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
      if (data.reactive) {
        res.set("X-Reactive-Response", JSON.stringify(data.reactive));
      }
      res.status(200).json(data.values);
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

  return app;
}
