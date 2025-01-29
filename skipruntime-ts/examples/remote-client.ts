import { sleep, subscribe } from "./utils.js";
import { SkipServiceBroker } from "@skipruntime/helpers";

const sum_streaming_port = 3587;
const sum_control_port = 3588;
const sum_service = new SkipServiceBroker({
  host: "localhost",
  control_port: sum_control_port,
  streaming_port: sum_streaming_port,
});

const remote_streaming_port = 3589;
const remote_control_port = 3590;
const remote_service = new SkipServiceBroker({
  host: "localhost",
  control_port: remote_control_port,
  streaming_port: remote_streaming_port,
});

const closable = await subscribe(remote_service, "data", remote_streaming_port);

await sleep(10);
await sum_service.update("input1", [["v1", [2]]]);
await sleep(10);
await sum_service.update("input2", [["v1", [3]]]);
await sleep(10);
await sum_service.deleteKey("input1", "v1");
await sleep(10);
await sum_service.update("input1", [
  ["v1", [2]],
  ["v2", [6]],
]);
await sleep(10);
await sum_service.update("input2", [["v2", [0]]]);
await sleep(10);
await sum_service.update("input1", [["v1", [8]]]);
await sleep(10);
closable.close();
