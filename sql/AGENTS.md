# sql — agent instructions

SKDB: reactive SQL database implemented in Skiplang (`src/`), compiled to native and Wasm, with a TypeScript client (`ts/`) and Java replication/sync server (`server/`). Root [AGENTS.md](../AGENTS.md) and [docs/skip-code-notes.md](../docs/skip-code-notes.md) apply.

## Layout

| Path | Contents |
| --- | --- |
| `src/` | SKDB engine (`Main.sk`, `SqlCompile.sk`, `SqlEval.sk`, `SqlSelect.sk`, `SqlTables.sk`, `SqlIndex.sk`, `SqlPrivacy.sk`, `SqlSchemaMigration.sk`, `SqlTailer.sk`, ...) |
| `privacy/` | Privacy layer init SQL (`init.sql`) |
| `ts/` | `skdb` NPM package (`src/`), Playwright tests (`tests/`), consumer smoke tests (`bun/`, `vitejs/`) |
| `server/` | Java/Gradle sync & dev servers (`core/`, `dev/`, `deploy/`, `pg/`) |
| `test/`, `test_*.sh`, `unit_tests.sh` | Native SQL & replication regression tests |

## Build & test

| Task | Command (from repo root unless noted) |
| --- | --- |
| Build native `skdb` binary | `make build/skdb` (dev: `make SKARGO_PROFILE=dev build/skdb`) |
| Build Wasm + TS client | `make npm` (or `make -C sql build`) |
| Native SQL test suite (CI `skdb` job) | `make test-native` (uses `SKARGO_PROFILE=release` by default; `dev` for faster local iteration) |
| Wasm + Playwright + server suite (CI `skdb-wasm` job) | `make test-wasm` |
| Client-only Playwright tests (Node / Browser / both) | `make -C sql test-client-node` / `test-client-browser` / `test-client` |
| Lint SKDB TS (`skdb` + `skdb-tests`) | `make -C sql check-all` (or `make check-ts` from root) |

## Gotchas

- **Test-only CI narrowing**: changes confined to `sql/test/`, `sql/tpch/`, `sql/test_*.{sh,sql}`, `sql/unit.sql`, `sql/unit_tests.sh`, or `sql/init_test_privacy.sql` trigger only the `skdb` job in CI (not `skdb-wasm` or dependents).
- **`skdb` binary cache in CI**: `skdb` and `skdb-wasm` cache `sql/target/host/release/skdb` via `bin/ci_skdb_bin_cache.sh`; test-script or TS-only PRs skip the multi-minute release compile.
- **Prettier exception**: `*_args.json` test files are excluded in `.prettierignore` (must stay single-line without spaces between braces).
- **Wasm ABI**: `sql/Skargo.toml` compiles to `wasm32-unknown-unknown` (`cdylib`), so any `@cpp_extern` used by SKDB must match C/Wasm ABI types strictly (see [docs/skip-code-notes.md](../docs/skip-code-notes.md)).
- **Semver**: bump `version` in `sql/Skargo.toml` in the same PR when changing `sql/` Skip sources.
