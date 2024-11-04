import {
  type ReactiveResponse,
} from "@skipruntime/api";
import {
  fetchJSON,
} from "@skipruntime/helpers/rest.js";
import {
  parseReactiveResponse,
} from "@skipruntime/helpers";
import { connect, Protocol } from "@skipruntime/client";
import type { TJSON } from "@skipruntime/client/protocol.js";
import { newID } from "./skipsocial-utils.js";

/*
  This is the client simulator of skipsocial example
*/

/*
async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
*/
const replication = 8081;
const port = 8082;
const url = `http://localhost:${port.toString()}`;
const creds = await Protocol.generateCredentials();

const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));

const header = {
  "X-Reactive-Auth": Buffer.from(publicKey.buffer).toString("base64"),
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

const client = await connect(`ws://localhost:${replication.toString()}`, creds);

client.subscribe(
  reactive.collection,
  reactive.watermark,
  (updates: [string, TJSON[]][], isInit: boolean) => {
    console.log("Update", Object.fromEntries(updates), isInit);
  },
);

/*****************************************************************************/
// Testing friend requests
/*****************************************************************************/

const userID1 = "users-1";
const userID2 = "users-2";
const userID3 = "users-3";

await fetchJSON(`${url}/user/${userID1}`, "PUT", {}, { country: "FR" });

await fetchJSON(`${url}/user/${userID2}`, "PUT", {}, { country: "UK" });

await fetchJSON(`${url}/user/${userID3}`, "PUT", {}, { country: "UK" });

await fetchJSON(
  `${url}/friend-request/${newID("friendRequests")}`,
  "PUT",
  {},
  { from: userID2, to: userID1 },
);

await fetchJSON(
  `${url}/friend-request/${newID("friendRequests")}`,
  "PUT",
  {},
  { from: userID1, to: userID2 },
);

await fetchJSON(
  `${url}/friend-request/${newID("friendRequests")}`,
  "PUT",
  {},
  { from: userID3, to: userID1 },
);

await fetchJSON(
  `${url}/friend-request/${newID("friendRequests")}`,
  "PUT",
  {},
  { from: userID1, to: userID3 },
);

const friends2 = await fetchJSON(`${url}/friend/${userID1}`, "GET", header);
const areFriends = await fetchJSON(
  `${url}/friend-index/${userID1}:${userID2}`,
  "GET",
  header,
);

console.log(friends2);
console.log(areFriends);

/*****************************************************************************/
/* Testing messages */
/*****************************************************************************/

await fetchJSON(
  `${url}/message/${newID("messages")}`,
  "PUT",
  {},
  { from: userID3, to: userID1, content: "Hello from userID3" },
);

await fetchJSON(
  `${url}/message/${newID("messages")}`,
  "PUT",
  {},
  { from: userID2, to: userID1, content: "Hello from userID2" },
);

await fetchJSON(
  `${url}/message/${newID("messages")}`,
  "PUT",
  {},
  { from: userID2, to: userID1, content: "Another hello from userID2" },
);

const params = new URLSearchParams({
  userID: userID1,
});

console.log(
  await fetchJSON(`${url}/messages/${userID1}?${params}`, "GET", header),
);

/*****************************************************************************/
/* Testing groups */
/*****************************************************************************/

/*
const groupID = "groupid-1";

await fetchJSON(
  `${url}/group/${groupID}`,
  "PUT",
  {},
  { name: "this is my first group!", owner: userID1 },
);

await fetchJSON(
  `${url}/group-member/${groupID}`,
  "PUT",
  {},
  { groupID, userID: userID2 },
);

*/

/*
await fetchJSON(
  `${url}/message/${userID1}`,
  "PUT",
  {},
  { from: 'id-user-2', content: "Salut!"},
);

console.log(await fetchJSON(
  `${url}/friend/${userID2}`,
  "GET",
  header,
));


console.log(await fetchJSON(
  `${url}/group/${groupID}`,
  "GET",
  header,
));
*/

/*
const postID = "post-816"
const commentID = "comment-817"

await fetchJSON(
  `${url}/post/${postID}`,
  "PUT",
  {},
  { content: "First post from julien!", userID: "123" },
);
console.log("PUT POST DONE");

console.log("FETCH" + await fetchJSON(
  `${url}/post/${postID}`,
  "GET",
  header,
));
console.log("FETCH POST DONE");

await fetchJSON(
  `${url}/comment/${commentID}`,
  "PUT",
  {},
  { postID, content: "First comment from julien!", userID: "123" },
);

console.log("PUT COMMENT DONE");



await sleep(1000);


console.log(
  "Get /post/" + postID,
  (await fetchJSON(`${url}/post/${postID}`, "GET", header))[0],
);
*/

/*

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

console.log(
  "Get /user/123",
  (await fetchJSON(`${url}/user/123`, "GET", header))[0],
);

await sleep(1000);
*/
client.close();
