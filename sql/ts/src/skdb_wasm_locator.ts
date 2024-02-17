export async function getWasmUrl(): Promise<URL> {
  //@ts-ignore
  if (import.meta.env || import.meta.webpack) {
    //@ts-ignore
    return await import("./skdb.wasm?url");
  }

  return new URL('./skdb.wasm', import.meta.url);
}
