/**
 * This is an adapter to connect Sharding Service to the Skip Framework, allowing tables 
 * from a sharded database to be exposed as Skip collections via Server-Sent Events streaming.
 *
 * @packageDocumentation
 */

import { type Entry, type ExternalService, type Json } from "@skipruntime/core";

export { SkipShardingError } from "./util.js";
import { SkipShardingError, validateKeyParam, parseSSEData } from "./util.js";

/**
 * An `ExternalService` wrapping a Sharding Service, exposing its streamed *tables* as *collections* in the Skip runtime.
 *
 * This adapter connects to a sharding service that provides real-time table change notifications 
 * via Server-Sent Events (SSE). The sharding service handles partition-based filtering and 
 * streams only relevant data for a specific hostname/origin.
 *
 * Unlike the PostgreSQL adapter that connects directly to the database, this adapter:
 * - Connects to the sharding service HTTP endpoints
 * - Receives Server-Sent Events for real-time updates  
 * - Supports partition-based data filtering by hostname
 * - Works with tables that are sharded across multiple hosts
 *
 * @remarks
 * Subscription `params` **must** include:
 * - `origin`: hostname for partition-based filtering
 * - `partitionColumn`: column name used for partitioning (e.g. "partition_id")
 * 
 * Subscription `params` **may** also specify:
 * - `syncHistoricData`: false to receive only new updates (default: true)
 */
export class ShardingServiceExternalService implements ExternalService {
  private serviceBaseUrl: string;
  private activeConnections: Map<string, AbortController> = new Map();

  /**
   * @param config - Configuration for the sharding service connection
   * @param config.host - Host where sharding service is running (default: "localhost")  
   * @param config.port - Port where sharding service is listening (default: 8080)
   * @param config.protocol - Protocol to use: "http" or "https" (default: "http")
   */
  constructor(config: {
    host?: string;
    port?: number;
    protocol?: "http" | "https";
  } = {}) {
    const host = config.host ?? "localhost";
    const port = config.port ?? 8080;
    const protocol = config.protocol ?? "http";
    
    this.serviceBaseUrl = `${protocol}://${host}:${port}`;
  }

  /**
   * Subscribe to a resource provided by the sharding service.
   *
   * @param instance - Instance identifier of the external resource.
   * @param resource - Name of the table to stream from the sharding service.
   * @param params - Parameters of the external resource.
   * @param params.origin - (**Required**) Hostname for partition-based filtering (e.g., "test-host-1.example.com")
   * @param params.partitionColumn - (**Required**) Column name used for partitioning (e.g., "partition_id")
   * @param params.syncHistoricData - (**Optional**) Whether to sync existing data on subscription (default: true)
   * @param callbacks - Callbacks to react on error/loading/update.
   * @param callbacks.error - Error callback.
   * @param callbacks.update - Update callback.
   * @returns {void}
   */
  async subscribe(
    instance: string,
    resource: string,
    params: {
      origin: string;
      partitionColumn: string;
      syncHistoricData?: boolean;
    },
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: Json) => void;
    },
  ): Promise<void> {
    const table = resource;
    const { origin, partitionColumn } = validateKeyParam(params);

    if (this.activeConnections.has(instance)) {
      callbacks.error(`Instance ${instance} is already subscribed`);
      return;
    }

    const abortController = new AbortController();
    this.activeConnections.set(instance, abortController);

    const error = (message: string) => (error?: unknown) => {
      callbacks.error(message);
      console.error(message, error);
      this.activeConnections.delete(instance);
    };

    try {
      // Construct the streaming URL
      const streamUrl = new URL(`/stream/${table}`, this.serviceBaseUrl);
      streamUrl.searchParams.set("origin", origin);
      streamUrl.searchParams.set("partition_column", partitionColumn);

      console.log(`Connecting to sharding service: ${streamUrl.toString()}`);

      // Start Server-Sent Events connection
      const response = await fetch(streamUrl.toString(), {
        method: "GET",
        headers: {
          Accept: "text/event-stream",
          "Cache-Control": "no-cache",
        },
        signal: abortController.signal,
      });

      if (!response.ok) {
        throw new SkipShardingError(
          `Failed to connect to sharding service: ${response.status} ${response.statusText}`
        );
      }

      if (!response.body) {
        throw new SkipShardingError("No response body received from sharding service");
      }

      // Process Server-Sent Events stream
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buffer = "";

      const processStream = async () => {
        try {
          while (true) {
            const { done, value } = await reader.read();
            
            if (done) {
              console.log(`Stream ended for instance ${instance}`);
              break;
            }

            buffer += decoder.decode(value, { stream: true });
            const lines = buffer.split("\n");
            buffer = lines.pop() || ""; // Keep incomplete line in buffer

            for (const line of lines) {
              if (line.startsWith("data: ")) {
                try {
                  const eventData = line.substring(6); // Remove "data: " prefix
                  const streamEvent = parseSSEData(eventData);
                  
                  // Convert stream event to Skip entries format
                  const entries: Entry<Json, Json>[] = [];
                  
                  if (streamEvent.operation === "INITIAL" && Array.isArray(streamEvent.data)) {
                    // Initial data: group by partition key
                    const grouped = new Map<Json, Json[]>();
                    for (const row of streamEvent.data) {
                      const key = (row as Record<string, Json>)[partitionColumn];
                      if (key !== undefined) {
                        if (grouped.has(key)) {
                          grouped.get(key)!.push(row);
                        } else {
                          grouped.set(key, [row]);
                        }
                      }
                    }
                    entries.push(...Array.from(grouped.entries()));
                    
                    await callbacks.update(entries, true);
                  } else {
                    // Real-time updates: single row updates
                    const row = streamEvent.data as Record<string, Json>;
                    const key = row[partitionColumn];
                    if (key !== undefined) {
                      entries.push([key, [row]]);
                      await callbacks.update(entries, false);
                    }
                  }
                } catch (parseError) {
                  console.error("Error parsing SSE data:", parseError);
                }
              }
            }
          }
        } catch (streamError) {
          if (abortController.signal.aborted) {
            console.log(`Stream aborted for instance ${instance}`);
          } else {
            error(`Stream processing error for instance ${instance}`)(streamError);
          }
        } finally {
          reader.releaseLock();
          this.activeConnections.delete(instance);
        }
      };

      // Start processing the stream
      processStream().catch(error(`Failed to process stream for instance ${instance}`));

    } catch (connectError) {
      error(`Failed to connect to sharding service for instance ${instance}`)(connectError);
    }
  }

  unsubscribe(instance: string): void {
    const abortController = this.activeConnections.get(instance);
    if (abortController) {
      console.log(`Unsubscribing from instance ${instance}`);
      abortController.abort();
      this.activeConnections.delete(instance);
    }
  }

  async shutdown(): Promise<void> {
    console.log(`Shutting down sharding service adapter with ${this.activeConnections.size} active connections`);
    
    // Abort all active connections
    for (const [instance, abortController] of this.activeConnections.entries()) {
      console.log(`Aborting connection for instance ${instance}`);
      abortController.abort();
    }
    
    this.activeConnections.clear();
  }

  /**
   * Check if the sharding service is healthy and responding.
   * @returns Promise that resolves to true if the service is healthy, false otherwise.
   */
  async isHealthy(): Promise<boolean> {
    try {
      const response = await fetch(`${this.serviceBaseUrl}/health`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });
      
      if (response.ok) {
        const health = await response.json() as { status?: string };
        return health.status === "healthy";
      }
      
      return false;
    } catch {
      return false;
    }
  }
}