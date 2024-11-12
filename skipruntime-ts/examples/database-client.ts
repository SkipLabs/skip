// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
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

const evSource = new EventSource(
  `http://localhost:${replication.toString()}/v1/users`,
);
evSource.onmessage = (e: MessageEvent<string>) => {
  const msg = JSON.parse(e.data);
  console.log("Update", msg.values, msg.isInitial);
};
evSource.onerror = (e) => {
  console.log(e);
};

await sleep(1000);

console.log('Set /user/123 to { name: "daniel", country: "UK" }');

await fetchJSON(
  `${url}/user/123`,
  "PUT",
  {},
  { name: "daniel", country: "UK" },
);

console.log("Get /user/123", (await fetchJSON(`${url}/user/123`, "GET"))[0]);

await sleep(1000);
console.log("Delete /user/123");

await fetchJSON(`${url}/user/123`, "DELETE", {});

console.log("Get /user/123", (await fetchJSON(`${url}/user/123`, "GET"))[0]);

await sleep(1000);
evSource.close();
