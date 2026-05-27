export * from "./errors.js";
export * from "./check.js";
export * from "./routes.js";
export * from "./tests.js";
export * from "./logger.js";
export * from "./files.js";
export * from "./jsonStartup.js";

export function invertUTF8String(key: string): string {
  let result = "";
  for (const ch of key) {
    result += String.fromCodePoint(0x10ffff - ch.codePointAt(0)!);
  }
  return result;
}
