import type { SkipService } from "@skipruntime/core";
import { initService } from "@skipruntime/native";

const emptyService: SkipService = {
  initialData: {},
  resources: {},
  createGraph(inputCollections) {
    return inputCollections;
  },
};

console.log("starting service...");
const service = await initService(emptyService);
console.log("closing service...");
await service.close();
console.log("done");
