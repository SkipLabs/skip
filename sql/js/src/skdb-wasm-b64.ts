// for distribution we replace this line with inlined base64-encoded bytes
const wasmBase64 = ''

export async function getWasmSource(): Promise<Uint8Array> {
  // @ts-ignore
  let wasmBuffer = typeof atob === 'undefined' ? Buffer.from(wasmBase64, 'base64') : atob(wasmBase64)
  let len = wasmBuffer.length
  let typedArray = new Uint8Array(len)
  for (var i = 0; i < len; i++) {
    // TODO: Fix the following error.
    // @ts-ignore
    typedArray[i] = wasmBuffer.charCodeAt(i)
  }
  return typedArray
}
