import { test } from "@playwright/test";
import { setup, apitests } from "./apitests";
import { webcrypto as crypto } from "crypto";

function runServer(t, asWorker, suffix: string = "") {
  test(t.name, async () => {
    test.setTimeout(60000) // up from default 30 seconds
    let skdb = await setup(8110, crypto, asWorker, suffix);
    let res = await t.fun(skdb);
    t.check(res);
  });
}

apitests(false).forEach((t) => runServer(t, false));
apitests(true).forEach((t) => runServer(t, true, "_node_worker"));
