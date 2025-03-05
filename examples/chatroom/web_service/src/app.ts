import { SkipServiceBroker } from "@skipruntime/helpers";

import express from "express";
import { Kafka } from "kafkajs";

import { init } from "./init.js";

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

function encode(
  msg: { author: string } & ({ body: string } | { message_id: number }),
): { value: string } {
  // generate numeric IDs by concatenating the current time with 4 digits of noise
  // so that IDs are temporally ordered and vanishingly unlikely to collide
  const timestamp= Date.now()
  const id = Math.floor(10_000 * (timestamp + Math.random()));
  return {
    value: JSON.stringify({
      ...msg,
      id,
      timestamp,
    }),
  };
}

const producer = { ...kafka.producer(), isConnected: false };
producer.on("producer.connect", () => {
  producer.isConnected = true;
  init(producer, encode);
});
producer.on("producer.disconnect", () => {
  producer.isConnected = false;
  //attempt to reconnect
  producer.connect();
});

producer.connect();

app.get("/messages", (_req, res) => {
  service
    .getStreamUUID("messages")
    .then((uuid) => {
      res.redirect(307, `/streams/${uuid}`);
    })
    .catch((e: unknown) => res.status(500).json(e));
});

app.put("/message", (req, res) => {
  const msg = encode(req.body);
  producer.send({ topic: "skip-chatroom-messages", messages: [msg] }).then(
    () => {
      res.status(200).json({});
    },
    (e) => {
      console.error("kafka producer error: ", e);
      throw e;
    },
  );
});
app.put("/like", (req, res) => {
  const like = encode(req.body);
  producer.send({ topic: "skip-chatroom-likes", messages: [like] }).then(
    () => res.status(200).json({}),
    (e) => {
      console.error("kafka producer error: ", e);
      throw e;
    },
  );
});

app.get("/healthcheck", (_req, res) => {
  if (producer.isConnected) res.status(200).json({});
  else res.status(503).json({ health_status: "Disconnected from Kafka" });
});

const port = 3031;
app.listen(port, () => {
  console.log(`Web backend listening at port ${port.toString()}`);
});
