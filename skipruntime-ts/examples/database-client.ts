import type { ReactiveResponse } from "@skipruntime/api";
import { parseReactiveResponse } from "@skipruntime/helpers";
import { fetchJSON } from "@skipruntime/helpers/rest.js";

/*
  This is the client simulator of database example
*/

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const replication = 8081;
const port = 8082;
const url = `http://localhost:${port.toString()}`;

console.log("Connect to replication server for resource /users");

const header = {
  "Skip-Reactive-Auth": Buffer.from(publicKey.buffer).toString("base64"),
};
const [_e, headers] = await fetchJSON<ReactiveResponse>(
  `${url}/auth/users`,
  "HEAD",
  header,
);

const reactive = parseReactiveResponse(headers);

if (!reactive) {
  throw new Error("Reactive response must be supplied.");
}

const evSource = new EventSource(`//localhost:${replication.toString()}`);
evSource.onmessage = (e) => {
  const msg = JSON.parse(e.data);
  console.log("Update", Object.fromEntries(msg.updates), msg.isInit);
};

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
