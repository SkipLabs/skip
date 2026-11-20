import { initTests } from "./tests.js";
import { initAsyncTests } from "./async_tests.js";
import { initService } from "@skipruntime/native";

initTests("Native", initService);
initAsyncTests("Native", initService);
