import { fetchJSON, type ReactiveResponse } from "@skipruntime/core";
import { connect, Protocol } from "@skipruntime/client";
import type { TJSON } from "@skipruntime/client/protocol.js";

/*
  This is the client simulator of database example
*/

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const replication = 8081;
const port = 8082;
const url = `http://localhost:${port.toString()}`;
const creds = await Protocol.generateCredentials();

const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));

console.log("Connect to replication server for resource /users");

const header = {
  "X-Reactive-Auth": Buffer.from(publicKey.buffer).toString("base64"),
};
const [_e, headers] = await fetchJSON<ReactiveResponse>(
  `${url}/auth/users`,
  "HEAD",
  header,
);

const strReactiveResponse = headers.get("x-reactive-response");
const reactive = strReactiveResponse
  ? (JSON.parse(strReactiveResponse) as ReactiveResponse)
  : undefined;

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

console.log(
  "Get /user/123",
  (await fetchJSON(`${url}/user/123`, "GET", header))[0],
);

await sleep(1000);
console.log("Delete /user/123");

await fetchJSON(`${url}/user/123`, "DELETE", {});

console.log(
  "Get /user/123",
  (await fetchJSON(`${url}/user/123`, "GET", header))[0],
);

await sleep(1000);
client.close();
