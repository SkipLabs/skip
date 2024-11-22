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
    .catch(() => {
      res.status(500).json("Internal error");
    });
});

const port = 8990;
app.listen(port, () => {
  console.log(`Groups REST wrapper listening at port ${port.toString()}`);
});
