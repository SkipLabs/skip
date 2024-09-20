import type { SimpleSkipService } from "../skipruntime_service.js";
import type { createSKStore as CreateSKStore } from "../skip-runtime.js";
// eslint-disable-next-line  @typescript-eslint/ban-ts-comment
// @ts-ignore
import { WebSocketServer } from "ws";
import type { Database, JSONObject, TJSON } from "../skipruntime_api.js";
import { runService } from "../skipruntime_runner.js";

type HTTPCommand = {
  type: string;
  [key: string]: TJSON;
};

interface WS {
  send(message: string): void;
  on(chanel: string, callback: (bytes: Buffer) => void): void;
}

export async function runWithServer_(
  service: SimpleSkipService,
  createSKStore: typeof CreateSKStore,
  options: Record<string, any>,
  database?: Database,
) {
  // eslint-disable-next-line  @typescript-eslint/no-unsafe-call
  const wss = new WebSocketServer(options);
  const [update, inputs, outputs] = await runService(
    service,
    createSKStore,
    database,
  );
  const responses = outputs["__sk_responses"];
  const requests = inputs["__sk_requests"];
  // eslint-disable-next-line  @typescript-eslint/no-unsafe-call
  wss.on("connection", function connection(ws: WS) {
    responses.watchChanges(
      (rows: JSONObject[]) => {
        const message = JSON.stringify({ type: "init", payload: rows });
        ws.send(message);
      },
      (added: JSONObject[], removed: JSONObject[]) => {
        const message = JSON.stringify({
          type: "update",
          payload: { added, removed },
        });
        ws.send(message);
      },
    );
    ws.on("message", function message(bytes: Buffer) {
      const strData = bytes.toString();
      const http = JSON.parse(strData) as HTTPCommand;
      if (http.type == "get") {
        requests.insert({
          columns: ["request", "skdb_author", "skdb_access"],
          values: [[http, "", "read-write"]],
        });
      } else if (http.type == "post") {
        const maybePromise = update(http, {});
        if (typeof maybePromise === "object") {
          maybePromise.catch((e: unknown) => {
            throw e;
          });
        }
      } else {
        throw new TypeError("Unknown message type");
      }
    });
  });
}
