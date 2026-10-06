import { initTests } from "./tests.js";
import { initAsyncTests } from "./async_tests.js";
import { initService } from "@skipruntime/wasm";

initTests("Wasm", initService);
initAsyncTests("Wasm", initService);
