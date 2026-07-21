---
title: Verify the description, not the effect
description:  How does a closed-loop coding agent verify a side effect it can't cheaply or totally observe? By checking the effect's description against a fixed contract, not the effect itself.
slug: side_effects
date: 2026-06-03
authors: hubyrod
image: /img/og/side_effects.png
---

Of all the questions under the launch post, one actually mattered. How does a closed loop close on side effects? Sending an email. Logging to Sentry. And the harder version: calling an internal service at a big company, where there's no public sandbox and no shared test environment to point at.

It's the right question, because it's the one that should break the pitch if we got the architecture wrong. A verify-loop is convincing when the thing it checks is cheap and total to check. Side effects are neither.

<!--truncate-->

So let me answer it honestly. Which means starting with what we don't do.

## The honest part first

When we say Skipper [closes the loop](https://skiplabs.io/blog/closed_loop_coding_agent), we mean it the way control theory means it: the feedback signal has to be trustworthy enough to act on.

Type-checking and deterministic execution give us that. They're cheap to run, and the verdict is total. The check passes for every input or it doesn't, and we don't have to believe a story about it.

A side effect gives us none of that. You can't cheaply verify that an email arrived. You can't verify it totally either, because the answer lives on someone else's mail server on a Tuesday.

So the loop doesn't check whether the effect happened. It checks whether the effect was described correctly. That distinction is the whole post.

## We already do this. It's called a compiler.

We didn't invent this for AI. Compilers have done it for 50 years.

A C compiler verifies that your call to `send()` matches its declared signature, every argument type and the return shape, and it does that without ever opening a socket. It has never once sent a packet to find out whether your code is correct. That's the whole trick.

[Treat Agent Output Like Compiler Output](https://skiplabs.io/blog/codegen_as_compiler) argued we should treat agent output the same way: stop reading each artifact by hand, build the verification into the process that produces it. Side effects are where that argument has to prove it isn't hand-waving. They're the one place people assume the compiler move can't reach. The three pieces below are what reaching looks like.

## 1. Effects are typed values

Anything that touches the outside world (an email send, an HTTP call, a hash, a database write) isn't an opaque call the model drops wherever it likes. You declare it up front as a typed *external*: a fixed contract of inputs, outputs, and params.

There's a rule the reactive core enforces with no exceptions. The core can't do I/O at all. The deterministic, reactive part of a Skipper service never touches the network. An effect executes in exactly one sanctioned place: a separate subprocess at the edge, reached through a generated wrapper.

So the loop's job here is narrow and decidable. It checks that the constructed effect type-checks against its contract. Execution gets deferred across the boundary. The model describes the email send. It can't smuggle a socket into the part of the program we're trying to prove things about.

## 2. The sandbox runs against typed doubles

For the loop to run a service end to end, the boundary needs something on the other side. That something is a stub. Each external call gets pinned to a typed mock record: given these params, return this value, or this error.

An email send becomes `called with {to, subject, body}, returns sent`, and the assertion lives in the handler that consumes the result. The model's call site has to match the declared intent or the test fails. You can't hide a malformed payload, because the payload's shape is part of the contract.

Reactive computation, the [Skip Runtime](https://skiplabs.io/blog/cache_invalidation) the whole thing runs on, makes those outputs reproducible from the same inputs. Same inputs, same graph, same result, every run. So the verification pass is deterministic without ever touching the network. We're not flaking on some third-party rate limit while trying to decide whether the code is correct. We keep those problems apart on purpose.

## 3. The contract is the unit of verification

Here's where the big-company question gets its real answer.

You hand Skipper an OpenAPI spec, or a prompt it derives one from, and from that point, for that run, the spec is frozen. It's the fixed reference. The agent codes against it. The loop type-checks against it, unit-tests against it, validates every call site against it. The typed stubs derived from the externals are what let the generated code actually run.

Look at what that does to the "no cross-company sandbox" problem. It dissolves it. There was never going to be a live internal service inside the verification loop, and there doesn't need to be. The interface is fixed, so the model's stochasticity is contained even when the implementation is remote, proprietary, and sitting behind 3 VPNs you've never heard of.

Verification happens against the contract. The live service never enters the loop, so its absence costs you nothing. You need their types, and that's it.

## What the loop will not tell you

Here's the part I'd rather say out loud than have you find out later.

The loop does not claim the effect succeeded in production. It doesn't promise the email reached an inbox, that Sentry ingested the event, that the internal service was even reachable when your code ran for real. Delivery, idempotency, retries: that's the subprocess at the edge running against real credentials, outside the verification loop.

We keep that integration layer visible and separate instead of folding it into the word "verified." I'm doing that on purpose. A closed loop with a dishonest sensor is just an unstable system with extra steps, flying the plane confidently into the ground.

"Verified" has to mean exactly one thing, or it means nothing. Here it means the code is type-correct against the contracts and runs deterministically against them. Whether the third party 3 time zones away is having a good day is a separate question, and the loop doesn't pretend to answer it.

The model is stochastic. The pipe around it isn't. Side effects don't change that. Quietly pretending the loop covers delivery would, so it doesn't, and it says so.
