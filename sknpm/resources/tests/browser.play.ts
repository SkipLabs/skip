// @ts-ignore
import { test } from '@playwright/test';
// @ts-ignore
import { tests } from './tests';
import { load } from 'sk_tests';

test.beforeEach(async ({ page }) => {
  await page.goto('/');
  page.on('console', msg => {
    if (msg.type() === 'error') {
      console.error(msg.text());
    } else {
      console.log(msg.text());
    }
  });
})

function run(t) {
  test(t.name, async ({ page }) => {
    await page.evaluate(`window.testName = "${t.name}";`);
    await page.evaluate(`window.test = ${t.fun};`);
    let res = await page.evaluate(async () => {
      // @ts-ignore
      let m = await import('../node_modules/sk_tests/dist/sk_tests.mjs');
      // @ts-ignore
      var main = await m.load();
      // @ts-ignore
      return await window.test(window.testName, main);
    });
    t.check(res);
  });
}
var main = await load();
tests(main).forEach(run);
