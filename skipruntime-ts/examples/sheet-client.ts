import { sleep, subscribe } from "./utils.js";
import { SkipServiceBroker } from "@skipruntime/helpers";

const streaming_port = 9998;
const control_port = 9999;
const service = new SkipServiceBroker({
  host: "localhost",
  control_port,
  streaming_port,
});

const closable = await subscribe(service, "computed", streaming_port);
await sleep(10);
await service.update("cells", [
  ["A1", [23]],
  ["A2", [2]],
]);
await sleep(10);
await service.update("cells", [["A3", ["=A1 + A2"]]]);
await sleep(10);
await service.update("cells", [["A1", [5]]]);
await sleep(10);
await service.update("cells", [["A4", ["=A3 * A2"]]]);
await sleep(10);
await service.deleteKey("cells", "A3");
await sleep(10);
closable.close();
