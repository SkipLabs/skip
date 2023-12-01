import { test } from "@playwright/test";
import { tests } from "./tests";

test.beforeEach(async ({ page }) => {
  await page.goto("/");
  page.on("console", (msg) => {
    if (msg.type() === "error") {
      console.error(msg.text());
    } else {
      console.log(msg.text());
    }
  });
});

function run(t, asWorker: boolean) {
  test(t.name, async ({ page }) => {
    await page.evaluate(`window.asWorker = ${asWorker};`);
    await page.evaluate(`window.test = ${t.fun};`);
    let res = await page.evaluate(async () => {
      // @ts-ignore
      let m = await import("./node_modules/skdb/dist/skdb.mjs");
      // @ts-ignore
      let skdb = await m.createSkdb({ asWorker: window.asWorker });
      // @ts-ignore
      return await window.test(skdb);
    });
    t.check(res);
  });
}

tests(false).forEach((t) => run(t, false));
tests(true).forEach((t) => run(t, true));
