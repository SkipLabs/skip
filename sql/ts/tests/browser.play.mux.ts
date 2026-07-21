/* eslint-disable */

import { test } from "@playwright/test";
import { ms_tests, type Test } from "./muxed_socket.js";

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

function runMS(t: Test) {
  test(t.name, async ({ page }) => {
    await page.evaluate(`window.testName = "${t.name}";`);
    await page.evaluate(`window.test = ${t.fun};`);
    if (t.slow) {
      test.slow();
    }
    let res = await page.evaluate(async () => {
      var encoder = new TextEncoder();
      class Env {
        crypto = () => crypto;
        createSocket = (uri: string) => new WebSocket(uri);
        encodeUTF8 = (v: string) => encoder.encode(v);
      }
      var mu = await import("./muxed_utils.js");
      // @ts-ignore
      return await window.test(new Env(), mu);
    });
    t.check(res);
  });
}

ms_tests().forEach((t) => runMS(t));
