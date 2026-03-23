---
title: Code Was Never for Machines — Until Now
description: If agents are now writing code, should our tools still be optimized for humans? Why we'll resist this shift — and why we'll make it anyway.
slug: future_of_tools_for_ai
date: 2026-03-11
authors: hubyrod
image: /img/skip.png
---

In my last post, I argued that we should treat agent output the way we treat compiler output: not something to be read and reviewed by humans, but something to be verified by process. The framing resonated with a lot of people, but it leaves a deeper question on the table.

If agents are now the primary authors of code, should the tools and languages those agents use still be optimized for humans?

I don't think they should. And the history of programming languages tells us exactly why we'll resist that change — and why we'll embrace it anyway.

{/* truncate */}

## Programming Was Always a Human-Readability Project

Every major leap forward in programming language design has been, at its core, a leap toward human legibility. Assembly gave way to C because humans could reason about it. C gave way to higher-level languages because abstraction made programs easier to hold in a person's head. And at the far end of that arc, you get Python and Ruby: languages whose defining virtue is that they read almost like English prose.

Python's indentation rules aren't a technical necessity — they're a readability convention enforced by the language itself. Ruby's syntax is deliberately soft, forgiving, close to natural language. The TIOBE index (a widely cited ranking of programming language popularity) doesn't measure what's technically optimal. It measures what engineers want to write and read. For decades, those were the same thing.

The tools followed the same logic. Error messages were written for people. Outputs were formatted for terminal reading. Type systems were made optional or loosened to reduce friction for the human author. Everything was, and still is, optimized for the person sitting at the keyboard.

## Hack and the Last Time We Had This Argument

We've been here before, though the stakes were smaller.

When Julien Verlaguet and the team at Facebook created Hack, they were solving a specific problem: PHP, the language powering the entire Facebook codebase, was fundamentally type-unsafe. At the scale Facebook operated, that wasn't just an aesthetic problem, it was an engineering liability. You couldn't refactor with confidence. You couldn't catch entire classes of bugs statically. The language was optimized for the speed of a solo developer writing web pages, not for the discipline of thousands of engineers maintaining hundreds of millions of lines.

So Julien built Hack: a gradually-typed, rigorously annotated replacement that was strictly less pleasant to write than PHP. It was more verbose. It demanded precision. It required you to say exactly what you meant. And then they got every engineer at Facebook to switch.

The rollout did not go smoothly at first. Engineers pushed back hard. They asked for escape hatches — ways to keep writing PHP in the parts of the codebase they owned. They requested exemptions, delayed migration timelines, special-case bypasses. Some wanted help porting their code, others simply wanted to be left alone. The friction was real and sustained.

But the org held the line. The resistance gave way not because engineers were eventually won over by argument, but because the environment made staying on PHP progressively harder. The CI pipeline was tightened incrementally — more checks, stricter gates, less tolerance for untyped code — and the hierarchy didn't offer the opt-outs people asked for. The path of least resistance slowly became compliance.

## Agents Don't Need the Training Wheels

A coding agent doesn't need readable syntax. It doesn't need forgiving type semantics. It doesn't need terse, human-friendly error messages. It needs the opposite.

An agent benefits from verbosity. Long, precise, unambiguous tool outputs are easier to parse than short, clever, human-optimized ones. An agent benefits from pedantic execution — systems that fail loudly and specifically when something is wrong, rather than silently coercing types or swallowing errors in the name of developer experience. An agent benefits from strong type systems not because it needs guardrails, but because types are the most information-dense way to describe what code is supposed to do.

When a human reads an error message, you want it to be concise, sympathetic, maybe even helpful in a narrative sense. When an agent reads an error message, you want it to be complete, structured, and machine-parseable. These are different optimization targets that have been collapsed into one because until recently, the reader was always human.

The same applies to tool APIs, CLI outputs, documentation formats, error codes. All of it was designed for a human consumer. That assumption is now in question.

## The Coming Divergence

I expect we'll see a bifurcation in tooling. On one side, languages and tools that continue to optimize for human authors — and there will always be human authors. On the other, a new generation of tools designed with the agent as the primary consumer: strict, verbose, formally specified, hostile to ambiguity.

This is what we're building toward at SkipLabs. SKJS, our TypeScript-compatible type checker, is sound in ways that standard TypeScript isn't. That makes it harder for humans and better for agents. Our reactive runtime enforces explicit dependency contracts that would feel over-engineered to a developer writing code by hand, and are exactly right for an agent that needs to reason about what depends on what.

The pattern is consistent: pedantry that felt like friction when humans were the authors becomes an asset when the author is an agent operating at scale.

## Why We'll Resist This, and Why We'll Do It Anyway

Julien's engineers resisted the switch to Hack. PHP felt natural. Hack felt bureaucratic. And they made the switch because the system-level argument was overwhelming.

We'll resist this transition for the same reason: the new tools will feel worse to write, and they will be worse to write, by human standards. That's not a design failure — it's a deliberate optimization for a different consumer. The discomfort is the point.

But the system-level argument is, again, overwhelming. If agents are generating the bulk of code, and the tools those agents use are designed around human readability, we're leaving enormous capability on the table. We're asking the agent to work in a medium optimized for someone else.

We made the tools more readable to get more developers. We'll make them less readable — more precise, more formal, more machine-native — to get better agents. The readability era of programming languages was long and productive, and is now coming to an end.

---

*This post follows [Treat Agent Output Like Compiler Output](https://skiplabs.io/blog/codegen_as_compiler).*
