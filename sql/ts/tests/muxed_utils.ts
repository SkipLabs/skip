import { MuxedSocket, type Environment } from "skdb/orchestration.js";

export const connect = MuxedSocket.connect.bind(null);

export function request_close() {
  const buf = new ArrayBuffer(4);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x0);
  return buf;
}

export function request_error() {
  const buf = new ArrayBuffer(4);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x4);
  return buf;
}

export function request_echo(n: number) {
  const buf = new ArrayBuffer(8);
  const dv = new DataView(buf);
  dv.setUint32(0, 0x1);
  dv.setUint32(4, n);
  return buf;
}

export function request_stream() {
  const buf = new ArrayBuffer(8);
  const dv = new DataView(buf);
  dv.setUint32(0, 3);
  return buf;
}

export function request_concurrent_streaming() {
  const buf = new ArrayBuffer(8);
  const dv = new DataView(buf);
  dv.setUint32(0, 5);
  return buf;
}

export function toHex(buf: ArrayBuffer) {
  return (
    "0x" +
    [...new Uint8Array(buf)]
      .map((x) => x.toString(16).padStart(2, "0"))
      .join("")
  );
}

export async function connectAndAuth(env: Environment) {
  const key = await env
    .crypto()
    .subtle.importKey(
      "raw",
      env.encodeUTF8("test"),
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign"],
    );
  const socket = await connect(env, "ws://localhost:8090", {
    accessKey: "ABCDEFGHIJKLMNOPQRST",
    privateKey: key,
    deviceUuid: "f6a0a084-d21f-487d-813a-971c183309a3",
  });
  return socket;
}
