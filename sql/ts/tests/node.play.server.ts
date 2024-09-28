import { test } from "@playwright/test";
import { setup, apitests } from "./apitests";
import { webcrypto as crypto } from "crypto";
import { SKDB } from "skdb";

function runServer(
  t: {
    name: string;
    fun: (info: { root: SKDB; user: SKDB; user2: SKDB }) => unknown;
    check: (res: unknown) => void;
  },
  asWorker: boolean,
  suffix: string = "",
) {
  test(t.name, async () => {
    const skdb = await setup(8110, crypto, asWorker, suffix);
    const res = await t.fun(skdb);
    t.check(res);
  });
}

apitests(false).forEach((t) => {
  runServer(t, false);
});
apitests(true).forEach((t) => {
  runServer(t, true, "_node_worker");
});
