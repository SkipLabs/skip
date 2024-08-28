import type { SimpleSkipService } from "../skipruntime_service.js";
import type { createSKStore as CreateSKStore } from "../skip-runtime.js";
// @ts-ignore
import { WebSocketServer } from "ws";
import type { Database, JSONObject, TJSON } from "../skipruntime_api.js";
import { runService } from "../skipruntime_runner.js";

type HTTPCommand = {
  type: string;
  [key: string]: TJSON;
};

export async function runWithServer_(
  service: SimpleSkipService,
  createSKStore: typeof CreateSKStore,
  options: Record<string, any>,
  database?: Database,
) {
  const wss = new WebSocketServer(options);
  const [update, inputs, outputs] = await runService(
    service,
    createSKStore,
    database,
  );
  const responses = outputs["__sk_responses"];
  const requests = inputs["__sk_requests"];
  wss.on("connection", function connection(ws: any) {
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
        update(http, {});
      } else {
        throw new TypeError("Unknown message type");
      }
    });
  });
}
