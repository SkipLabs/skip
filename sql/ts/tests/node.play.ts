import { test, type Page } from "@playwright/test";
import { tests } from "./tests";
import { createSkdb } from "skdb";

function run(t, asWorker: boolean) {
  test(t.name, async () => {
    let skdb = await createSkdb({ asWorker: asWorker });
    let res = await t.fun(skdb);
    t.check(res);
  });
}

tests(false).forEach((t) => run(t, false));
tests(true).forEach((t) => run(t, true));
