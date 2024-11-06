import {
  initService,
  type SkipService,
  type NamedCollections,
} from "skip-wasm";
import { createRESTServer } from "./rest.js";

export async function runService<
  Inputs extends NamedCollections,
  Outputs extends NamedCollections,
>(
  service: SkipService<Inputs, Outputs>,
  port: number = 443,
): Promise<{ close: () => void }> {
  const runtime = await initService(service);
  const app = createRESTServer(runtime);
  const httpServer = app.listen(port, () => {
    console.log(`Reactive service listening on port ${port.toString()}`);
  });

  // TODO: Return a proper object.
  return {
    close: () => {
      runtime.close();
      httpServer.close();
    },
  };
}
