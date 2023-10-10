import { test } from '@playwright/test';
import { setup, apitests } from './apitests';
import { webcrypto as crypto } from 'crypto';


function gatherCredential() {
  // @ts-ignore
  return process.env.SKDB_CREDENTIAL!;
}

function runServer(t, asWorker, suffix: string = "") {
  test(t.name, async () => {
    let skdb = await setup(gatherCredential(), 8110, crypto, asWorker, suffix);
    let res = await t.fun(skdb);
    t.check(res);
  });
}

apitests(false).forEach(t => runServer(t, false));
apitests(true).forEach(t => runServer(t, true, "_node_worker"));