import { SkipServiceBroker } from "@skipruntime/helpers";

import express from "express";
import { Kafka } from "kafkajs";

const service = new SkipServiceBroker({
  host: "reactive_cache",
  control_port: 8081,
  streaming_port: 8080,
});

const app = express();

app.use(express.json());

const kafka = new Kafka({
  brokers: ["kafka:19092"],
  clientId: "web-backend",
});
const producer = kafka.producer();

// generate numeric IDs by concatenating the current time with 4 digits of noise
// so that IDs are ordered and vanishingly unlikely to collide
function gensym(): number {
  return Math.floor(10000 * (Date.now() + Math.random()));
}

app.get("/", (_req, res) => {
  service
    .getStreamUUID("messages")
    .then((uuid) => res.redirect(307, `/streams/${uuid}`))
    .catch((e: unknown) => res.status(500).json(e));
});

app.put("/message", (req, res) => {
  const msg = { ...req.body, id: gensym() };
  producer.send({ topic: "skip-chatroom-messages", messages: [msg] }).then(
    () => res.status(200).json({}),
    (e) => {
      console.error("kafka producer error: ", e);
      throw e;
    },
  );
});
app.put("/like", (req, res) => {
  const like = { ...req.body, id: gensym() };
  producer.send({ topic: "skip-chatroom-likes", messages: [like] }).then(
    () => res.status(200).json({}),
    (e) => {
      console.error("kafka producer error: ", e);
      throw e;
    },
  );
});

app.get("/healthcheck", (_req, res) => {
  res.status(200).json({});
});

const port = 3031;
app.listen(port, () => {
  console.log(`Web backend listening at port ${port.toString()}`);
});
