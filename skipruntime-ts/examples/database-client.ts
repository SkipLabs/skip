// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
import { fetchJSON } from "@skipruntime/helpers";

/*
  This is the client simulator of database example
*/

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const port = 8082;
const url = `http://localhost:${port.toString()}`;

console.log("Connect to replication server for resource /users");

const evSource = new EventSource(`${url}/users`);
evSource.addEventListener("init", (e: MessageEvent<string>) => {
  console.log("Init", e.data);
});
evSource.addEventListener("update", (e: MessageEvent<string>) => {
  console.log("Update", e.data);
});
evSource.onerror = (e) => {
  console.log(e);
};

await sleep(1000);

console.log('Set /user/123 to { name: "daniel", country: "UK" }');

await fetchJSON(`${url}/user/123`, "PUT", {
  body: { name: "daniel", country: "UK" },
});

console.log("Get /user/123", (await fetchJSON(`${url}/user/123`, "GET"))[0]);

await sleep(1000);
console.log("Delete /user/123");

await fetchJSON(`${url}/user/123`, "DELETE", {});

console.log("Get /user/123", (await fetchJSON(`${url}/user/123`, "GET"))[0]);

await sleep(1000);
evSource.close();
