import { RESTWrapperOfSkipService } from "@skipruntime/helpers/rest.js";

import express from "express";

const service = new RESTWrapperOfSkipService({
  host: "localhost",
  control_port: 8081,
  streaming_port: 8080,
});

const app = express();

app.use(express.json());

app.get("/active_friends/:uid", (req, res) => {
  service
    .getStreamUUID("active_friends", { uid: req.params.uid })
    .then((uuid) => {
      res.redirect(301, `http://localhost:8080/v1/streams/${uuid}`);
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

const port = 8082;
app.listen(port, () => {
  console.log(`Groups REST wrapper listening at port ${port.toString()}`);
});
