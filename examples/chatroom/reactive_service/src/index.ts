import type { Entry, ExternalService, Json } from "@skipruntime/core";

import { Kafka, logLevel as kafkaLogLevel } from "kafkajs";

import type { Consumer, ConsumerConfig } from "kafkajs";

/**
 * Adapter for easily creating Kafka _consumers_, subscribing to external event/message streams and exposing their content as eager collections within the Skip runtime.
 */
export class KafkaExternalService implements ExternalService {
  private consumers: Map<string, Consumer> = new Map<string, Consumer>();
  private consumerOptions: Omit<ConsumerConfig, "groupId">;
  private client: Kafka;
  private messageProcessor: (msg: {
    key: string;
    value: string;
    topic: string;
  }) => Iterable<[Json, Json]>;

  constructor(
    kafka_config: {
      clientId: string;
      brokers: { host: string; port: number }[];
      logLevel?: kafkaLogLevel;
    },
    messageProcessor: (msg: {
      key: string;
      value: string;
      topic: string;
    }) => Iterable<[Json, Json]> = (msg) => [[msg.key, msg.value]],
    consumerOptions: Omit<ConsumerConfig, "groupId"> = {},
  ) {
    const brokers = kafka_config.brokers.map(
      (obj) => `${obj.host}:${obj.port}`,
    );
    const logLevel: kafkaLogLevel = kafka_config.logLevel ?? kafkaLogLevel.INFO;

    this.client = new Kafka({ ...kafka_config, brokers, logLevel });
    this.messageProcessor = messageProcessor;
    this.consumerOptions = consumerOptions;
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
    const consumer = this.client.consumer({
      ...this.consumerOptions,
      groupId: instance,
    });
    const fromBeginning = params.fromBeginning ?? true;
    const setup = async () => {
      let retries = 0;
      await consumer.connect();
      while (retries <= 5) {
        await consumer.subscribe({ topic, fromBeginning });
        await consumer.run({
          eachBatch: async ({ batch }) => {
            const entries: Map<Json, Json[]> = new Map<Json, Json[]>();
            batch.messages.forEach((msg) => {
              try {
                for (const [k, v] of this.messageProcessor({
                  key: String(msg.key),
                  value: String(msg.value),
                  topic,
                })) {
                  if (entries.has(k)) entries.get(k)!.push(v);
                  else entries.set(k, [v]);
                }
              } catch (e) {
                console.error(e);
              }
            });
            callbacks.update(Array.from(entries), false);
          },
        });
        const desc = await consumer.describeGroup();
        if (desc.state == "Stable") break;
        await new Promise((r) => setTimeout(r, 500 + 2 ** retries * 500));
        retries += 1;
      }
    };
    setup().then(() => this.consumers.set(instance, consumer));
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

  async shutdown(): Promise<void> {
    const consumers = Array.from(this.consumers.values());
    this.consumers.clear();
    await Promise.all(Array.from(consumers, (c: Consumer) => c.disconnect()));
  }
}
