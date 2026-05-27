/**
 * Result-typed JSON parse for code that runs at process startup.
 *
 * The generated server's index.ts reads sidecar JSON files
 * (external-access.json, ui-pages.json) before binding any route.
 * A bare JSON.parse on a truncated or corrupted file would crash
 * the server with an uncaught SyntaxError before useful work
 * begins. tryParseJson lets the caller branch on parse success
 * explicitly — fatal for required artefacts, recoverable for
 * optional ones — without scattering try/catch through each
 * startup site.
 */
export type ParseResult<T> =
  | { readonly ok: true; readonly value: T }
  | { readonly ok: false; readonly error: string };

export function tryParseJson<T>(
  content: string,
  label: string,
): ParseResult<T> {
  try {
    return { ok: true, value: JSON.parse(content) as T };
  } catch (e) {
    return {
      ok: false,
      error: `Failed to parse ${label}: ${e instanceof Error ? e.message : String(e)}`,
    };
  }
}
