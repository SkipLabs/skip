# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/skiplabs/skip/compare/v0.0.18...HEAD
[0.0.18]: https://github.com/skiplabs/skip/compare/v0.0.17...v0.0.18
[0.0.17]: https://github.com/skiplabs/skip/compare/v0.0.16...v0.0.17
[0.0.16]: https://github.com/skiplabs/skip/compare/v0.0.15...v0.0.16
[0.0.15]: https://github.com/skiplabs/skip/compare/v0.0.14...v0.0.15
[0.0.14]: https://github.com/skiplabs/skip/compare/v0.0.13...v0.0.14
[0.0.13]: https://github.com/skiplabs/skip/compare/v0.0.12...v0.0.13
[0.0.12]: https://github.com/skiplabs/skip/compare/v0.0.11...v0.0.12
[0.0.11]: https://github.com/skiplabs/skip/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/skiplabs/skip/releases/tag/v0.0.10
