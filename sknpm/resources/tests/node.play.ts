import { test } from '@playwright/test';
import { tests } from './tests';
import { load } from 'sk_tests';

var main = await load();

function run(t) {
  test(t.name, async () => {
    let res = t.fun(t.name, main);
    t.check(res);
  });
}

tests(main).forEach(run);