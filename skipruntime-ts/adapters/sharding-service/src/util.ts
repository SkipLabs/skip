import { type Json, SkipError } from "@skipruntime/core";

/**
 * Exception indicating an error while establishing the connection between Sharding Service and Skip.
 * @hideconstructor
 */
export class SkipShardingError extends SkipError {}

/**
 * Represents a streaming event from the sharding service.
 */
export interface ShardingStreamEvent {
  table: string;
  operation: "INITIAL" | "INSERT" | "UPDATE" | "DELETE";
  data: Json[] | Json;
  hostname: string;
}

/**
 * Validate that the required parameters for sharding service connection are provided.
 * @param params - Parameters object from subscription call
 * @returns Validated parameters
 */
export function validateKeyParam(params: Json): {
  origin: string;
  partitionColumn: string;
  syncHistoricData: boolean;
} {
  if (typeof params !== "object" || params === null) {
    throw new SkipShardingError(
      "Parameters must be an object for sharding service data source"
    );
  }

  // Validate origin parameter
  if (!("origin" in params) || typeof params.origin !== "string") {
    throw new SkipShardingError(
      "Missing required 'origin' parameter for sharding service data source"
    );
  }
  const origin: string = params.origin;

  // Validate partitionColumn parameter
  if (!("partitionColumn" in params) || typeof params.partitionColumn !== "string") {
    throw new SkipShardingError(
      "Missing required 'partitionColumn' parameter for sharding service data source"
    );
  }
  const partitionColumn: string = params.partitionColumn;

  // Optional syncHistoricData parameter
  const syncHistoricData: boolean = 
    "syncHistoricData" in params && typeof params.syncHistoricData === "boolean"
      ? params.syncHistoricData
      : true;

  // Validate origin format (basic hostname validation)
  if (origin.length === 0) {
    throw new SkipShardingError("Origin parameter cannot be empty");
  }

  // Validate partition column format
  if (partitionColumn.length === 0) {
    throw new SkipShardingError("Partition column parameter cannot be empty");
  }

  if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(partitionColumn)) {
    throw new SkipShardingError(
      `Invalid partition column name: ${partitionColumn}. Must be a valid SQL identifier.`
    );
  }

  return { origin, partitionColumn, syncHistoricData };
}

/**
 * Parse Server-Sent Events data from the sharding service.
 * @param eventData - Raw event data string from SSE
 * @returns Parsed stream event
 */
export function parseSSEData(eventData: string): ShardingStreamEvent {
  try {
    const parsed = JSON.parse(eventData) as unknown;
    
    if (typeof parsed !== "object" || parsed === null) {
      throw new SkipShardingError("Event data must be a JSON object");
    }

    const event = parsed as Record<string, unknown>;

    // Validate required fields
    if (typeof event.table !== "string") {
      throw new SkipShardingError("Event data must have a 'table' field");
    }

    if (typeof event.operation !== "string") {
      throw new SkipShardingError("Event data must have an 'operation' field");
    }

    if (!["INITIAL", "INSERT", "UPDATE", "DELETE"].includes(event.operation)) {
      throw new SkipShardingError(
        `Invalid operation: ${event.operation}. Must be INITIAL, INSERT, UPDATE, or DELETE.`
      );
    }

    if (typeof event.hostname !== "string") {
      throw new SkipShardingError("Event data must have a 'hostname' field");
    }

    // Validate data field exists
    if (!("data" in event)) {
      throw new SkipShardingError("Event data must have a 'data' field");
    }

    return {
      table: event.table,
      operation: event.operation as "INITIAL" | "INSERT" | "UPDATE" | "DELETE",
      data: event.data as Json[] | Json,
      hostname: event.hostname,
    };
  } catch (error) {
    if (error instanceof SkipShardingError) {
      throw error;
    }
    throw new SkipShardingError(
      `Failed to parse SSE event data: ${error instanceof Error ? error.message : "Unknown error"}`
    );
  }
}

/**
 * Validate that a row has the expected partition key.
 * @param row - Database row object
 * @param partitionColumn - Name of the partition column
 * @returns The partition key value
 */
export function extractPartitionKey(row: Json, partitionColumn: string): Json {
  if (typeof row !== "object" || row === null) {
    throw new SkipShardingError("Row data must be an object");
  }

  const rowObj = row as Record<string, Json>;
  
  if (!(partitionColumn in rowObj)) {
    throw new SkipShardingError(
      `Row missing required partition column: ${partitionColumn}`
    );
  }

  const key = rowObj[partitionColumn];
  
  if (key === null || key === undefined) {
    throw new SkipShardingError(
      `Partition key cannot be null or undefined for column: ${partitionColumn}`
    );
  }

  return key;
}