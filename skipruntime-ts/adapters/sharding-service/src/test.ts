/**
 * Simple test of the sharding service adapter without full Skip runtime dependencies
 * This can be used to test the adapter functionality against a running sharding service.
 */

// Simplified types for testing without full Skip runtime
type Json = string | number | boolean | null | Json[] | { [key: string]: Json };
type Entry<K, V> = [K, V[]];

interface ExternalService {
  subscribe(
    instance: string,
    resource: string,
    params: any,
    callbacks: {
      update: (updates: Entry<Json, Json>[], isInit: boolean) => Promise<void>;
      error: (error: Json) => void;
    },
  ): Promise<void>;
  unsubscribe(instance: string): void;
  shutdown(): Promise<void>;
}

// Custom error class for testing
class SkipShardingError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'SkipShardingError';
  }
}

// Validation function
function validateKeyParam(params: Json): {
  origin: string;
  partitionColumn: string;
  syncHistoricData: boolean;
} {
  if (typeof params !== "object" || params === null) {
    throw new SkipShardingError(
      "Parameters must be an object for sharding service data source"
    );
  }

  const paramsObj = params as Record<string, Json>;

  if (!("origin" in paramsObj) || typeof paramsObj.origin !== "string") {
    throw new SkipShardingError(
      "Missing required 'origin' parameter for sharding service data source"
    );
  }
  const origin: string = paramsObj.origin;

  if (!("partitionColumn" in paramsObj) || typeof paramsObj.partitionColumn !== "string") {
    throw new SkipShardingError(
      "Missing required 'partitionColumn' parameter for sharding service data source"
    );
  }
  const partitionColumn: string = paramsObj.partitionColumn;

  const syncHistoricData: boolean = 
    "syncHistoricData" in paramsObj && typeof paramsObj.syncHistoricData === "boolean"
      ? paramsObj.syncHistoricData
      : true;

  return { origin, partitionColumn, syncHistoricData };
}

// Simplified adapter implementation for testing
export class ShardingServiceExternalService implements ExternalService {
  private serviceBaseUrl: string;
  private activeConnections: Map<string, AbortController> = new Map();

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
      const streamUrl = new URL(`/stream/${table}`, this.serviceBaseUrl);
      streamUrl.searchParams.set("origin", origin);
      streamUrl.searchParams.set("partition_column", partitionColumn);

      console.log(`Connecting to sharding service: ${streamUrl.toString()}`);

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
            buffer = lines.pop() || "";

            for (const line of lines) {
              if (line.startsWith("data: ")) {
                try {
                  const eventData = line.substring(6);
                  const streamEvent = JSON.parse(eventData) as any;
                  
                  console.log(`Received event:`, streamEvent);
                  
                  const entries: Entry<Json, Json>[] = [];
                  
                  if (streamEvent.operation === "INITIAL" && Array.isArray(streamEvent.data)) {
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
    
    for (const [instance, abortController] of this.activeConnections.entries()) {
      console.log(`Aborting connection for instance ${instance}`);
      abortController.abort();
    }
    
    this.activeConnections.clear();
  }

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

// Test function
async function testShardingAdapter() {
  console.log("🧪 Testing Sharding Service Adapter");
  
  const adapter = new ShardingServiceExternalService({
    host: "localhost",
    port: 8080,
    protocol: "http"
  });

  // Test health check
  const isHealthy = await adapter.isHealthy();
  console.log(`Service health check: ${isHealthy ? "✅ Healthy" : "❌ Unhealthy"}`);
  
  if (!isHealthy) {
    console.log("Service not healthy, exiting test");
    return;
  }

  // Test subscription to tasks table
  let updateCount = 0;
  await adapter.subscribe(
    "test-instance", 
    "tasks", 
    {
      origin: "test-host-1.example.com",
      partitionColumn: "partition_id",
      syncHistoricData: true
    }, 
    {
      update: async (updates, isInit) => {
        updateCount++;
        console.log(`📡 Update ${updateCount} (init: ${isInit}):`, updates);
        
        // Stop after first few updates
        if (updateCount >= 2) {
          console.log("Received expected updates, unsubscribing...");
          adapter.unsubscribe("test-instance");
          
          setTimeout(async () => {
            await adapter.shutdown();
            console.log("✅ Test completed successfully!");
          }, 1000);
        }
      },
      error: (error) => {
        console.error("❌ Adapter error:", error);
      }
    }
  );
}

// Run test if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  testShardingAdapter().catch(console.error);
}