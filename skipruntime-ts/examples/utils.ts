// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import EventSource from "eventsource";

import type { Json } from "@skipruntime/core";
import { SkipServiceBroker } from "@skipruntime/helpers";

export async function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export async function subscribe(
  service: SkipServiceBroker,
  resource: string,
  streaming_port: number,
  params: Json = {},
): Promise<{ close: () => void }> {
  return await service.getStreamUUID(resource, params).then((uuid) => {
    const evSource = new EventSource(
      `http://localhost:${streaming_port}/v1/streams/${uuid}`,
    );
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const updates = JSON.parse(e.data);
      console.log("Init", updates);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const updates = JSON.parse(e.data);
      console.log("Update", updates);
    });
    evSource.onerror = (e: MessageEvent<string>) => {
      console.log("Error", e);
    };
    return evSource;
  });
}
