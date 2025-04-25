// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
import { fetchJSON } from "@skipruntime/helpers";
import { sleep } from "./utils.js";

const port = 8082;

const url = `http://localhost:${port.toString()}`;

/*****************************************************/
/* SET UP EVENT SOURCE LISTENING TO REACTIVE SERVICE */
/*****************************************************/

console.log("Listening for Bob's active friends in each group...");
const evSource = new EventSource(`${url}/active_friends/0`);
evSource.addEventListener("init", (e: MessageEvent<string>) => {
  const initial_data = JSON.parse(e.data);
  console.log("Initial data: ", initial_data);
});
evSource.addEventListener("update", (e: MessageEvent<string>) => {
  const updates = JSON.parse(e.data);
  console.log("Updated data: ", updates);
});
evSource.onerror = console.error;

/**************************************************/
/*       BEGIN SCENARIO OF CHANGING INPUTS        */
/**************************************************/

await sleep(500);
console.log("Setting Carol to active...");
await fetchJSON(`${url}/users/2`, "PUT", {
  body: { name: "Carol", active: true, friends: [0, 1] },
});

await sleep(100);
console.log("Setting Alice to inactive...");
await fetchJSON(`${url}/users/1`, "PUT", {
  body: { name: "Alice", active: false, friends: [0, 2] },
});

await sleep(100);
console.log("Setting Eve as Bob's friend...");
await fetchJSON(`${url}/users/0`, "PUT", {
  body: { name: "Bob", active: true, friends: [1, 2, 3] },
});

await sleep(100);
console.log("Removing Carol and adding Eve to group 2...");
await fetchJSON(`${url}/groups/1002`, "PUT", {
  body: { name: "Group 2", members: [0, 3] },
});

await sleep(100);
console.log("Setting Bob to have no friends :( ...");
await fetchJSON(`${url}/users/0`, "PUT", {
  body: { name: "Bob", active: true, friends: [] },
});

await sleep(100);
console.log("Setting Carol as Bob's friend ...");
await fetchJSON(`${url}/users/0`, "PUT", {
  body: { name: "Bob", active: true, friends: [2] },
});

await sleep(100);
console.log("Closing listener event stream...");
evSource.close();
