import { test } from "@playwright/test";
import { tests, createSkdb, UnitTest } from "./tests";

function run(t: UnitTest) {
  test(t.name, async () => {
    const skdb = await createSkdb();
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const res = await t.fun(skdb);
    t.check(res);
  });
}

tests().forEach(run);
