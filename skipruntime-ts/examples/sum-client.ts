import { sleep, subscribe } from "./utils.js";
import { SkipServiceBroker } from "@skipruntime/helpers";

const streaming_port = 3587;
const control_port = 3588;

const service = new SkipServiceBroker({
  host: "localhost",
  control_port,
  streaming_port,
});

const closable = await subscribe(service, "add", streaming_port);
await sleep(10);
await service.update("input1", [["v1", [2]]]);
await sleep(10);
await service.update("input2", [["v1", [3]]]);
await sleep(10);
await service.deleteKey("input1", "v1");
await sleep(10);
await service.update("input1", [
  ["v1", [2]],
  ["v2", [6]],
]);
await sleep(10);
await service.update("input2", [["v2", [0]]]);
await sleep(10);
await service.update("input1", [["v1", [8]]]);
await sleep(10);
closable.close();
