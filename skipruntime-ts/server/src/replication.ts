import { WebSocket, type WebSocketServer, type MessageEvent } from "ws";
import type { Entry, TJSON, SkipRuntime } from "@skipruntime/core";
import { Protocol } from "@skipruntime/client";

class TailingSession {
  private subsessions = new Map<string, bigint>();

  constructor(
    private replication: SkipRuntime /*, private pubkey: ArrayBuffer*/,
  ) {}

  subscribe(
    collection: string,
    since: bigint,
    callback: (
      updates: Entry<string, TJSON>[],
      isInit: boolean,
      tick: bigint,
    ) => void,
  ) {
    // FIXME: Pass pubkey down to replication.
    const subsession = this.replication.subscribe<string, TJSON>(
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
    for (const collection in this.subsessions) {
      this.unsubscribe(collection);
    }
  }
}

class ReplicationServerError extends Error {
  constructor(
    public code: number,
    public msg: string,
  ) {
    super(`${code.toString()}: ${msg}`);
  }
}

function handleMessage(
  data: unknown,
  session: TailingSession,
  ws: WebSocket,
): void {
  if (!(data instanceof ArrayBuffer)) {
    // Required by Bun.
    if (data instanceof Uint8Array) {
      data = data.buffer;
    } else {
      throw new ReplicationServerError(1001, "Received string WebSocket msg.");
    }
  }

  const msg = Protocol.decodeMsg(data as ArrayBuffer);
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

async function handleAuthMessage(data: unknown): Promise<boolean> {
  if (!(data instanceof ArrayBuffer)) {
    // Required by Bun.
    if (data instanceof Uint8Array) {
      data = data.buffer;
    } else {
      throw new ReplicationServerError(1001, "Received string WebSocket msg.");
    }
  }

  const msg = Protocol.decodeMsg(data as ArrayBuffer);
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
    private replication: SkipRuntime,
  ) {
    wss.on("connection", (ws) => {
      this.onconnection(ws);
    });
  }

  close() {
    for (const [ws, session] of this.sessions) {
      session.close();
      ws.send(
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
    ws.onmessage = (event) => {
      this.onmessage(ws, event);
    };
    ws.onclose = (_event) => {
      this.onclose(ws);
    };
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
        .catch((error: unknown) => {
          this.errorHandler(ws, error);
          return false;
        });
      this.auth.set(ws, authPromise);
    } else {
      void authRequest
        .then((_) => {
          handleMessage(event.data, this.sessions.get(ws)!, ws);
        })
        .catch((error: unknown) => {
          this.errorHandler(ws, error);
        });
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
