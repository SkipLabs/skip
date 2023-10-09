import { test } from '@playwright/test';
import { ms_tests } from './muxed_socket';
import { setup, apitests } from './apitests';
import { webcrypto as crypto } from 'crypto';
import { WebSocket } from 'ws';
import * as util from 'util';
import * as mu from './muxed_utils.mjs';

var encoder = new util.TextEncoder();


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

ms_tests().forEach(t => runMS(t));
apitests(false).forEach(t => runServer(t, false));
apitests(true).forEach(t => runServer(t, true, "_node_worker"));