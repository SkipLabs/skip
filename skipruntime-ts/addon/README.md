# @skipruntime/native

This package provides a Node native add-on with bindings to the Skip runtime.
_Either_ this package or its WebAssembly analogue
[`@skipruntime/wasm`](https://www.npmjs.com/package/@skipruntime/wasm) is
required to run a Skip reactive service.

See the [docs](https://skiplabs.io/docs) for more details.

## Installation

Install directly using npm (`npm i @skipruntime/native`)

Note that, if this package is installed alongside the
[`@skiplabs/skip`](https://www.npmjs.com/package/@skiplabs/skip) meta-package,
you will pull in both this native add-on _and_ the WebAssembly
[runtime](https://www.npmjs.com/package/@skipruntime/wasm); if a minimal
installation is required, then specify exactly the component packages that you
need and avoid `@skiplabs/skip`.

## Support

Join the [Discord](https://discord.gg/ss4zxfgUBH) to talk to other community
members and developers or ask any questions.
