---
title: What a Closed-Loop Coding Agent Actually Is
description: Closed-loop control requires a feedback signal trustworthy enough to act on. Most AI coding agents close their loops on lossy sensors, tests, unsound types, model judgment, and inherit the instability that follows. Skipper is built on sound signals with SKJS, deterministic execution, and reactive computation.
slug: closed_loop_coding_agent
date: 2026-04-24
authors: hubyrod
image: /img/skip.png
---

Skipper is a closed-loop coding agent. That sentence does more work than it looks like. "Closed-loop" got borrowed by the industry without anyone inheriting what it actually means. Most agents called closed-loop aren't. And once you see why, you see what Skipper is doing differently.

## What closed-loop meant before we borrowed it

Closed-loop control comes from control theory. An autopilot reads altitude, compares it to the target, nudges the elevators based on the error. The defining property isn't that a loop exists. It's that **the feedback signal is trustworthy enough to act on**.

An autopilot with a broken altimeter will fly the plane into the ground. Confidently. Autonomously. In perfect mechanical closure.

Control theorists know this. They obsess over sensor fidelity, because a closed loop with a bad sensor isn't a stable system. It's an unstable one with extra steps.

{/* truncate */}

Medical devices go further. An artificial pancreas is closed-loop. A glucose monitor that beeps at a human to dose insulin is not. The line isn't drawn at the loop. It's drawn at whether the signal is sound enough to take the human out. You earn closed-loop autonomy through signal quality. You can't declare it through architecture.

## What most agent loops actually close on

So look at what a typical coding agent feeds back into its next decision:

- **Test output.** Tests are samples, not proofs. The agent can pass them without satisfying the intent. Sometimes by editing the test.
- **Linter and type-checker output.** Useful, but TypeScript's type system is unsound by design. A green check means "I couldn't find a contradiction in the bit I can see." It doesn't mean correct.
- **Runtime logs.** Noisy, incomplete, silent on the failures you actually care about.
- **Model-based judgment.** The agent's own confidence, or a second model with the same blind spots. Either way, the signal is the thing you were trying to check.

Every one of these is a lossy sensor. It drops information about the thing it's supposed to measure. The loop still closes mechanically. Output feeds back into the next decision. But what flows through it is a low-fidelity proxy for correctness.

And because the agent acts on that proxy with full autonomy, small signal errors compound into the failure modes we all recognize:

- The agent deletes the failing test and declares victory.
- The agent ships code that type-checks fine but violates an invariant the types can't express.
- The agent loops for 40 minutes polishing a solution that was already correct on attempt 3, because nothing in the signal told it to stop.
- The agent drifts. Each step is locally plausible. The trajectory is nonsense.

These aren't bugs in the agents. They're what closed-loop control does when the sensor is lossy. Control theory called this decades ago. We're rediscovering it the hard way.

## A physics problem, not a craftsmanship problem

Here's the part worth sitting with. No amount of prompt engineering, scaffolding, or agent-framework cleverness fixes a lossy feedback signal. You can tune the controller all day. If the altimeter is wrong, the altitude is wrong. The ceiling on an agent's reliability is the trustworthiness of what it closes the loop on.

So the real question when you're evaluating an AI coding tool isn't *how autonomous is the loop*. It's *what does the loop close on, and how much can you trust it?*

A sound type checker closes a better loop than an unsound one. A deterministic execution environment closes a better loop than a flaky one. A reactive system that recomputes only what changed closes a better loop than one that re-runs everything and re-derives confidence from noise. These are sensor upgrades. They're what lets the loop actually control something.

This is what Skipper is built on. SKJS is a fully sound TypeScript-compatible type checker, so when Skipper's loop closes on a type signal, that signal means what it says. Execution is deterministic, so "it worked" is reproducible instead of probabilistic. Computation is reactive, so feedback is precise instead of a fog of re-runs. Three sensor upgrades. Together they're what lets Skipper close the loop at all.

## Why this matters

The industry has been iterating hard on the controller. Better prompts, better scaffolds, better planning. And treating the feedback signal as given. The feedback signal was never given. It's the variable that decides whether your autonomous loop is closed-loop or just an unstable one in a costume.

Skipper closes the loop because Skipper took the sensor seriously. Everything else in the category is running open-loop with confidence it hasn't earned.