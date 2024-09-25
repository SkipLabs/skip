import { fetchJSON, type ReactiveResponse } from "skip-runtime";
import { connect, Protocol } from "skipruntime-replication-client";
import type { TJSON } from "skipruntime-replication-client/protocol.js";

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const replication = 8081;
const port = 8082;
const url = `http://localhost:${port.toString()}`;
const creds = await Protocol.generateCredentials();

const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));

console.log("Connect to replication server for resource /user/123");

const header = {
  "X-Reactive-Auth": Buffer.from(publicKey.buffer).toString("base64"),
};
const [reactive, _headers] = await fetchJSON<ReactiveResponse>(
  `${url}/auth/user/123`,
  "GET",
  header,
);
if (reactive == null) {
  throw new Error("Reactive response must be supplied.");
}

const client = await connect(`ws://localhost:${replication.toString()}`, creds);

client.subscribe(
  reactive.collection,
  BigInt(reactive.watermark),
  (updates: [string, TJSON[]][], isInit: boolean) => {
    console.log("Update", Object.fromEntries(updates), isInit);
  },
);

await sleep(1000);

console.log('Set /user/123 to { name: "daniel", country: "UK" }');

await fetchJSON(
  `${url}/user/123`,
  "PUT",
  {},
  { name: "daniel", country: "UK" },
);

await sleep(1000);
console.log("Delete /user/123");

await fetchJSON(`${url}/user/123`, "DELETE", {});
