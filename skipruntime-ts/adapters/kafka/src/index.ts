/**
 * This is an adapter to connect Kafka clusters to the Skip Framework, allowing topics of the cluster to be exposed as Skip collections.
 *
 * @packageDocumentation
 */

import type { Entry, ExternalService, Json } from "@skipruntime/core";

import { Kafka, logLevel as kafkaLogLevel } from "kafkajs";

import type { Consumer, ConsumerConfig } from "kafkajs";

/**
 * An `ExternalService` wrapping a Kafka cluster, exposing its *topics* as *collections* in the Skip runtime.
 *
 * This adapter allows to easily create Kafka _consumers_, subscribing to external event/message streams and exposing their content as eager collections within the Skip runtime.
 *
 * For a usage example, refer [here](https://github.com/SkipLabs/skip/tree/main/examples/chatroom).
 *
 * @remarks
 * Subscription `params` may specify a `fromBeginning` boolean, which controls whether to consume all Kafka messages from the cluster, or only those sent since the creation of this external resource.
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
    const logLevel: kafkaLogLevel =
      kafka_config.logLevel ?? kafkaLogLevel.ERROR;

    this.messageProcessor = messageProcessor;
    this.consumerOptions = consumerOptions;
    this.client = new Kafka({ ...kafka_config, brokers, logLevel });
  }

  /**
   * Subscribe to a resource provided by the external service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param topic - Name of the Kafka topic to expose as a resource.
   * @param params - Parameters of the external resource.
   * @param params.fromBeginning - Controls whether to consume all Kafka messages from the cluster, or only from the creation of this external resource.
   * @param callbacks - Callbacks to react on error/update.
   * @param callbacks.error - Error callback.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  async subscribe(
    instance: string,
    topic: string,
    params: { fromBeginning?: boolean },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: Json) => void;
    },
  ): Promise<void> {
    const consumer = this.client.consumer({
      ...this.consumerOptions,
      groupId: instance,
    });
    const fromBeginning = params.fromBeginning ?? true;
    await consumer.connect();
    this.consumers.set(instance, consumer);
    await consumer.subscribe({ topic, fromBeginning });
    await consumer.run({
      eachBatch: ({ batch }) => {
        const entries: Map<Json, Json[]> = new Map<Json, Json[]>();
        batch.messages.forEach((msg) => {
          for (const [k, v] of this.messageProcessor({
            key: String(msg.key),
            value: String(msg.value),
            topic,
          })) {
            if (entries.has(k)) entries.get(k)!.push(v);
            else entries.set(k, [v]);
          }
        });
        return callbacks.update(Array.from(entries), false);
      },
    });
  }

  unsubscribe(instance: string): void {
    const consumer: Consumer | undefined = this.consumers.get(instance);
    if (consumer !== undefined) {
      this.consumers.delete(instance);
      consumer.disconnect().catch((e: unknown) => {
        console.error(`Error disconnecting Kafka consumer ${instance}: ${e}`);
      });
    }
  }

  async shutdown(): Promise<void> {
    const consumers = Array.from(this.consumers.values());
    this.consumers.clear();
    await Promise.all(Array.from(consumers, (c: Consumer) => c.disconnect()));
  }
}
