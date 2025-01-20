# skip &middot; [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/skiplabs/skip/blob/main/LICENSE) [![CircleCI](https://dl.circleci.com/status-badge/img/gh/SkipLabs/skip/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/SkipLabs/skip/tree/main)

Skip is an open-source framework for building _reactive_ backend services.

It is based on a custom-built native backend for efficient reactive computation, allowing your system to deliver up-to-date and correct results without requiring any bug-prone manual dependency tracking and updating.

TypeScript interfaces and abstractions are provided so that you can write a reactive service using standard tools while also taking advantage of the Skip framework's abstractions for efficient reactivity.

## Installation

To get started, install the NPM packages for the Skip runtime API, server, and helpers:

```npm install @skipruntime/core @skipruntime/server @skipruntime/helpers```

Two versions of the runtime are available, a Wasm `@skipruntime/wasm` and a native `@skipruntime/native`.
The Wasm runtime works with both `node` and `bun`, but is limited to Wasm's 32-bit memory address space.
The native runtime does not have this limitation, but it is currently only available for Node and is a bit more involved to install.

### The Wasm runtime installation

```npm install @skipruntime/wasm```

### The native runtime installation

First, install the Skip runtime native library:

- Precompiled packages

  ```To be specified```

- Built and installed from skip git repository:

  ```To be specified```

Then, the related npm package:

```npm install @skipruntime/native```

From there, you're ready to start building a reactive service!
See the [getting started guide](https://skiplabs.io/docs/getting_started) to walk through some of Skip's core concepts by example and get up to speed.

## Documentation

See our documentation [here](https://skiplabs.io/docs) for introductions to the core concepts, components, and features of the Skip framework, or dive into the [API docs](https://skiplabs.io/docs/api/api) for comprehensive explanations of our TypeScript interfaces and abstractions.

## Examples

Some small examples of reactive services are [available](./skipruntime-ts/examples), demonstrating patterns of reactive programming.
Another [example](./examples/hackernews) is designed to serve as an example of how to deploy and configure a reactive service, using Docker compose to package and orchestrate a backend complete with a reactive service, database, backend web service, and reverse proxy.

## Contributing

We welcome contributions and pull requests and are happy to help you get started!
The issue tracker is kept up-to-date with our roadmap and is a good place to begin if you're looking for ideas of ways to contribute.

You can also join our [Discord](https://discord.gg/bsnXyw2F9P) to ask any questions or get involved.

## License

SKDB is [MIT licensed](./LICENSE).
