# Hacking on skip

This document is a perpetually under construction collection of tips and potentially useful information for people hacking on the skip implementation.

### Developer workflow

TL;DR: During development, do not invoke `npm` commands directly, use the `make` targets.

The npm package configuration files are set up to optimize the end-user scenario, where the native addon uses a binary release of the skipruntime. In contrast, during development it is generally desired to use the currently unreleased version of the skipruntime. To support both of these scenarios, directly invoked `npm` commands follow code paths that lead to using released skipruntime binaries, and `npm` commands invoked by `make` follow code paths that lead to building the current skipruntime sources and using that. In particular, `skipruntime-ts/Makefile` sets `SKIPRUNTIME_VERSION`, `LDFLAGS`, and `LD_LIBRARY_PATH` environment variables.

### Code formatting

There is a CI job that checks that code is auto-formatted by running `make check-fmt`.
This can be run manually prior to submitting a PR if desired.
If desired, a git pre-commit hook that automatically formats changed files when committing can be installed by running `make setup-git-hooks`.

### Building skip client in Docker against unreleased skip packages

Sometimes it is useful to be able to build a skip client against locally modified, unreleased, skip framework packages.

In some cases, `npm link` can be used to create a symbolic link in the client code's `node_modules` that points to the locally modified skip package.
If the client runs in docker, however, this approach does not work since the target of the link will not be available in the container.

An alternative is to use `npm pack`. For example:
```
> cd path/to/skip
> mkdir path/to/client/pack
> npm pack --pack-destination path/to/client/pack -w skipruntime-ts/core
```
This creates a tarball of the `@skipruntime/core` package in `path/to/client/pack` directory.
Any other packages desired from the list of workspaces in `skip/package.json` can be added with `-w` flags.
Then the client's `package.json` needs to be modified to install from the tarball instead of the network.
Modify `packages.json` replacing a line such as:
```
    "@skipruntime/core": "0.0.12",
```
with
```
    "@skipruntime/core": "file:/./pack/skipruntime-core-0.0.12.tgz",
```
Next check the client's `Dockerfile` to ensure that the `pack` directory is copied into the container; for example it may be necessary to add `COPY pack pack` before `RUN npm install`.
Then proceed with the client build, such as:
```
> cd path/to/client
> docker compose up --build
```
