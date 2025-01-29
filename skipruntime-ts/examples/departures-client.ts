import { sleep, subscribe } from "./utils.js";
import { SkipServiceBroker } from "@skipruntime/helpers";

const streaming_port = 3590;
const control_port = 3591;
const service = new SkipServiceBroker({
  host: "localhost",
  control_port,
  streaming_port,
});

console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(10);
const closable = await subscribe(service, "departures", streaming_port);
await sleep(10);
await service.update("config", [["year", [[2015]]]]);
await sleep(1000);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(10);
await service.update("config", [["origin", [["SYR"]]]]);
await sleep(1000);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(10);
await service.update("config", [["resettlement", [["USA"]]]]);
await sleep(1000);
console.log(JSON.stringify(await service.getAll("departures", {})));
await sleep(10);
await service.update("config", [
  ["year", [[2016, 2017]]],
  ["origin", [["MMR", "SYR"]]],
  ["resettlement", [["NOR", "USA"]]],
]);
await sleep(1000);
console.log(JSON.stringify(await service.getAll("departures", {})));
closable.close();
