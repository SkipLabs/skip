// TODO: Remove once global `EventSource` makes it out of experimental
// in nodejs LTS.
import { EventSource } from "eventsource";

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
      console.log("Init", e.data);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      console.log("Update", e.data);
    });
    evSource.addEventListener("error", (e: MessageEvent<string>) => {
      console.log("Error", e);
    });
    return evSource;
  });
}

// Minimal structural typing for the sqlite drivers used by the database
// example: bun:sqlite under Bun, better-sqlite3 under Node.

export interface SqliteStatement {
  run(...params: unknown[]): unknown;
  all(...params: unknown[]): unknown[];
}

export interface SqliteDatabase {
  prepare(sql: string): SqliteStatement;
  close(): void;
}

export type SqliteDatabaseConstructor = new (path: string) => SqliteDatabase;

export async function getDatabase(): Promise<SqliteDatabaseConstructor> {
  // @ts-expect-error - Bun is not typed in a Node environment
  if (typeof Bun !== "undefined") {
    // @ts-expect-error - bun:sqlite is only available under Bun
    const mod = await import("bun:sqlite");
    return mod.Database as SqliteDatabaseConstructor;
  } else {
    const mod = await import("better-sqlite3");
    return mod.default as unknown as SqliteDatabaseConstructor;
  }
}
