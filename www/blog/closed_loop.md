---
title: What a Closed-Loop Coding Agent Actually Is
description: Closed-loop control requires a feedback signal trustworthy enough to act on. Most AI coding agents close their loops on lossy sensors, tests, unsound types, model judgment, and inherit the instability that follows. Skipper is built on sound signals with SKJS, deterministic execution, and reactive computation.
slug: closed_loop_coding_agent
date: 2026-04-24
authors: hubyrod
image: /img/skip.png
---

Skipper is a closed-loop coding agent. That sentence is doing more work than it looks like, because "closed-loop" has become one of those terms the industry borrows without inheriting what it means. Most agents described as closed-loop aren't. Understanding why is the fastest way to understand what Skipper is actually doing differently.

## What closed-loop meant before we borrowed it

Closed-loop control comes from control theory. An autopilot measures altitude, compares it to the target, and adjusts the elevators based on the error. The defining property isn't that a loop exists. It's that the **feedback signal is trustworthy enough to act on**. An autopilot with a miscalibrated altimeter will fly the plane into the ground, confidently, autonomously, in perfect mechanical closure.

Control theorists know this. They spend a lot of time on sensor fidelity, because a closed loop with a bad sensor isn't a stable system. It's an unstable one with extra steps.

Medical devices are stricter still. An artificial pancreas is closed-loop; a continuous glucose monitor that alerts a human to dose insulin is not. The distinction isn't the loop, it's whether the signal is sound enough to *warrant* removing the human. Closed-loop autonomy is earned by signal quality, not declared by architecture.

{/* truncate */}

## What most agent loops actually close on

Now look at what a typical coding agent closes its loop on:

- **Test output.** Tests are samples, not proofs. The agent can satisfy them without satisfying the intent, most notoriously by modifying the test.
- **Linter and type-checker output.** Useful, but TypeScript's type system is unsound by design. A green check means "no detected contradiction in the fragment we can analyze," not "this is correct."
- **Runtime logs.** Noisy, incomplete, often silent on the interesting failures.
- **Model-based judgment.** The agent's own confidence, or a second model with the same blind spots. Either way, the signal is the thing we were trying to check.

Each of these is a lossy sensor. The loop closes mechanically, output feeds back into the next decision, but what flows through it is a low-fidelity proxy for correctness. And because the agent acts on that proxy with full autonomy, small signal errors compound into the failure modes we all recognize:

- The agent deletes the failing test and declares victory.
- The agent ships code that type-checks nominally but violates an invariant the types can't express.
- The agent loops for forty minutes polishing a solution that was already correct on attempt three, because nothing in the signal told it to stop.
- The agent drifts: each iteration is locally plausible, the cumulative trajectory is nonsense.

These aren't bugs in the agents. They're what closed-loop control does when the sensor is lossy. Control theory predicted this decades ago. We're rediscovering it.

## The physics problem, not the craftsmanship problem

This is the point worth internalizing: no amount of prompt engineering, scaffolding, or agent-framework sophistication fixes a lossy feedback signal. You can tune the controller all you want; if the altimeter is wrong, the altitude is wrong. The ceiling on an agent's reliability is the fidelity of what it closes the loop on.

Which means the real question for anyone evaluating AI coding tools isn't *how autonomous is the loop*. It's *what does the loop close on, and how much can you trust it?*

A sound type checker closes a better loop than an unsound one. A deterministic execution environment closes a better loop than a flaky one. A reactive system that recomputes only what actually changed closes a better loop than one that re-runs everything and re-derives confidence from noise. These aren't nice-to-haves, they're the sensor upgrades that let the loop actually control something.

This is what Skipper is built on. SKJS is a fully sound TypeScript-compatible type checker, so when Skipper's loop closes on a type signal, that signal means what it says. Execution is deterministic, so "it worked" is reproducible rather than probabilistic. Computation is reactive, so feedback is precise rather than a fog of re-runs. Each of those is a sensor upgrade. Together they are what lets Skipper close the loop at all.

## Why this matters for the category

The industry has been iterating hard on the controller, better prompts, better scaffolds, better planning, and treating the feedback signal as given. The feedback signal was never given. It's the variable that decides whether an autonomous loop is a closed-loop system or an unstable one wearing its costume.

Skipper is the closed-loop coding agent because it's the one that took the sensor seriously. Everything else in the category is running an open loop with extra confidence.

