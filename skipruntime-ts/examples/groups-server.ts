import { RESTWrapperOfSkipService } from "@skipruntime/helpers/rest.js";

import express from "express";

const service = new RESTWrapperOfSkipService({
  host: "localhost",
  port: 8991,
});

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/active_friends/:uid/:gid", (req, res) => {
  service
    .getArray("active_friends", { uid: req.params.uid }, req.params.gid)
    .then((actives) => {
      res.status(200).json(actives);
    })
    .catch((e: unknown) => {
      res.status(500).json(e);
    });
});

app.put("/users/:uid", (req, res) => {
  service
    .put("users", req.params.uid, [req.body])
    .then(() => {
      res.status(200).json({});
    })
    .catch((e: unknown) => {
      console.error("express error: ", e);
      res.status(500).json(e);
    });
});

app.put("/groups/:gid", (req, res) => {
  service
    .put("groups", req.params.gid, [req.body])
    .then(() => {
      res.status(200).json({});
    })
    .catch((e: unknown) => {
      console.error("express error: ", e);
      res.status(500).json(e);
    });
});

const port = 8990;
app.listen(port, () => {
  console.log(`Groups REST wrapper listening at port ${port.toString()}`);
});
