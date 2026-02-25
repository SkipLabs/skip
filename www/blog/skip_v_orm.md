---
title: Skip and Traditional ORMs Contrasted
description: Why Reactive Programming with Skip Beats Traditional ORMs
slug: skip-v-orm
date: 2025
authors: jberdine, jverlaguet
---

# Why Reactive Programming with Skip Beats Traditional ORMs

When building data-driven applications developers often turn to ORMs (Object-Relational Mappers) to interact with databases using familiar object-oriented paradigms.
But ORMs come with tradeoffs—inflexible caching, inconsistency issues, and unpredictable or untunable performance due to hidden database interactions.
Enter *Skip*, a reactive programming framework designed to eliminate those issues from the ground up.

In this post, we will explore how Skip rethinks data flow and object access by treating everything as part of a *reactive computation graph*, and why this makes traditional ORM problems virtually disappear.

<!-- truncate -->

## Skip: A Framework for Reactive Computation

At its core, *Skip is a reactive programming framework* that allows developers to define *collections* and *mappers* / *transformations* over those collections.
These transformations are *stateless and deterministic*, making the system easier to reason about.
The collections and mappers form a *reactive computation graph* where the collections are the *vertices* and the mappers are the *edges*.
Crucially, the Skip framework ensures that the outputs update automatically as inputs change.

Interestingly, Skip supports *cross-language transformations*.
For instance, you can define a mapper in Java, even if the rest of the graph is implemented in another language.
To do that, Skip provides a mechanism to define schemas and auto-generates proxies, ensuring the Java side can safely access data without compromising consistency or immutability.

The generating-proxies-from-schemas aspect may seem reminiscent of traditional ORMs, but the core design of the Skip framework avoids the major issues with ORMs.

## The Pitfalls of ORMs

ORMs are popular because they make databases feel like simple object hierarchies.
But under the hood they introduce two major problems:

### 1. Caching:

To avoid repeated expensive database accesses, and to avoid having multiple objects which copy / proxy the same data from the database, ORMs use caching.
This creates a risk of *stale or inconsistent data*, as cached objects may not reflect the current state of the database.

### 2. Mutability and Side Effects:

ORM objects are often mutable, and it’s not always clear when changes are persisted.
This leads to challenges with transactionality, especially when updating multiple related objects.
Performance can also suffer, as innocuous object updates may trigger unintended writes.
Furthermore, if an ORM avoids the heavy-weight caching required to ensure that there is a single object for each one in the database, then it ends up allowing multiple objects copying the data in the database, leading to inconsistencies when modified.

## How Skip Solves These Problems

### 1. No More Cache Inconsistencies

In Skip, *everything is reactive*, including the layers between the database and the business logic.
This means that data is *automatically updated* across all parts of the system.
When you access an object in Java, it’s already in sync with the rest of the system—*no manual cache invalidation required*.

This is particularly useful when reshaping raw database data into more usable forms (like joining user and address tables).
In traditional systems, this transformation is expensive and error-prone.
In Skip, the transformations are reactive and automatically consistent.

### 2. Immutable, Ephemeral Handles

Skip passes data between languages using *handles*—lightweight, ephemeral proxies that you can read but cannot store or mutate.
Trying to store or modify a handle outside its intended scope results in an error.
This enforces a *clear separation between read and write paths*, eliminating side effects due to accidental mutations.

Unlike ORMs, where writing data often feels implicit and ambiguous, Skip enforces *explicit, separate write logic*, leading to more robust and predictable code.

## Final Thoughts

The problems commonly associated with ORMs—caching, mutability, inconsistent states—don’t exist in a reactive system like Skip.
With *automatic consistency, immutability, and cross-language support*, Skip enables developers to build complex systems without the fragility of traditional data access layers.

Reactive programming with Skip doesn’t just solve old problems—it encourages a new, cleaner way of thinking about how data flows through your application.
