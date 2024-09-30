import { WebSocketServer } from "ws";
import * as http from "http";
import {
  initService,
  createSKStore,
  type SkipService,
} from "@skipruntime/core";
import { createRESTServer } from "./rest.js";
import { ReplicationServer } from "./replication.js";

export async function runService(
  service: SkipService,
  port: number = 443,
): Promise<{ close: () => void }> {
  const runtime = await initService(service, createSKStore);
  const httpServer = http.createServer();
  const app = createRESTServer(runtime);
  httpServer.on("request", app);
  const wss = new WebSocketServer({ server: httpServer });
  const replicationServer = new ReplicationServer(wss, runtime);
  httpServer.listen(port, () => {
    console.log(`Reactive service listening on port ${port.toString()}`);
  });

  // TODO: Return a proper object.
  return {
    close: () => {
      replicationServer.close();
      httpServer.close();
    },
  };
}
