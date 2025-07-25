# @skipruntime/native

This package provides a Node native add-on with bindings to the Skip runtime.
_Either_ this package or its WebAssembly analogue
[`@skipruntime/wasm`](https://www.npmjs.com/package/@skipruntime/wasm) is
required to run a Skip reactive service.

See the [docs](https://skiplabs.io/docs/getting_started#installation) for more details.

## Installation

Installing the native add-on version of the Skip runtime is done in two steps:
1. Install the `libskipruntime` native library; and then
2. Install the `@skipruntime/native` npm package.
The versions of the two *must* match.

Installation can be performed by executing:
```bash
# calculate the version of the skipruntime
  VERSION=$(npm install --dry-run @skipruntime/native | grep native | cut -d' ' -f3) \
# install the skipruntime binary release
&& wget --quiet --output-document=- \
      https://raw.githubusercontent.com/skiplabs/skip/refs/tags/v${VERSION}/bin/install_runtime.sh \
  | bash - \
# install the skipruntime native node addon package
&& npm install @skipruntime/native
```
This command uses `npm install --dry-run` to determine the version of the runtime to install, but any mechanism that ensures the versions match will suffice.
If the versions of the npm package and binary runtime do not match, `npm install @skipruntime/native` will fail with an error such as:
```
npm error /usr/bin/ld: cannot find -lskipruntime-1.0.0: No such file or directory
```

It may be helpful to consult the small [Dockerfile](https://github.com/skiplabs/skip/blob/main/skipruntime-ts/tests/native_addon/Dockerfile) that installs the native node addon and runs a trivial Skip service.

Note that, if this package is installed alongside the [`@skiplabs/skip`](https://www.npmjs.com/package/@skiplabs/skip) meta-package, you will pull in both this native add-on _and_ the WebAssembly [runtime](https://www.npmjs.com/package/@skipruntime/wasm); if a minimal installation is required, then specify exactly the component packages that you need and avoid `@skiplabs/skip`.

## Support

Join the [Discord](https://discord.gg/ss4zxfgUBH) to talk to other community
members and developers or ask any questions.
