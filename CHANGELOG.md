# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
 - `SkipService` now takes two type parameters (`<InputDefs, ResourceInputs>`)
   and derives `createGraph`'s input collection types via
   `InputCollections<InputDefs>`, replacing `initialData` with `inputs`
   (`InputDefinition` instances per collection) (#1162, #1811)
 - `Resource.instantiate`, `Mapper.mapEntry`, `Reducer.add`/`remove`, and
   `LazyCompute.compute` use function-typed properties so contravariant
   parameter checking is enforced under TypeScript's `strictFunctionTypes`;
   `Resource` constructors now receive `Json` parameters by default and must
   validate before narrowing (#1811)
 - `Watermark` and `SubscriptionID` are now nominal wrapper classes (exposing
   `toString()` and `toJSON()`) instead of `Opaque<string>` aliases; note that
   `===` and `Map` keys compare by object identity rather than string value (#1811)
 - `ServiceInstance` is now exported as a TypeScript interface (with
   `ServiceInstanceImpl` as the concrete runtime class); a deprecated
   `ServiceInstance` value alias of `ServiceInstanceImpl` keeps existing
   value imports (e.g. `instanceof ServiceInstance`) working (#1811, #1816)
 - `asFollower` now restricts `collections` to eager collection keys, requires
   a literal `collections` to list every eager collection in `ResourceInputs`,
   and requires typed `lazies` factories matching each lazy collection; it
   throws a `SkipError` at runtime if `lazies` is not a plain object, a
   defined name is in both `collections` and `lazies`, or a defined `lazies`
   entry is not a function (#1811, #1816)
 - `AbstractEagerCollection`, `AbstractLazyCollection`, and
   `AbstractInputDefinition` are now nominal (branded with a `unique symbol`
   key private to `@skipruntime/core`) instead of carrying public
   `__sk_*Brand: undefined` fields; object literals or other structural
   implementations are no longer accepted and must be replaced by subclasses
   such as runtime-created collections / `InputDefinition` instances (#1816)

## [0.0.23] - 2026-05-28

### Security
 - Fix world-writable file creation (#1250), information exposure through stack
   traces (#1240, #1241) and log injection from unsanitized user input in the
   Flask examples (#1254), all reported by code scanning
 - Create the SQL server notify pipe through `Files.createTempFile` (#1253)

## [0.0.21] - 2026-05-22

### Security
 - Dependency updates across published packages and examples, covering
   advisories in `ws`, `brace-expansion`, `minimatch`, `path-to-regexp`,
   `qs`/`body-parser`, `ajv`, `glob` and `picomatch`

## [0.0.20] - 2026-04-10

### Changed
 - TypeScript 5.8 and 6.0 compatibility: fix `Uint8Array`/`ArrayBuffer` type
   mismatches, and set explicit `rootDir` and `types` in `@skiplabs/tsconfig`

### Security
 - Dependency updates, covering advisories in `node-forge`, `lodash`, `vite`,
   `yaml` and `flatted`

## [0.0.19] - 2025-11-16

### Added
 - Logging middleware in both control and streaming servers (#1032)

### Changed
 - Update healthcheck routes from `/v1/healthcheck` to `/healthz` (#1031)

## [0.0.18] - 2025-11-14

### Added
 - Healthcheck endpoint in the streaming service (#1025)

## [0.0.17] - 2025-11-13

### Added
 - Streams now regularly (every 30 seconds) send a empty message to avoid some
   timeouts in backend deployments (#1018)

## [0.0.16] - 2025-04-30

### Fixed
- Manage HTTP errors in stream creations (#878)
- Fix bug with empty resources (#882)

## [0.0.15] - 2025-04-11

### Added
- Add an optional env variable prefix to stream UUIDs (#859).
- Add a mechanism to wait for external resources initialization at resource creation time (#850).
- Add transaction mechanism to wait for external resources initialization at write time (#850).

## [0.0.14] - 2025-04-10

### Added
- Add asLeader/asFollower utilities for distributed Skip services (#853).

## [0.0.13] - 2025-03-21

### Added
- Support non-unique key columns in postgres adapter (#793).
- Add Kafka adapter (#749).
- Add `context` argument to `Mapper`'s `mapEntry` signature (#813).
- Add option to only receive new rows in postgres adapter (#815).
- Add optional "default" arg to `getUnique` methods (#808).

### Changed
- Rename `Polled` to `PolledExternalService` (#819).

### Removed
- Remove `GenericExternalService`, `ExternalResource`, and
  `TimerResource` (#819).

### Fixed
- Fix subscription updates (#814).
- Fix buffered output in wasm runtime (#817).

## [0.0.12] - 2025-02-28

### Added
- Add option to disable CORS (#779).

## [0.0.11] - 2025-02-28

### Added
- `GET /healthcheck` endpoint to skip control service (#755).

### Removed
- Remove `OneToOneMapper`/`OneToManyMapper`/`ManyToManyMapper`
  interfaces (#740).

### Fixed
- Fix triggers on updates with null fields in postgres adapter (#783).

## [0.0.10] - 2025-02-05

[unreleased]: https://github.com/skiplabs/skip/compare/v0.0.19...HEAD
[0.0.19]: https://github.com/skiplabs/skip/compare/v0.0.18...v0.0.19
[0.0.18]: https://github.com/skiplabs/skip/compare/v0.0.17...v0.0.18
[0.0.17]: https://github.com/skiplabs/skip/compare/v0.0.16...v0.0.17
[0.0.16]: https://github.com/skiplabs/skip/compare/v0.0.15...v0.0.16
[0.0.15]: https://github.com/skiplabs/skip/compare/v0.0.14...v0.0.15
[0.0.14]: https://github.com/skiplabs/skip/compare/v0.0.13...v0.0.14
[0.0.13]: https://github.com/skiplabs/skip/compare/v0.0.12...v0.0.13
[0.0.12]: https://github.com/skiplabs/skip/compare/v0.0.11...v0.0.12
[0.0.11]: https://github.com/skiplabs/skip/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/skiplabs/skip/releases/tag/v0.0.10
