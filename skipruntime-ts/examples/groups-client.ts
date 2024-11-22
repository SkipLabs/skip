// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";
import { fetchJSON } from "@skipruntime/helpers/rest.js";

async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const restPort = 8990;
const reactivePort = 8991;
const restURL = `http://localhost:${restPort.toString()}`;

console.log("Connecting to reactive server for resource /activeFriends");

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

await sleep(1000);

console.log(
  "getting /activeFriends/1/1...",
  await fetchJSON(`${restURL}/activeFriends/1/1`),
);
