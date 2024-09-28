import { expect } from "earl";
import type { ProtoMsg } from "../src/protocol.js";
import * as Protocol from "../src/protocol.js";

function testEncodeDecode(msg: ProtoMsg) {
  it("should encode and decode back", () => {
    expect(Protocol.decodeMsg(Protocol.encodeMsg(msg))).toEqual(msg);
  });
}

describe("Encoding", () => {
  const messages = new Map<string, ProtoMsg>([
    [
      "auth",
      {
        type: "auth",
        protoVersion: 1,
        pubkey: crypto.getRandomValues(new Uint8Array(65)),
        nonce: crypto.getRandomValues(new Uint8Array(8)),
        timestamp: BigInt(Math.floor(Date.now() / 1000)),
        signature: crypto.getRandomValues(new Uint8Array(64)),
        clientVersion: "ts-1.0.0",
      },
    ],
    ["goaway", { type: "goaway", code: 1337, msg: "Get lost!" }],
    [
      "data",
      {
        type: "data",
        tick: BigInt(1337),
        isInit: true,
        collection: "foo",
        payload: '{"key": "value"}',
      },
    ],
    ["tail", { type: "tail", collection: "foo", since: BigInt(1337) }],
    ["aborttail", { type: "aborttail", collection: "foo" }],
    // TODO: tailbatch
    ["ping", { type: "ping" }],
    ["pong", { type: "pong" }],
  ]);

  for (const [name, msg] of messages) {
    describe(name, () => {
      testEncodeDecode(msg);
    });
  }
});

describe("Signing", () => {
  it("accepts correct signature", async () => {
    const creds = await Protocol.generateCredentials();
    const nonce = crypto.getRandomValues(new Uint8Array(8));
    const timestamp = BigInt(Math.floor(Date.now() / 1000));
    const signature = await Protocol.sign(creds.privateKey, nonce, timestamp);
    const verified = await Protocol.verify(
      creds.publicKey,
      nonce,
      timestamp,
      signature,
    );
    expect(verified).toBeTruthy();
  });

  it("rejects incorrect signature", async () => {
    const creds = await Protocol.generateCredentials();
    const nonce = crypto.getRandomValues(new Uint8Array(8));
    const timestamp = BigInt(Math.floor(Date.now() / 1000));
    const signature = crypto.getRandomValues(new Uint8Array(32));
    const verified = await Protocol.verify(
      creds.publicKey,
      nonce,
      timestamp,
      signature,
    );
    expect(verified).toBeFalsy();
  });
});

describe("Key import/export", () => {
  it("imports exported keys", async () => {
    const creds = await Protocol.generateCredentials();
    const bytes = await Protocol.exportKey(creds.publicKey);
    const pubkey = await Protocol.importKey(bytes);
    expect(pubkey).toEqual(creds.publicKey);
  });
});
