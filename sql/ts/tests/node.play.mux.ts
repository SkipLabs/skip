import { test } from '@playwright/test';
import { ms_tests } from './muxed_socket';
import { webcrypto as crypto } from 'crypto';
import { WebSocket } from 'ws';
import * as util from 'util';
import * as mu from './muxed_utils.mjs';

var encoder = new util.TextEncoder();

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