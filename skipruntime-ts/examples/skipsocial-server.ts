import { SkipRESTService } from "@skipruntime/helpers/rest.js";
import { type TJSON } from "@skipruntime/api";
import { reactiveResponseHeader } from "@skipruntime/helpers";
import { type ParsedQs } from "qs";

import type { Comment } from "./skipsocial.js";
import express from "express";

/*
  This is the user facing server of the skipsocial example
*/

const skipService = new SkipRESTService({
  host: "localhost",
  port: 8081,
});

import sqlite3 from "sqlite3";

/*
type User = {
  name: string;
  country: string;
};
*/

const db = new sqlite3.Database("./db.sqlite");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// WRITES

const run = function (
  query: string,
  params: Record<string, string>,
): Promise<void> {
  return new Promise((resolve, reject) => {
    db.run(query, params, (err) => {
      if (err) reject(err);
      else resolve();
    });
  });
};

/*****************************************************************************/
/*****************************************************************************/

app.head("/auth/users", (req, res) => {
  const strReactiveAuth = req.headers["x-reactive-auth"] as string;
  if (!strReactiveAuth) {
    console.error("X-Reactive-Auth must be specified.");
    res.status(500).json("Internal error");
    return;
  }
  const reactiveAuth = new Uint8Array(Buffer.from(strReactiveAuth, "base64"));
  skipService
    .head("users", {}, reactiveAuth)
    .then((reactiveResponse) => {
      const [name, value] = reactiveResponseHeader(reactiveResponse);
      res.set(name, value);
      res.status(200).json({});
    })
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

/*

app.get("/user/:id", (req, res) => {
  const strReactiveAuth = req.headers["x-reactive-auth"] as string;
  if (!strReactiveAuth) {
    console.error("X-Reactive-Auth must be specified.");
    res.status(500).json("Internal error");
    return;
  }
  skipService
    .getArray("users", {}, "123", strReactiveAuth)
    .then((user) => {
      res.status(200).json(user);
    })
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

app.put("/user/:id", (req, res) => {
  const key = req.params.id;
  const data = req.body as User;
  run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: key,
    $object: JSON.stringify(data),
  })
    .then(() => skipService.put("users", key, [data]))
    .then(() => {
      res.status(200).json({});
    })
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

app.delete("/user/:id", (req, res) => {
  const key = req.params.id;
  run("DELETE FROM data WHERE id = $id", { $id: key })
    .then(() => skipService.deleteKey("users", key))
    .then(() => {
      res.status(200).json({});
    })
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

*/

/*****************************************************************************/
// Error processing
/*****************************************************************************/

class Error {
  constructor(
    public code: number,
    public msg: string,
  ) {}
}

function processError(
  kind: string,
  id: string,
  e: unknown,
  res: { status: (code: number) => { json: (msg: string) => void } },
): void {
  if (e instanceof Error) {
    console.error(kind + " ERROR: " + id + " " + e.msg);
    res.status(e.code).json(e.msg);
  } else {
    console.error(kind + " ERROR: " + id + " " + e);
    res.status(500).json("Internal error");
  }
}

/*****************************************************************************/
/* Checks */
/*****************************************************************************/

function checkIsObject(object: unknown): void {
  if (typeof object !== "object" || object === null || Array.isArray(object)) {
    throw new Error(
      400,
      "The value is not an object: " + JSON.stringify(object),
    );
  }
}

function getString(params: { object: unknown; fieldName: string }): string {
  const object = params.object;
  const fieldName = params.fieldName;
  if (typeof object !== "object" || object === null) {
    throw new Error(
      400,
      "The value is not an object: " + JSON.stringify(object),
    );
  }
  if (fieldName in object) {
    const field = (object as Record<string, unknown>)[fieldName];
    if (typeof field !== "string") {
      throw new Error(
        400,
        "The field " + fieldName + " is not a string in object: " + field,
      );
    }
    return (object as Record<string, string>)[fieldName]!;
  }
  throw new Error(
    400,
    "The field " +
      fieldName +
      " is not defined in object: " +
      JSON.stringify(object),
  );
}

function getOptionalString(params: {
  object: unknown;
  fieldName: string;
}): string | undefined {
  const object = params.object;
  const fieldName = params.fieldName;
  if (typeof object !== "object" || object === null) {
    throw new Error(
      400,
      "The value is not an object: " + JSON.stringify(object),
    );
  }
  if (fieldName in object) {
    const field = (object as Record<string, unknown>)[fieldName];
    if (typeof field !== "string") {
      throw new Error(
        400,
        "The field " +
          fieldName +
          " is not a string in object: " +
          JSON.stringify(object),
      );
    }
    return (object as Record<string, string>)[fieldName];
  }
  return undefined;
}

async function checkIsValidID(params: {
  skipService: SkipRESTService;
  desc: string;
  resource: string;
  id: string;
}): Promise<void> {
  const desc = params.desc;
  const resource = params.resource;
  const id = params.id;
  const values = await skipService.getArray(resource, {}, id);
  if (values.length === 0) {
    throw new Error(
      400,
      desc + " is not a valid id [ID=" + id + "] for the resource: " + resource,
    );
  }
}

async function checkIsNotTakenID(params: {
  skipService: SkipRESTService;
  desc: string;
  resource: string;
  id: string;
}): Promise<void> {
  const desc = params.desc;
  const resource = params.resource;
  const id = params.id;
  const values = await skipService.getArray(resource, {}, id);
  if (values.length !== 0) {
    throw new Error(
      400,
      desc +
        " id [ID=" +
        id +
        "] is already taken, for the resource: " +
        resource,
    );
  }
}

/*****************************************************************************/
/* Handlers */
/*****************************************************************************/

type PUTValidationHandler = (
  skipService: SkipRESTService,
  id: string,
  object: TJSON,
) => Promise<void>;

type GETValidationHandler = (
  skipService: SkipRESTService,
  id: string,
  object: ParsedQs,
) => Promise<void>;

function createPUT(
  action: string,
  collection: string,
  validate: PUTValidationHandler = async (_r, _i, _o) => {},
): void {
  app.put("/" + action + "/:id", async (req, res) => {
    const id = req.params["id"]!;
    try {
      if (id.includes("/") || id.includes(":")) {
        throw new Error(400, "Identifier contains a /: " + id);
      }
      const value = req.body;
      const timestamp = Date.now();
      let object = { id, action, timestamp, ...value };
      await validate(skipService, id, object);
      await run("INSERT INTO data (id, object) VALUES ($id, $object)", {
        $id: collection + "-" + id,
        $object: JSON.stringify(object),
      });
      await skipService.put(collection, id, [object]);
      console.log("PUT: " + action + " " + id);
      await res.status(200).json({});
    } catch (e) {
      processError("PUT", id, e, res);
    }
  });
}

function createGET(
  type: string,
  resource: string,
  validate: GETValidationHandler = async (_r, _i, _o) => {},
): void {
  app.get("/" + type + "/:id", async (req, res) => {
    const id = req.params["id"]!;
    try {
      const strReactiveAuth = req.headers["x-reactive-auth"] as string;
      if (!strReactiveAuth) {
        console.error("X-Reactive-Auth must be specified.");
        res.status(500).json("Internal error");
        return;
      }
      if (typeof req.query !== "object") {
        throw new Error(
          400,
          "Query is not an object: " + JSON.stringify(req.query),
        );
      }
      let query = req.query as Record<string, string>;
      if (req.query === null) {
        query = {};
      }
      await validate(skipService, id, query);
      const value = await skipService.getArray(resource, query, id, strReactiveAuth);
      await res.status(200).json(value);
      console.log("GET: " + type + " " + id);
    } catch (e) {
      processError("GET", id, e, res);
    }
  });
}

createPUT("user", "users");

createPUT("post", "posts");
createGET("post", "fullPosts");
createPUT("comment", "comments", async (skipService, _commentID, commentParam) => {
  const comment = commentParam as Comment;
  const post = await skipService.getArray("fullPosts", {}, comment.postID);
  if (post.length === 0) {
    throw new Error(400, "Attempting to comment on non-existing post");
  }
});

createPUT("friend-request", "friendRequests", async (skipService, id, object) => {
  checkIsObject(object);
  await checkIsNotTakenID({
    skipService,
    desc: "The request id",
    resource: "friendRequests",
    id,
  });
  const to = getString({ object, fieldName: "to" });
  await checkIsValidID({
    skipService,
    desc: "The user",
    resource: "users",
    id: to,
  });
  const from = getString({ object, fieldName: "from" });
  await checkIsValidID({
    skipService,
    desc: "The user",
    resource: "users",
    id: from,
  });
  // Checking if request already exists
  const present = await skipService.getArray(
    "friendRequestsIndex",
    {},
    from + ":" + to,
  );
  if (present.length !== 0) {
    throw new Error(400, "Friend request already sent");
  }
});

/*****************************************************************************/
/* Friends resource */
/*****************************************************************************/

createGET("friend", "friends");
createGET("friend-index", "friendIndex");

/*****************************************************************************/
/* Messages */
/*****************************************************************************/

createPUT("message", "messages", async (skipService, messageID, object) => {
  checkIsObject(object);
  await checkIsNotTakenID({
    skipService,
    desc: "The ID",
    resource: "users",
    id: messageID,
  });
  const from = getString({ object, fieldName: "from" });
  await checkIsValidID({
    skipService,
    desc: "The field from",
    resource: "users",
    id: from,
  });
  const to = getString({ object, fieldName: "to" });
  await checkIsValidID({
    skipService,
    desc: "The field to",
    resource: "users",
    id: to,
  });
  getString({ object, fieldName: "content" });
});

createGET("messages", "messagesForUser", async (_skipService, id, object) => {
  const userID = getString({ object, fieldName: "userID" });
  if (id !== userID) {
    throw new Error(
      400,
      "Expected the id (" + id + ") and userID (" + userID + ") to be equal",
    );
  }
});

/*****************************************************************************/
/* Groups */
/*****************************************************************************/

createPUT("group", "groups", async (skipService, groupID, object) => {
  checkIsObject(object);
  await checkIsNotTakenID({
    skipService,
    desc: "The request id",
    resource: "groups",
    id: groupID,
  });
  getOptionalString({ object, fieldName: "name" });
  getOptionalString({ object, fieldName: "desc" });
  const owner = getString({ object, fieldName: "owner" });
  await checkIsValidID({
    skipService,
    desc: "The field owner",
    resource: "users",
    id: owner,
  });
});

createGET("group", "groups");

/*****************************************************************************/
/* Group members */
/*****************************************************************************/

createPUT("group-member", "groupMembers", async (skipService, id, object) => {
  checkIsObject(object);
  await checkIsNotTakenID({
    skipService,
    desc: "The request id",
    resource: "groupMembers",
    id,
  });
  const groupID = getString({ object, fieldName: "groupID" });
  await checkIsValidID({
    skipService,
    desc: "The groupID",
    resource: "groups",
    id: groupID,
  });
  const userID = getString({ object, fieldName: "userID" });
  await checkIsValidID({
    skipService,
    desc: "The userID",
    resource: "users",
    id: userID,
  });
  await checkIsNotTakenID({
    skipService,
    desc: "The groupID:memberID",
    resource: "groupMemberIndex",
    id: groupID + ":" + userID,
  });
});

const port = 8082;

app.listen(port, () => {
  console.log(`Example app listening on port ${port.toString()}`);
});
