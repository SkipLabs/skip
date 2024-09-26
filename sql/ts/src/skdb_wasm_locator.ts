interface Imported {
  default: string;
}

export async function getWasmUrl(): Promise<URL | string> {
  // @ts-ignore
  if (import.meta.env || import.meta.webpack) {
    // @ts-ignore
    const imported = (await import("./libskdb.wasm?url")) as Imported;
    return imported.default;
  }
  return new URL("./libskdb.wasm", import.meta.url);
}
