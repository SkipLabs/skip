// @ts-ignore
import { test } from '@playwright/test';
// @ts-ignore
import { tests } from './tests';
// @ts-ignore
import { ms_tests } from './muxed_socket';


test.beforeEach(async ({ page }) => {
  await page.goto('/');
  page.on('console', msg => {
    if (msg.type() === 'error') {
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
      let m = await import('./node_modules/skdb/dist/skdb.mjs');
      // @ts-ignore
      let skdb = await m.createSkdb({asWorker: window.asWorker});
      // @ts-ignore
      return await window.test(skdb);
    });
    t.check(res);
  });
}
/*
*/

function runMS(t) {
  test(t.name, async ({ page }) => {
    await page.evaluate(`window.testName = "${t.name}";`);
    await page.evaluate(`window.test = ${t.fun};`);
    let res = await page.evaluate(async () => {
      var encoder = new TextEncoder();
      class Env {
        crypto = () => crypto;
        createSocket = (uri: string) => new WebSocket(uri);
        encodeUTF8 = (v) => encoder.encode(v);
      }
      // @ts-ignore
      var mu = await import('./muxed_utils.mjs');
      // @ts-ignore
      return await window.test(new Env(), mu);
    });
    t.check(res);
  });
}


tests(false).forEach(t => run(t, false));
tests(true).forEach(t => run(t, true));
ms_tests().forEach(t => runMS(t));
