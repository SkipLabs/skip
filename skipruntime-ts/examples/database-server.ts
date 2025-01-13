import { SkipServiceBroker } from "@skipruntime/helpers";

import express from "express";

/*
  This is the user facing server of the database example
*/

const service = new SkipServiceBroker({
  host: "localhost",
  control_port: 8081,
  streaming_port: 8080,
});

import Database from "better-sqlite3";

type User = {
  name: string;
  country: string;
};

const db = new Database("./db.sqlite");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/users", (_req, res) => {
  service
    .getStreamUUID("users")
    .then((uuid) => {
      res.redirect(301, `http://localhost:8080/v1/streams/${uuid}`);
    })
    .catch((e: unknown) => {
      console.log(e);
      res.status(500).json("Internal error");
    });
});

app.get("/user/:id", (req, res) => {
  service
    .getArray("users", {}, req.params.id)
    .then((user) => {
      res.status(200).json(user);
    })
    .catch((e: unknown) => {
      console.log(e);
      res.status(500).json("Internal error");
    });
});

app.put("/user/:id", (req, res) => {
  const key = req.params.id;
  const data = req.body as User;

  try {
    db.prepare(
      "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
    ).run({
      id: key,
      object: JSON.stringify(data),
    });

    service
      .put("users", key, [data])
      .then(() => {
        res.status(200).json({});
      })
      .catch((e: unknown) => {
        console.log(e);
        res.status(500).json("Internal error");
      });
  } catch (err) {
    console.error(err);
    res.status(500).json("Internal error");
  }
});

app.delete("/user/:id", (req, res) => {
  const key = req.params.id;

  try {
    db.prepare("DELETE FROM data WHERE id = $id").run({ id: key });

    service
      .deleteKey("users", key)
      .then(() => {
        res.status(200).json({});
      })
      .catch((e: unknown) => {
        console.log(e);
        res.status(500).json("Internal error");
      });
  } catch (err) {
    console.error(err);
    res.status(500).json("Internal error");
  }
});

const port = 8082;

app.listen(port, () => {
  console.log(`Example app listening on port ${port.toString()}`);
});
