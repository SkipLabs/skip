# skipruntime-ts — agent instructions

Skip reactive runtime: TypeScript packages (`@skipruntime/*`, `@skip-adapter/*`, `@skiplabs/skip`), Node native C++ addon, Wasm wrapper, and underlying Skiplang runtime (`skiplang/{core,ffi}/`). Root [AGENTS.md](../AGENTS.md) applies.

## Layout

| Path | Package / role |
| --- | --- |
| `core/` | `@skipruntime/core` — public TS API (`api.ts`, `index.ts`, `binding.ts`, `errors.ts`) |
| `helpers/` | `@skipruntime/helpers` — `SkipServiceBroker`, `SkipExternalService`, REST/remote helpers |
| `server/` | `@skipruntime/server` — HTTP/SSE streaming & control server |
| `wasm/` | `@skipruntime/wasm` — Node/browser Wasm runtime loader (`libskipruntime.wasm`) |
| `addon/` | `@skipruntime/native` — node-gyp C++ N-API binding (`src/*.cc`) linking `libskipruntime.so` |
| `adapters/{postgres,kafka}/` | `@skip-adapter/postgres`, `@skip-adapter/kafka` |
| `metapackage/` | `@skiplabs/skip` |
| `skiplang/{core,ffi}/` | Skiplang reactive runtime (`Runtime.sk`) and C/Wasm FFI (`FFI.sk`) |
| `tests/` | Mocha unit tests (`src/*.spec.ts`), Wasm/native example goldens (`tests/examples/`), `native_addon_unreleased/` Docker rehearsal |

## Build & test

Always use `make` targets rather than bare `npm` commands — `Makefile` exports `SKIPRUNTIME_VERSION=dev`, `LDFLAGS`, and `LD_LIBRARY_PATH` so the native addon links the local unreleased `libskipruntime.so`.

| Task | Command (from repo root unless noted) |
| --- | --- |
| Typecheck & lint TS (fast, no native build) | `make check-ts` |
| Full Node test suite (unit + Wasm/native examples + error-type check) | `make test-skipruntime-ts` |
| Unit tests only (Mocha, after `make -C skipruntime-ts build`) | `make -C skipruntime-ts test` (single spec: `cd skipruntime-ts/tests && npx mocha dist/src/<name>.spec.js`) |
| Bun tests (unit + examples) | `make test-skipruntime-ts-bun` |
| Single Wasm / native example | `make -C skipruntime-ts test-wasm-example-<name>` / `test-native-example-<name>` |
| Native-addon release rehearsal (Docker) | `cd skipruntime-ts/tests/native_addon_unreleased && ./run.sh` |
| Regenerate API docs (TypeDoc) | `make docs` |

## Gotchas

- **Errors**: `make -C skipruntime-ts test-error-types` fails if runtime source throws generic `new Error(...)`; throw a `SkipError` subclass from `core/src/errors.ts`.
- **Native artifact cache in CI**: `skipruntime` / `skipruntime-bun` cache `libskipruntime.{so,wasm}` and `addon/build` via `bin/native_artifacts_cache_key.sh` (`SKIP_NATIVE_BUILDS_IF_PRESENT=1`). Pure-TS PRs skip rebuilding native artifacts.
- **TypeScript matrix**: CI `check-ts` verifies against locked TS 5.7.x plus `~5.8.0`, `~6.0.0`, and `~7.0.0`.
- **Versioning**: changes under `skiplang/{core,ffi}/` require bumping `Skargo.toml` `version` in the same PR. All public `@skipruntime/*`, `@skiplabs/skip`, `@skip-adapter/*` NPM versions stay locked together on release — see [bin/README.md](../bin/README.md#release-npm-packages).
- **External services for integration tests**: `postgres.spec.ts` and Kafka example tests expect Postgres (`localhost:5432`, user `postgres`, password `secret`) and Kafka (`127.0.0.1:9092`).
