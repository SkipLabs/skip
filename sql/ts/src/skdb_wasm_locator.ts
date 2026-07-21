interface Imported {
  default: string;
}

export async function getWasmUrl(): Promise<URL | string> {
  // @ts-expect-error: Property 'env' does not exist on type 'ImportMeta'.
  if (import.meta.env || import.meta.webpack) {
    // @ts-expect-error: Cannot find module './libskdb.wasm?url' or its corresponding type declarations.
    const imported = (await import("./libskdb.wasm?url")) as Imported;
    return imported.default;
  }
  return new URL("./libskdb.wasm", import.meta.url);
}
