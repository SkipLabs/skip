# Getting started

## Installation

Before you begin, we recommend installing the NPM packages for the Skip API, server, client, and helpers.

```npm install @skipruntime/api @skipruntime/server @skipruntime/client @skipruntime/helpers```

## Introduction

We have several resources available to help you learn the Skip framework, depending on your bcakground and preferences.

This guide takes a "top-down" approach, showing you how to use our latest APIs in an idiomatic and practical way.  We recommend that most users start here.

Alternatively, you can work from the "bottom-up" by reading our [Skip fundamentals](TODO:docusaurus link) tutorial, which explains the concepts and components of the Skip runtime from first principles.

Finally, if you'd like to just get your hands dirty and dive into the code, you can explore [examples](TODO: docusaurus link) of reactive services, [API docs](TODO: docusaurus link), or a before/after [example](TODO: docusaurus link) of retrofitting a legacy service with reactive features.

## Tutorial

This guide will walk you through getting your first reactive service up and running using the Skip runtime.
It will also show how to write client code to read or subscribe to data from your reactive service.

We aim to make this as beginner friendly as possible, but assume a basic understanding of imperative programming, including core JavaScript/Typescript syntax and semantics.

### Reactive Programming

Skip is a framework for building _reactive_ software which is responsive to changing inputs in real-time, efficient to execute, and intuitive to write and reason about.

From the outside, reactive services can be treated similarly to streaming sources: they push real-time updates to clients and other subscribers, supporting smooth real-time user experiences.
Unlike event-based streaming frameworks, though, Skip programs are written in a declarative style: instead of reasoning about updates directly, you write code that reasons about a "current" snapshot of state, and the Skip framework automatically processes changes and keeps everything in sync.

In order to do so, Skip tracks dependencies such that a change to an input can be propagated through that dependency graph without re-evaluating computations whose inputs haven't changed.

Therefore, while reading this guide and working with the Skip framework, it is crucial to reason about (im)mutability and side-effects in your code so that it can be reliably evaluated by the framework.
