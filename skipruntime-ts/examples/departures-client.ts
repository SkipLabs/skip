import { sleep, subscribe } from "./utils.js";
import { SkipServiceBroker } from "@skipruntime/helpers";

const streaming_port = 3590;
const control_port = 3591;
const service = new SkipServiceBroker(
  {
    host: "localhost",
    control_port,
    streaming_port,
  },
  2000,
);

// Time to wait (in milliseconds) for local/remote operations to complete,
// allowing for reproducible/consistent test output
const local_delay = 10;
const remote_delay = 2000;

await sleep(remote_delay);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(local_delay);
const closable = await subscribe(service, "departures", streaming_port);
await sleep(local_delay);
await service.update("config", [["year", [[2015]]]]);
await sleep(remote_delay);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(local_delay);
await service.update("config", [["origin", [["SYR"]]]]);
await sleep(remote_delay);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(local_delay);
await service.update("config", [["resettlement", [["USA"]]]]);
await sleep(remote_delay);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(local_delay);
await service.update("config", [
  ["year", [[2016, 2017]]],
  ["origin", [["MMR", "SYR"]]],
  ["resettlement", [["NOR", "USA"]]],
]);
await sleep(remote_delay);
console.log(JSON.stringify(await service.getAll("departures", {})));
closable.close();
