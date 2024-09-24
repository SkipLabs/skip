import { SkipRESTRuntime } from "skip-runtime";

import express from "express";

const runtime = new SkipRESTRuntime({
  host: "localhost",
  port: 8081,
});

import sqlite3 from "sqlite3";

type User = {
  name: string;
  country: string;
};

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
app.get("/auth/user/:id", (req, res) => {
  const key = req.params.id;
  const strReactiveAuth = req.headers["x-reactive-auth"] as string;
  if (!strReactiveAuth) {
    console.error("X-Reactive-Auth must be specified.");
    res.status(500).json("Internal error");
    return;
  }
  const reactiveAuth = new Uint8Array(Buffer.from(strReactiveAuth, "base64"));
  runtime
    .head("user", { userId: key }, reactiveAuth)
    .then((reactiveResponse) => {
      res.status(200).json(reactiveResponse);
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
    .then(() => runtime.put("users", key, [data]))
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
    .then(() => runtime.delete("users", key))
    .then(() => {
      res.status(200).json({});
    })
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

const port = 8082;

app.listen(port, () => {
  console.log(`Example app listening on port ${port.toString()}`);
});
