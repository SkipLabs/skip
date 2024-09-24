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
app.get("/auth/user/:id", async (req, res) => {
  try {
    const key = req.params.id;
    const strReactiveAuth = req.headers["x-reactive-auth"] as string;
    if (!strReactiveAuth) throw new Error("X-Reactive-Auth must be specified.");
    const reactiveAuth = new Uint8Array(Buffer.from(strReactiveAuth, "base64"));
    const reactiveResponse = await runtime.head(
      "user",
      { userId: key },
      reactiveAuth,
    );
    res.status(200).json(reactiveResponse);
  } catch (_e: any) {
    res.status(500).json("Internal error");
  }
});

app.put("/user/:id", async (req, res) => {
  const key = req.params.id;
  const data: User = req.body;
  try {
    await run(
      "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
      {
        $id: key,
        $object: JSON.stringify(data),
      },
    );
    await runtime.put("users", key, [data]);
    res.status(200).json({});
  } catch (_e: any) {
    res.status(500).json("Internal error");
  }
});
app.delete("/user/:id", async (req, res) => {
  try {
    const key = req.params.id;
    await run("DELETE FROM data WHERE id = $id", { $id: key });
    await runtime.delete("users", key);
    res.status(200).json({});
  } catch (_e: any) {
    res.status(500).json("Internal error");
  }
});

const port = 8082;

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
