import { test, type Page } from '@playwright/test';
import { tests } from './tests.ts';
import { SKDB, fetchWasmSource } from '../dist/skdb-node.js';

tests.forEach(t => {
    test(t.name, async () => {
        let skdb = await SKDB.create(null, fetchWasmSource);
        let res = t.fun(skdb);
        t.check(res);
    });
});
