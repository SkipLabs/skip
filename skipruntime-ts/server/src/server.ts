import { WebSocketServer } from "ws";
import * as http from "http";
import {
  initService,
  type SkipService,
  type NamedCollections,
} from "skip-wasm";
import { createRESTServer } from "./rest.js";
import { ReplicationServer } from "./replication.js";

export async function runService<
  Inputs extends NamedCollections,
  Outputs extends NamedCollections,
>(
  service: SkipService<Inputs, Outputs>,
  port: number = 443,
): Promise<{ close: () => void }> {
  const runtime = await initService(service);
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
      runtime.close();
      replicationServer.close();
      httpServer.close();
    },
  };
}
