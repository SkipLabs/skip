import { initService } from "@skipruntime/native";

console.log("starting service...");
const service = await initService({
  inputs: {},
  resources: {},
  createGraph: (ic) => ic,
});
console.log("closing service...");
await service.close();
console.log("done");
