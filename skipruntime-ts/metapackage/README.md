# @skiplabs/skip

This meta-package depends on other components of the Skip runtime, simplifying
installation and dependency management.  Namely, including or installing this
package will pull in:

 * `@skipruntime/core`, providing the core types, operations, and abstractions
   that make up a Skip reactive service.
 * `@skipruntime/server`, providing functionality to spawn HTTP servers and
   expose reactive services to clients.
 * `@skipruntime/helpers`, providing some useful utilities that are helpful but
   not strictly necessary for working with the Skip framework.
 * `@skipruntime/wasm`, which implements WebAssembly bindings to the Skip
   runtime.

Optionally, you may also want to include `@skipruntime/native` for native
bindings to the Skip runtime, or some `@skip-adapter/*` for prebuilt reactive
adapters to some popular third-party data sources and systems.

See the [docs](https://skiplabs.io/docs/) for more details on Skip.

## Installation

Install using npm (`npm i @skiplabs/skip`).

## Support

Join the [Discord](https://discord.gg/ss4zxfgUBH) to talk to other community
members and developers or ask any questions.
