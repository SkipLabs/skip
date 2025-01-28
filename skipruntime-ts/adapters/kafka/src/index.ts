import type { Entry, ExternalService, Json } from "@skipruntime/core";

const { Kafka } = require("kafkajs");

/**
 * An `ExternalService` wrapping a PostgreSQL database.
 *
 * Expose the tables of a PostgreSQL database as *resources* in the Skip runtime.
 *
 */
export class KafkaExternalService implements ExternalService {
  private clientID: string;
  private client: Kafka;

  /**
   */
  constructor(kafka_config: { brokers:{host:string;port:number}[]}) {
    this.clientID = "skip_kafka_client_" + Math.random().toString(36).slice(2);
    this.client = new Kafka({...kafka_config, clientID: this.clientID)
  }

  /**
   * Subscribe to a resource provided by the external service.
   */
  subscribe(
    instance: string,
    resource: string,
    params: Json,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => void;
      error: (error: Json) => void;
      loading: () => void;
    },
  ): void {}

  unsubscribe(instance: string): void {}

  shutdown(): void {}
}
