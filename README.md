<div align="center">
  <img src="https://raw.githubusercontent.com/SkipLabs/skip/refs/heads/main/www/static/img/logo.svg" width="160" alt="skip" />
  <p align="center">
    <a href="https://skiplabs.io/docs">Docs</a> | <a href="https://discord.gg/4dMEBA46mE">Chat</a>
  </p>
  <p align="center">
    <a href="https://github.com/skiplabs/skip/blob/main/LICENSE">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license" />
    </a>
    <a href="https://dl.circleci.com/status-badge/redirect/gh/SkipLabs/skip/tree/main">
      <img src="https://dl.circleci.com/status-badge/img/gh/SkipLabs/skip/tree/main.svg?style=svg" alt="CI status" />
    </a>
  </p>
</div>

This repository contains the Skip Framework for building reactive backend services, the Skiplang toolchain that powers its native runtime, and SKDB, a reactive SQL database built on Skip.

## Contents

- [Skip Framework](#skip-framework)
- [Skiplang toolchain](#skiplang-toolchain)
- [SKDB](#skdb)
- [Contributing](#contributing)
- [License](#license)

## Skip Framework

Skip is an open-source framework for building _reactive_ backend services.

It is based on a custom-built native backend for efficient reactive computation, allowing your system to deliver up-to-date and correct results without requiring any bug-prone manual dependency tracking and updating.

TypeScript interfaces and abstractions are provided so that you can write a reactive service using standard tools while also taking advantage of the Skip framework's abstractions for efficient reactivity.

### Installation

To get started, install the skip NPM package:

```
npm install @skiplabs/skip
```

Two versions of the runtime are available, a Wasm `@skipruntime/wasm` and a native `@skipruntime/native`.
The Wasm runtime is installed by default. It works with both `node` and `bun`, but is limited to Wasm's 32-bit memory address space.
The native runtime does not have this limitation, but it is currently only available for Node on Linux (`amd64` or `arm64`) with glibc ≥ 2.41 (Debian 13+, Ubuntu 24.04+, RHEL 10+), and is a bit more involved to install (see [instructions](./INSTALL.md)).

From there, you're ready to start building a reactive service!
See the [getting started guide](https://skiplabs.io/docs/getting_started) to walk through some of Skip's core concepts by example and get up to speed.

### Documentation

See our documentation [here](https://skiplabs.io/docs) for introductions to the core concepts, components, and features of the Skip framework, or dive into the [API docs](https://skiplabs.io/docs/api/core) for comprehensive explanations of our TypeScript interfaces and abstractions.

### Examples

Some small examples of reactive services are [available](./skipruntime-ts/examples), demonstrating patterns of reactive programming.
Another [example](./examples/hackernews) is designed to serve as an example of how to deploy and configure a reactive service, using Docker compose to package and orchestrate a backend complete with a reactive service, database, backend web service, and reverse proxy.

## Skiplang toolchain

The Skip Framework's native runtime is implemented in Skiplang. The compiler, runtime, and surrounding tools (`skargo`, `sktest`, …) live under [`skiplang/`](./skiplang). See [INSTALL.md](./INSTALL.md) for instructions on building the toolchain from source.

## SKDB

SKDB is a reactive SQL database, part of the Skip ecosystem. The TypeScript client is published as the [`skdb`](https://www.npmjs.com/package/skdb) NPM package; sources for the client, server, and runtime live under [`sql/`](./sql).

## Contributing

We welcome contributions and pull requests and are happy to help you get started!
The issue tracker is kept up-to-date with our roadmap and is a good place to begin if you're looking for ideas of ways to contribute.

You can also join our [Discord](https://discord.gg/bsnXyw2F9P) to ask any questions or get involved.

## License

Skip is [MIT licensed](./LICENSE).
