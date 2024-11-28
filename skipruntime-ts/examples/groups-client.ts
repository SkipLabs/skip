// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
import { fetchJSON } from "@skipruntime/helpers/rest.js";

const port = 8082;

const url = `http://localhost:${port.toString()}/`;
async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/*****************************************************/
/* SET UP EVENT SOURCE LISTENING TO REACTIVE SERVICE */
/*****************************************************/

console.log("Listening for Bob's active friends in each group...");
const evSource = new EventSource(`${url}/active_friends/bob`);

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

await sleep(1000);
console.log("Setting Carol to active...");
await fetchJSON(
  `${url}/users/carol`,
  "PUT",
  {},
  { name: "Carol", active: true, friends: ["bob", "alice"] },
);

await sleep(1000);
console.log("Setting Alice to inactive...");
await fetchJSON(
  `${url}/users/alice`,
  "PUT",
  {},
  { name: "Alice", active: false, friends: ["bob", "carol"] },
);

await sleep(1000);
console.log("Setting Eve as Bob's friend...");
await fetchJSON(
  `${url}/users/bob`,
  "PUT",
  {},
  { name: "Bob", active: true, friends: ["alice", "carol", "eve"] },
);

await sleep(1000);
console.log("Removing Carol and adding Eve to group 2...");
await fetchJSON(
  `${url}/groups/group2`,
  "PUT",
  {},
  { name: "Group 2", members: ["bob", "eve"] },
);

await sleep(1000);
console.log("Closing listener event stream...");
evSource.close();
