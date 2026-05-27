import { appendFile, appendFileSync, existsSync, mkdirSync } from "fs";
import path from "path";

export type Level = "debug" | "trace" | "info" | "warn" | "error" | "fatal";

type LevelIndexed = {
  debug: 0;
  trace: 1;
  info: 2;
  warn: 3;
  error: 4;
  fatal: 5;
};

export function checkLevel(level: string): Level {
  const value = level.toLowerCase();
  switch (value) {
    case "debug":
    case "trace":
    case "info":
    case "warn":
    case "error":
    case "fatal":
      return value;
    default:
      return "trace";
  }
}

export const levelIndexed: LevelIndexed = {
  debug: 0,
  trace: 1,
  info: 2,
  warn: 3,
  error: 4,
  fatal: 5,
};

export interface Logger {
  debug: (...args: unknown[]) => void;
  error: (...args: unknown[]) => void;
  warn: (...args: unknown[]) => void;
  info: (...args: unknown[]) => void;
  fatal: (...args: unknown[]) => void;
  trace: (...args: unknown[]) => void;
}

type Namespaces = string[];

export interface Loggers<N extends Namespaces> {
  debug: (category: N[number], ...args: unknown[]) => void;
  error: (category: N[number], ...args: unknown[]) => void;
  warn: (category: N[number], ...args: unknown[]) => void;
  info: (category: N[number], ...args: unknown[]) => void;
  fatal: (category: N[number], ...args: unknown[]) => void;
  trace: (category: N[number], ...args: unknown[]) => void;
}

/**
 * Formats a single argument to string representation
 * @returns -
 */
export function formatArg(arg: unknown): string {
  // Handle null and undefined
  if (arg === null) return "null";
  if (arg === undefined) return "undefined";

  // Handle primitives
  if (typeof arg === "string") return arg;
  if (typeof arg === "number" || typeof arg === "boolean") return String(arg);
  if (typeof arg === "bigint") return `${arg}n`;
  if (typeof arg === "symbol") return arg.toString();

  // Handle functions
  if (typeof arg === "function") {
    return arg.name ? `[Function: ${arg.name}]` : "[Function]";
  }

  // Handle errors
  if (arg instanceof Error) {
    return `${arg.name}: ${arg.message}`;
  }

  // Handle dates
  if (arg instanceof Date) {
    return arg.toISOString();
  }

  // Handle arrays
  if (Array.isArray(arg)) {
    if (arg.length === 0) return "[]";
    try {
      return JSON.stringify(arg, null, 2);
    } catch (error: unknown) {
      if (error instanceof Error && error.message.includes("circular")) {
        return "[Array (circular)]";
      }
      // Try to format individual value instead
      try {
        const entries = arg.map((value) => `  ${formatArg(value)}`).join(",\n");
        return `[\n${entries}\n]`;
      } catch {
        return "[Array (non-serializable)]";
      }
    }
  }

  // Handle objects
  if (typeof arg === "object") {
    try {
      return JSON.stringify(arg, null, 2);
    } catch (error: unknown) {
      // Handle circular references or other JSON errors
      if (error instanceof Error && error.message.includes("circular")) {
        return "[Object (circular)]";
      }
      // Try to format individual properties instead
      try {
        const entries = Object.entries(arg)
          .map(([key, value]) => `  ${key}: ${formatArg(value)}`)
          .join(",\n");
        return `{\n${entries}\n}`;
      } catch {
        return "[Object (non-serializable)]";
      }
    }
  }

  // eslint-disable-next-line @typescript-eslint/no-base-to-string
  return String(arg);
}

/**
 * Formats multiple arguments into a single string
 * @returns -
 */
export function formatArgs(...args: unknown[]): string {
  return args.map(formatArg).join(" ");
}

/**
 * Simple string formatting using indexed placeholders {1}, {2}, etc.
 *
 * @param template - Format string with {1}, {2}, {3}... placeholders (1-indexed)
 * @param args - Values to substitute
 * @returns Formatted string
 *
 * @example
 * format("Hello {1}, you have {2} messages", "Alice", 5)
 * // => "Hello Alice, you have 5 messages"
 *
 * format("User {1} logged in at {2}", "Bob", new Date())
 * // => "User Bob logged in at 2025-01-16T10:30:45.123Z"
 *
 * format("Data: {1}", { name: "test", value: 42 })
 * // => "Data: { \"name\": \"test\", \"value\": 42 }"
 */
export function formatString(template: string, ...args: unknown[]): string {
  return template.replace(/\{(\d+)\}/g, (match, index: string) => {
    const argIndex = parseInt(index, 10) - 1; // Convert 1-indexed to 0-indexed
    return argIndex >= 0 && argIndex < args.length
      ? formatArg(args[argIndex])
      : match;
  });
}

/**
 * Formats a log message with optional timestamp and level
 */
export interface FormatOptions {
  /** Log level (info, warn, error, log) */
  level?: Level;
  /** Include timestamp (default: true) */
  timestamp?: boolean;
  /** Custom timestamp format function */
  timestampFormat?: (date: Date) => string;
  /** Include level prefix (default: true) */
  includeLevel?: boolean;
  /** Category/namespace for the log */
  category?: string;
}

/**
 * Formats a log message with metadata
 *
 * @param message - Main log message
 * @param options - Formatting options
 * @returns Formatted log string
 *
 * @example
 * format("User logged in", { level: "info", category: "auth" })
 * // => "[2025-01-16T10:30:45.123Z] [INFO] [auth] User logged in"
 */
export function formatLog(
  message: string,
  options: FormatOptions = {},
): string {
  const {
    level,
    timestamp = true,
    timestampFormat = (date: Date) => date.toISOString(),
    includeLevel = true,
    category,
  } = options;

  const parts: string[] = [];

  // Add timestamp
  if (timestamp) {
    parts.push(`[${timestampFormat(new Date())}]`);
  }

  // Add level
  if (includeLevel && level) {
    parts.push(`[${level.toUpperCase()}]`);
  }

  // Add category
  if (category) {
    parts.push(`[${category}]`);
  }

  // Add message
  parts.push(message);

  return parts.join(" ");
}

abstract class ALogger implements Logger {
  private level: number;

  constructor(
    level: Level,
    private category?: string,
  ) {
    this.level = levelIndexed[level];
  }

  debug(...args: unknown[]): void {
    this.log_("debug", ...args);
  }

  trace(...args: unknown[]): void {
    this.log_("trace", ...args);
  }

  info(...args: unknown[]): void {
    this.log_("info", ...args);
  }

  warn(...args: unknown[]): void {
    this.log_("warn", ...args);
  }

  error(...args: unknown[]): void {
    this.log_("error", ...args);
  }

  fatal(...args: unknown[]): void {
    this.log_("fatal", ...args);
  }

  protected abstract log(message: string): void;

  private log_(level: Level, ...args: unknown[]): void {
    const levelIndex = levelIndexed[level];
    if (levelIndex < this.level) return;
    const message = formatLog(formatArgs(...args), {
      level,
      category: this.category,
    });
    this.log(message);
  }
}

export class FileLogger extends ALogger {
  private logFile: string;

  constructor(
    logDir: string,
    level: Level,
    logName: string,
    category?: string,
    private sync: boolean = true,
  ) {
    super(level, category);
    if (!existsSync(logDir)) mkdirSync(logDir, { recursive: true });
    this.logFile = path.join(logDir, `${logName}.log`);
  }

  protected log(message: string): void {
    if (this.sync) {
      appendFileSync(this.logFile, `${message}\n`);
    } else {
      // Don't silently drop log writes — ENOSPC/EACCES/EROFS on the
      // log volume is exactly the failure mode operators want
      // surfaced. Log the write error to stderr; the original
      // message is also forwarded so it isn't lost.
      appendFile(this.logFile, `${message}\n`, (err) => {
        if (err)
          console.error(
            `log write failed (${err.code ?? err.message}): ${message}`,
          );
      });
    }
  }
}

export class ConsoleLogger extends ALogger {
  protected log(message: string): void {
    console.error(message);
  }
}
