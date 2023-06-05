import { test, type Page } from '@playwright/test';
import { tests } from './tests.ts';

test.beforeEach(async ({ page }) => {
  await page.goto('/');
});

tests.forEach(t => {
    test(t.name, async ({ page }) => {
        await page.evaluate(`window.test = ${t.fun};`);
        let res = await page.evaluate(async () => {
            let skdb = await import('./skdb.js').then(m => m.SKDB.create(null, m.fetchWasmSource));
            return test(skdb);
        });
        t.check(res);
    });
});
