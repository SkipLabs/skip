import { initService } from "skip-wasm";
import type { SkipService, NamedCollections } from "skip-wasm";
import { controlService, streamingService } from "./rest.js";

export async function runService<
  Inputs extends NamedCollections,
  Outputs extends NamedCollections,
>(
  service: SkipService<Inputs, Outputs>,
  options: {
    streaming_port: number;
    control_port: number;
  } = {
    streaming_port: 8080,
    control_port: 8081,
  },
): Promise<{ close: () => void }> {
  const runtime = await initService(service);
  const controlHttpServer = controlService(runtime).listen(
    options.control_port,
    () => {
      console.log(
        `Skip control service listening on port ${options.control_port.toString()}`,
      );
    },
  );
  const streamingHttpServer = streamingService(runtime).listen(
    options.streaming_port,
    () => {
      console.log(
        `Skip streaming service listening on port ${options.streaming_port.toString()}`,
      );
    },
  );

  // TODO: Return a proper object.
  return {
    close: () => {
      controlHttpServer.close();
      streamingHttpServer.close();
      runtime.close();
    },
  };
}
