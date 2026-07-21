/* eslint-disable */

import { test } from "@playwright/test";
import { tests, type Test } from "./tests.js";

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

function run(t: Test, asWorker: boolean) {
  test(t.name, async ({ page }) => {
    await page.evaluate(`window.asWorker = ${asWorker};`);
    await page.evaluate(`window.test = ${t.fun};`);
    let res = await page.evaluate(async () => {
      let m = await import("skdb");
      // @ts-ignore
      let skdb = await m.createSkdb({ asWorker: window.asWorker });
      // @ts-ignore
      return await window.test(skdb);
    });
    t.check(res);
  });
}

tests(false).forEach((t) => run(t, false));
// Disconnect worker check need to be run with bumbled version
// tests(true).forEach((t) => run(t, true));
