# Data sources and destinations

Skip is designed to carefully track the computation and data dependencies of
your application, so that outputs can be efficiently updated if (and only if!)
any inputs they depend upon change.  However, when those inputs are from
non-Skip sources -- databases, external systems or APIs, non-reactive internal
systems, and the like -- it is crucial to ensure that your reactive service
still produces up-to-date results.

Skip provides a simple and easy-to-use mechanism to address this situation: by
defining and using _refresh tokens_, you can ensure that any non-reactive inputs
are kept as fresh as your application requires.

## Overview

A reactive service can define any number of refresh tokens, each of which
associates a string identifier with a refresh interval, given in milliseconds.
Skip then maintains an internal data structure with a timestamp for each token
that is refreshed at the specified frequency.

When a Skip computation calls `SKStore.getRefreshToken` to get the latest
timestamp for some refresh token, it incurs a dependency on that token.  Thus,
it will be re-executed periodically and can produce outputs or intermediate data
structures which depend on the latest timestamp.

## REST and legacy APIs

## Databases

## Streaming sources

TODO: set up an example with a streaming source!
