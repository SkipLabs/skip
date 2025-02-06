/* eslint-disable */

import { test } from "@playwright/test";
import { ms_tests, type Test } from "./muxed_socket.js";
import type { Environment } from "skdb/orchestration.js";
import * as mu from "./muxed_utils.js";
import { webcrypto as crypto } from "crypto";
import { WebSocket } from "ws";

import * as util from "util";

const encoder = new util.TextEncoder();

export class Env {
  crypto = () => crypto;
  createSocket = (uri: string) => new WebSocket(uri);
  encodeUTF8 = (v: string) => encoder.encode(v);
}

function runMS(t: Test) {
  test(t.name, async () => {
    if (t.slow) {
      test.slow();
    }
    const res = await t.fun(new Env() as unknown as Environment, mu);
    t.check(res);
  });
}

ms_tests().forEach((t) => {
  runMS(t as Test);
});
