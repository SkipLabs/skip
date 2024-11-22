// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
import { fetchJSON } from "@skipruntime/helpers/rest.js";

const restPort = 8990;
const reactivePort = 8991;

const restURL = `http://localhost:${restPort.toString()}`;
async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/*****************************************************/
/* SET UP EVENT SOURCE LISTENING TO REACTIVE SERVICE */
/*****************************************************/

console.log("Listening for Bob's active friends in each group...");
const evSource = new EventSource(
  `http://localhost:${reactivePort.toString()}/v1/active_friends?uid=bob`,
);
evSource.addEventListener("init", (e: MessageEvent<string>) => {
  const updates = JSON.parse(e.data);
  console.log("Initial data: ", updates);
});
evSource.addEventListener("update", (e: MessageEvent<string>) => {
  const updates = JSON.parse(e.data);
  console.log("Updated data: ", updates);
});
evSource.onerror = console.error;

/**************************************************/
/*       BEGIN SCENARIO OF CHANGING INPUTS        */
/**************************************************/

console.log("Getting Bob's active friends in group #1...");
console.log(
  "result: ",
  (await fetchJSON(`${restURL}/active_friends/bob/group1`, "GET"))[0],
);

await sleep(1000);
console.log("Setting Carol to active...");
await fetchJSON(
  `${restURL}/users/carol`,
  "PUT",
  {},
  { name: "Carol", active: true, friends: ["bob", "alice"] },
);

await sleep(1000);
console.log("Setting Alice to inactive...");
await fetchJSON(
  `${restURL}/users/alice`,
  "PUT",
  {},
  { name: "Alice", active: false, friends: ["bob", "carol"] },
);

await sleep(1000);
console.log("Setting Eve as Bob's friend...");
await fetchJSON(
  `${restURL}/users/bob`,
  "PUT",
  {},
  { name: "Bob", active: true, friends: ["alice", "carol", "eve"] },
);

await sleep(1000);
console.log("Removing Carol and adding Eve to group 2...");
await fetchJSON(
  `${restURL}/groups/group2`,
  "PUT",
  {},
  { name: "Group 2", members: ["bob", "eve"] },
);

await sleep(1000);
console.log("Closing listener event stream...");
evSource.close();
