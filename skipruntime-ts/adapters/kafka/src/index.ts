import type { Entry, ExternalService, Json } from "@skipruntime/core";

import { Kafka, logLevel as kafkaLogLevel } from "kafkajs";

import type { Consumer, ConsumerConfig } from "kafkajs";

/**
 * Adapter for easily creating Kafka _consumers_, subscribing to external event/message streams and exposing their content as eager collections within the Skip runtime.
 */
export class KafkaExternalService implements ExternalService {
  private consumers: Map<string, Consumer> = new Map<string, Consumer>();
  private consumerOptions: ConsumerConfig;
  private client: Kafka;

  constructor(
    kafka_config: {
      clientId: string;
      brokers: { host: string; port: number }[];
      logLevel?: kafkaLogLevel;
    },
    consumerOptions: Omit<ConsumerConfig, "groupId"> = {},
  ) {
    const brokers = kafka_config.brokers.map(
      (obj) => `${obj.host}:${obj.port}`,
    );
    const logLevel: kafkaLogLevel =
      kafka_config.logLevel ?? kafkaLogLevel.ERROR;

    this.client = new Kafka({ ...kafka_config, brokers, logLevel });
    const groupId =
      "skip_kafka_consumer_" + Math.random().toString(36).slice(2);
    this.consumerOptions = { ...consumerOptions, groupId };
  }

  /**
   * Subscribe to a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param topic - Name of the Kafka topic to expose as a resource.
   * @param params - Parameters of the external resource. TODO document special options here
   * @param callbacks - Callbacks to react on error/loading/update.
   * @param callbacks.error - Error callback.
   * @param callbacks.loading - Loading callback.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  subscribe(
    instance: string,
    topic: string,
    params: Json & { fromBeginning?: boolean },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {
    callbacks.update([], true);
    const consumer = this.client.consumer(this.consumerOptions);
    const fromBeginning = params.fromBeginning ?? true;
    const setup = async () => {
      await consumer.connect();
      await consumer.subscribe({ topic, fromBeginning });
      await consumer.run({
        // eslint-disable-next-line @typescript-eslint/require-await
        eachBatch: async ({ batch }) => {
          const entries: Map<string, string[]> = new Map<string, string[]>();
          batch.messages.forEach((msg) => {
            const key = String(msg.key);
            const val = String(msg.value);
            if (entries.has(key)) entries.get(key)!.push(val);
            else entries.set(key, [val]);
          });
          callbacks.update(Array.from(entries), false);
        },
      });
    };
    setup().then(
      () => this.consumers.set(instance, consumer),
      (e: unknown) => {
        console.error("Error setting up Kafka subscription: ", e);
        throw e;
      },
    );
  }

  unsubscribe(instance: string): void {
    const consumer: Consumer | undefined = this.consumers.get(instance);
    if (consumer !== undefined) {
      this.consumers.delete(instance);
      consumer.disconnect().catch((e: unknown) => {
        console.error(`Error disconnecting Kafka consumer ${instance}: ${e}`);
        throw e;
      });
    }
  }

  private async _shutdown(): Promise<void> {
    const consumers = Array.from(this.consumers.values());
    this.consumers.clear();
    await Promise.all(Array.from(consumers, (c: Consumer) => c.disconnect()));
  }

  shutdown(): void {
    this._shutdown().catch((e: unknown) => {
      console.error(`Error shutting down KafkaExternalService: ${e}`);
      throw e;
    });
  }
}
