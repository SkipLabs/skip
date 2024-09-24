import { fetchJSON } from "skip-runtime";
import { connect, Protocol, type Client } from "skipruntime-replication-client";

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const replication = 8081;
const port = 8082;
const url = `http://localhost:${port}`;
const creds = await Protocol.generateCredentials();

const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));

console.log("Connect to replication server for resource /user/123");

let header = {
  "X-Reactive-Auth": Buffer.from(publicKey.buffer).toString("base64"),
};
const [reactive, headers] = await fetchJSON(
  `${url}/auth/user/123`,
  "GET",
  header,
);

const client = await connect(`ws://localhost:${replication}`, creds);

await client.subscribe(
  reactive.collection,
  (updates: [string, TJSON[]][], isInit: boolean) => {
    console.log("Update", Object.fromEntries(updates), isInit);
  },
  BigInt(reactive.watermark),
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
