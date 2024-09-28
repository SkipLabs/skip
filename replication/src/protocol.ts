// Interfaces

export interface JSONObject {
  [key: string]: TJSON | null;
}
export type TJSON = number | JSONObject | boolean | (TJSON | null)[] | string;

export type Entry<K extends TJSON, V extends TJSON> = [K, V[]];

export interface ProtoAuth {
  type: "auth";
  protoVersion: number;
  pubkey: ArrayBuffer;
  nonce: Uint8Array;
  timestamp: bigint;
  signature: ArrayBuffer;
  clientVersion: string;
}

export interface ProtoGoAway {
  type: "goaway";
  code: number;
  msg: string;
}

export interface ProtoData {
  type: "data";
  tick: bigint;
  isInit: boolean;
  collection: string;
  payload: string;
}

export interface ProtoRequestTail {
  type: "tail";
  collection: string;
  since: bigint;
}

export interface ProtoAbortTail {
  type: "aborttail";
  collection: string;
}

export interface ProtoRequestTailBatch {
  type: "tailbatch";
  requests: ProtoRequestTail[];
}

export interface ProtoPing {
  type: "ping";
}

export interface ProtoPong {
  type: "pong";
}

export type ProtoMsg =
  | ProtoAuth
  | ProtoGoAway
  | ProtoData
  | ProtoRequestTail
  | ProtoAbortTail
  | ProtoRequestTailBatch
  | ProtoPing
  | ProtoPong;

export interface Creds {
  publicKey: CryptoKey;
  privateKey: CryptoKey;
}

// Encoding

function encodeAuthMsg(msg: ProtoAuth): ArrayBuffer {
  const enc = new TextEncoder();
  const buf = new ArrayBuffer(149 + msg.clientVersion.length);
  const uint8View = new Uint8Array(buf);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x0); // type
  dataView.setUint8(1, msg.protoVersion); // version
  uint8View.set(new Uint8Array(msg.pubkey), 4);
  uint8View.set(new Uint8Array(msg.nonce), 69);
  dataView.setBigUint64(77, msg.timestamp, false);
  uint8View.set(new Uint8Array(msg.signature), 85);
  const encodeClientVersion = enc.encodeInto(
    msg.clientVersion,
    uint8View.subarray(149),
  );
  if (encodeClientVersion.written != msg.clientVersion.length) {
    throw new Error("Non-ASCII client version.");
  }
  return buf;
}

function encodeGoAwayMsg(msg: ProtoGoAway): ArrayBuffer {
  const buf = new ArrayBuffer(5 + msg.msg.length * 4); // avoid resizing
  const textEncoder = new TextEncoder();
  const uint8View = new Uint8Array(buf);
  const dataView = new DataView(buf);
  const encodeResult = textEncoder.encodeInto(msg.msg, uint8View.subarray(5));
  dataView.setUint8(0, 0x1); // type
  dataView.setUint32(1, msg.code);
  return buf.slice(0, 5 + (encodeResult.written || 0));
}

function encodeDataMsg(msg: ProtoData): ArrayBuffer {
  const buf = new ArrayBuffer(
    10 + msg.collection.length * 4 + msg.payload.length * 4,
  ); // avoid resizing
  const textEncoder = new TextEncoder();
  const uint8View = new Uint8Array(buf);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x2); // type
  dataView.setBigUint64(1, msg.tick, false);
  dataView.setUint8(9, msg.isInit ? 1 : 0);
  dataView.setUint8(10, msg.collection.length);
  textEncoder.encodeInto(
    msg.collection,
    uint8View.subarray(11, 11 + msg.collection.length),
  );
  const encodePayload = textEncoder.encodeInto(
    msg.payload,
    uint8View.subarray(11 + msg.collection.length),
  );
  return buf.slice(
    0,
    11 + msg.collection.length + (encodePayload.written || 0),
  );
}

function encodeRequestTailMsg(msg: ProtoRequestTail): ArrayBuffer {
  const buf = new ArrayBuffer(9 + msg.collection.length);
  const textEncoder = new TextEncoder();
  const uint8View = new Uint8Array(buf);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x3); // type
  dataView.setBigUint64(1, msg.since, false);
  textEncoder.encodeInto(msg.collection, uint8View.subarray(9));
  return buf;
}

function encodeAbortTailMsg(msg: ProtoAbortTail): ArrayBuffer {
  const buf = new ArrayBuffer(1 + msg.collection.length);
  const textEncoder = new TextEncoder();
  const uint8View = new Uint8Array(buf);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x4); // type
  textEncoder.encodeInto(msg.collection, uint8View.subarray(1));
  return buf;
}

function encodeRequestTailBatchMsg(_msg: ProtoRequestTailBatch): ArrayBuffer {
  throw new Error("TODO");
}

function encodePingMsg(): ArrayBuffer {
  const buf = new ArrayBuffer(1);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x6); // type
  return buf;
}

function encodePongMsg(): ArrayBuffer {
  const buf = new ArrayBuffer(1);
  const dataView = new DataView(buf);
  dataView.setUint8(0, 0x7); // type
  return buf;
}

/**
 * Encodes a `ProtoMsg` according to the replication protocol.
 * @param msg - Message to encode.
 * @returns An `ArrayBuffer` containing the encoded message.
 */
export function encodeMsg(msg: ProtoMsg): ArrayBuffer {
  switch (msg.type) {
    case "auth":
      return encodeAuthMsg(msg);
    case "goaway":
      return encodeGoAwayMsg(msg);
    case "data":
      return encodeDataMsg(msg);
    case "tail":
      return encodeRequestTailMsg(msg);
    case "aborttail":
      return encodeAbortTailMsg(msg);
    case "tailbatch":
      return encodeRequestTailBatchMsg(msg);
    case "ping":
      return encodePingMsg();
    case "pong":
      return encodePongMsg();
  }
}

// Decoding

function decodeAuthMsg(bytes: ArrayBuffer): ProtoAuth {
  const dv = new DataView(bytes);
  const textDecoder = new TextDecoder();
  const uint8View = new Uint8Array(bytes);
  const protoVersion = dv.getUint8(1);
  // TODO: Handle proto version.
  const pubkey = uint8View.subarray(4, 69);
  const nonce = uint8View.subarray(69, 77);
  const timestamp = dv.getBigUint64(77, false);
  const signature = uint8View.subarray(85, 149);
  const clientVersion = textDecoder.decode(uint8View.subarray(149));
  return {
    type: "auth",
    protoVersion,
    pubkey,
    nonce,
    timestamp,
    signature,
    clientVersion,
  };
}

function decodeGoAwayMsg(bytes: ArrayBuffer): ProtoGoAway {
  const dv = new DataView(bytes);
  const textDecoder = new TextDecoder();
  const code = dv.getUint32(1, false);
  const errorMsgBytes = new Uint8Array(bytes, 5);
  const msg = textDecoder.decode(errorMsgBytes);
  return {
    type: "goaway",
    code,
    msg,
  };
}

function decodeDataMsg(bytes: ArrayBuffer): ProtoData {
  const dv = new DataView(bytes);
  const textDecoder = new TextDecoder();
  const uint8View = new Uint8Array(bytes);
  const tick = dv.getBigUint64(1, false);
  const isInit = dv.getUint8(9) != 0;
  const collectionLen = dv.getUint8(10);
  const collection = textDecoder.decode(
    uint8View.subarray(11, 11 + collectionLen),
  );
  const payload = textDecoder.decode(uint8View.subarray(11 + collectionLen));
  return {
    type: "data",
    tick,
    isInit,
    collection,
    payload,
  };
}

function decodeRequestTailMsg(bytes: ArrayBuffer): ProtoRequestTail {
  const dv = new DataView(bytes);
  const textDecoder = new TextDecoder();
  const since = dv.getBigUint64(1, false);
  const collection = textDecoder.decode(new Uint8Array(bytes, 9));
  return {
    type: "tail",
    since,
    collection,
  };
}

function decodeAbortTailMsg(bytes: ArrayBuffer): ProtoAbortTail {
  const textDecoder = new TextDecoder();
  const collection = textDecoder.decode(new Uint8Array(bytes, 1));
  return {
    type: "aborttail",
    collection,
  };
}

function decodeRequestTailBatchMsg(_bytes: ArrayBuffer): ProtoRequestTailBatch {
  throw new Error("TODO");
}

function decodePingMsg(_bytes: ArrayBuffer): ProtoPing {
  return {
    type: "ping",
  };
}

function decodePongMsg(_bytes: ArrayBuffer): ProtoPong {
  return {
    type: "pong",
  };
}

/**
 * Decodes a message according to the replication protocol.
 * @param bytes - Raw message to decode.
 * @returns An `ProtoMsg` containing the decoded message.
 */
export function decodeMsg(bytes: ArrayBuffer): ProtoMsg {
  const type = new DataView(bytes).getUint8(0);
  switch (type) {
    case 0:
      return decodeAuthMsg(bytes);
    case 1:
      return decodeGoAwayMsg(bytes);
    case 2:
      return decodeDataMsg(bytes);
    case 3:
      return decodeRequestTailMsg(bytes);
    case 4:
      return decodeAbortTailMsg(bytes);
    case 5:
      return decodeRequestTailBatchMsg(bytes);
    case 6:
      return decodePingMsg(bytes);
    case 7:
      return decodePongMsg(bytes);
    default:
      throw new Error(`Unexpected msg (type = ${type.toString()})`);
  }
}

// Signing

function toSign(nonce: Uint8Array, timestamp: bigint): ArrayBuffer {
  const res = new ArrayBuffer(16);
  const dataView = new DataView(res);
  const uint8View = new Uint8Array(res);
  uint8View.set(nonce);
  dataView.setBigUint64(8, timestamp, false);

  return res;
}

/**
 * Signs a `(nonce, timestamp)` pair with the provided private key.
 * @async
 * @param privkey - Private key.
 * @param nonce - Randomly generated nonce.
 * @param timestamp - Current timestamp.
 * @returns An `ArrayBuffer` containing the signature.
 */
export async function sign(
  privkey: CryptoKey,
  nonce: Uint8Array,
  timestamp: bigint,
): Promise<ArrayBuffer> {
  return await crypto.subtle.sign(
    {
      name: "ECDSA",
      hash: "SHA-256",
    },
    privkey,
    toSign(nonce, timestamp),
  );
}

/**
 * Verifies the signature of a `(nonce, timestamp)` pair with the
 * provided public key.
 *
 * @async
 * @param pubkey - Public key.
 * @param nonce - Nonce.
 * @param timestamp - Timestamp.
 * @param signature - Signature, generated by `sign()`.
 * @returns A boolean expressing a signature match.
 */
export async function verify(
  pubkey: CryptoKey,
  nonce: Uint8Array,
  timestamp: bigint,
  signature: ArrayBuffer,
): Promise<boolean> {
  return await crypto.subtle.verify(
    {
      name: "ECDSA",
      hash: "SHA-256",
    },
    pubkey,
    signature,
    toSign(nonce, timestamp),
  );
}

/**
 * Generates credentials.
 *
 * @async
 * @returns A `Creds` object containing both public and private keys.
 */
export async function generateCredentials(): Promise<Creds> {
  return await crypto.subtle.generateKey(
    // {
    //   name: 'RSA-PSS',
    //   modulusLength: 2048,
    //   publicExponent: new Uint8Array([1, 0, 1]),
    //   hash: "SHA-256",
    // },
    // FIXME: Using ECDSA for now, for lower key/signature footprint.
    // Revisit the decision (vs RSA-PSS) before release.
    {
      name: "ECDSA",
      namedCurve: "P-256",
    },
    true,
    ["sign", "verify"],
  );
}

/**
 * Exports a public key.
 *
 * @async
 * @param pubkey - Public key to export.
 * @returns An `ArrayBuffer` containing the public key bytes in raw format.
 */
export async function exportKey(pubkey: CryptoKey): Promise<ArrayBuffer> {
  return await crypto.subtle.exportKey("raw", pubkey);
}

/**
 * Imports a public key.
 *
 * @async
 * @param keybytes - Public key to import in raw format.
 * @returns An `CryptoKey` containing the public key.
 */
export async function importKey(keybytes: ArrayBuffer): Promise<CryptoKey> {
  return await crypto.subtle.importKey(
    "raw",
    keybytes,
    {
      name: "ECDSA",
      namedCurve: "P-256",
    },
    true,
    ["verify"],
  );
}
