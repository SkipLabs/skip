// @ts-ignore
import { test, type Page } from '@playwright/test';
// @ts-ignore
import { tests } from './tests';
// @ts-ignore
import { ms_tests } from './muxed_socket';
// @ts-ignore
import { setup, apitests } from './apitests';
// @ts-ignore
import { createDatabase } from 'skdb';
// @ts-ignore
import { webcrypto as crypto } from 'crypto';
// @ts-ignore
import { WebSocket } from 'ws';
// @ts-ignore
import * as util from 'util';
// @ts-ignore
import * as mu from './muxed_utils';

var encoder = new util.TextEncoder();


function gatherCredential() {
  // @ts-ignore
  let result = [...process.env.SKDB_CREDENTIALS.matchAll(/\{skdb_service_mgmt: \{root: ([^\}]+)\}\}/g)];
  return result[0][1];
}

function run(t, asWorker: boolean) {
  test(t.name, async () => {
    let skdb = await createDatabase(undefined, asWorker);
    let res = await t.fun(skdb);
    t.check(res);
  });
}

function runServer(t) {
  test(t.name, async () => {
    let skdb = await setup(gatherCredential(), 8110, crypto);
    let res = await t.fun(skdb);
    t.check(res);
  });
}


class Env {
  crypto = () => crypto;
  createSocket = (uri: string) => new WebSocket(uri);
  encodeUTF8 = (v) => encoder.encode(v);
}

function runMS(t) {
  test(t.name, async () => {
    let res = await t.fun(new Env(), mu);
    t.check(res);
  });
}


tests(false).forEach(t => run(t, false));
tests(true).forEach(t => run(t, true));
ms_tests().forEach(t => runMS(t));
apitests().forEach(t => runServer(t));